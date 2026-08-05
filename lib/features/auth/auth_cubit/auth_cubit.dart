import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/auth/domain/usecases/build_authenticated_user_usecase.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

enum _SignInProvider { google, apple }

@lazySingleton
@Environment(Env.minimal)
class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepo;
  final BuildAuthenticatedUserUsecase _buildAuthenticatedUser;

  AuthCubit(this._userRepo, this._buildAuthenticatedUser)
    : super(AuthLoading()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    await _userRepo.updateBannedWords();

    // Step 1: Check Firebase authentication
    final firebase_auth.User? firebaseUser =
        AuthService.instance.currentFirebaseUser;

    if (firebaseUser != null) {
      await _handleAuthenticatedUser(firebaseUser);
      return;
    }

    // Step 2: Check local storage for guest user
    final bool hasToken = await AuthService.instance.userHasToken();

    if (hasToken) {
      try {
        final UserEntity user = await _userRepo.getCurrentUser();
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        await createNewUser();
      }
      return;
    }

    // Step 3: Create new guest user
    await createNewUser();
  }

  Future<void> googleSignIn() => _signIn(
    provider: _SignInProvider.google,
    signIn: AuthService.instance.signInWithGoogle,
  );

  Future<void> appleSignIn() => _signIn(
    provider: _SignInProvider.apple,
    signIn: AuthService.instance.signInWithApple,
  );

  Future<void> _signIn({
    required _SignInProvider provider,
    required Future<firebase_auth.UserCredential?> Function() signIn,
  }) async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      final userCredential = await signIn();

      if (userCredential == null) {
        // User canceled - return to previous state
        debugPrint('${provider.name} sign-in canceled');
        emit(
          currentState.copyWith(
            signInOutLoading: false,
            effect: AuthEffect.signInFailure,
          ),
        );
        return;
      }

      final firebaseUser = userCredential.user!;
      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);
      final syncedUser = await getIt<CloudSyncService>().syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: currentState.user,
        cloudUserDoc: cloudUserDoc,
      );

      await _userRepo.updateUser(syncedUser);
      await AuthService.instance.saveToken(firebaseUser.uid);

      emit(
        AuthAuthenticated(user: syncedUser, effect: AuthEffect.signInSuccess),
      );
    } catch (e) {
      debugPrint('Error signing in with ${provider.name}: $e');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    }
  }

  Future<void> signOut() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      await AuthService.instance.signOut();

      if (state is! AuthAuthenticated) return;

      final currentUser = (state as AuthAuthenticated).user;
      final guestUser = UserModel.guest(
        id: currentUser.id,
        points: currentUser.points,
        progressByLanguage: currentUser.progressByLanguage,
        lastSyncedAt: currentUser.lastSyncedAt,
        joinedAt: currentUser.joinedAt,
        totalFreezes: currentUser.totalFreezes,
      );

      await _userRepo.updateUser(guestUser);
      emit(
        AuthAuthenticated(user: guestUser, effect: AuthEffect.signOutSuccess),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signOutFailure,
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(deleteAccountLoading: true));

    try {
      await _performAccountDeletion(currentState.user);
    } catch (e) {
      emit(currentState.copyWith(deleteAccountLoading: false));
      rethrow;
    }
  }

  Future<void> reauthenticateAndDeleteAccount() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(deleteAccountLoading: true));

    try {
      switch (_currentSignInProvider()) {
        case _SignInProvider.apple:
          await AuthService.instance.reauthenticateWithApple();
        case _SignInProvider.google:
          await AuthService.instance.reauthenticateWithGoogle();
      }

      await _performAccountDeletion(currentState.user);
    } catch (e) {
      emit(currentState.copyWith(deleteAccountLoading: false));
      rethrow;
    }
  }

  Future<void> _performAccountDeletion(UserEntity user) async {
    await AuthService.instance.deleteAccount(
      userId: user.id,
      isGuest: user.isGuest,
    );
    await createNewUser(afterDeletion: true);
  }

  _SignInProvider _currentSignInProvider() {
    final providerIds =
        AuthService.instance.currentFirebaseUser?.providerData.map(
          (info) => info.providerId,
        ) ??
        const <String>[];

    return providerIds.contains('apple.com')
        ? _SignInProvider.apple
        : _SignInProvider.google;
  }

  Future<void> _handleAuthenticatedUser(firebase_auth.User firebaseUser) async {
    final bool hasInternet = await getIt<ConnectivityService>().hasInternet();

    if (!hasInternet) {
      await _emitLocalOnlyUser(firebaseUser);
      return;
    }

    DocumentSnapshot? cloudUserDoc;
    try {
      cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);
    } catch (e) {
      // Can't verify cloud state right now (network/permissions/etc) - fall
      // back to local data rather than risk creating or overwriting the
      // real cloud document based on a guess.
      debugPrint('Could not reach cloud, using local user for now: $e');
      await _emitLocalOnlyUser(firebaseUser);
      return;
    }

    final localUser = await _tryGetLocalUser();

    try {
      if (cloudUserDoc == null) {
        final newUser = _buildAuthenticatedUser(
          id: firebaseUser.uid,
          username: firebaseUser.displayName,
          email: firebaseUser.email,
          localUser: localUser,
          fallbackTotalFreezes: getIt<FreezeCubit>().state.totalFreezes,
        );

        await _userRepo.createFirebaseUser(newUser);
        await _saveUserAndToken(newUser, firebaseUser.uid);
        emit(AuthAuthenticated(user: newUser));
        return;
      }

      final syncedUser = await getIt<CloudSyncService>().syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: localUser,
        cloudUserDoc: cloudUserDoc,
      );

      await _saveUserAndToken(syncedUser, firebaseUser.uid);
      emit(AuthAuthenticated(user: syncedUser));
    } catch (e) {
      debugPrint('Error finishing authenticated sign-in: $e');
      emit(
        AuthFailure(
          message:
              'Failed to initialize user. Please try again or contact support.',
        ),
      );
    }
  }

  Future<void> _emitLocalOnlyUser(firebase_auth.User firebaseUser) async {
    final localUser = await _tryGetLocalUser();

    final user =
        localUser ??
        _buildAuthenticatedUser(
          id: firebaseUser.uid,
          username: firebaseUser.displayName,
          email: firebaseUser.email,
          fallbackTotalFreezes: getIt<FreezeCubit>().state.totalFreezes,
        );

    await _userRepo.updateUser(user);
    emit(AuthAuthenticated(user: user));
  }

  Future<UserEntity?> _tryGetLocalUser() async {
    try {
      return await _userRepo.getCurrentUser();
    } catch (e) {
      debugPrint('No local user found');
      return null;
    }
  }

  Future<void> _saveUserAndToken(UserEntity user, String id) async {
    await _userRepo.updateUser(user);
    await AuthService.instance.saveToken(id);
  }

  Future<void> createNewUser({bool afterDeletion = false}) async {
    if (afterDeletion) {
      emit(AuthUnauthenticated());
      await Future.delayed(Duration(seconds: 2));
    }
    final String newToken = TokenUtils.generateGuestToken();
    await AuthService.instance.saveToken(newToken);

    final UserEntity user = await _userRepo.createUser(newToken);

    emit(AuthAuthenticated(user: user));
  }

  void updateUser(UserEntity user) {
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(user: user));
    }
  }
}
