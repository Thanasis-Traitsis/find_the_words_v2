import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'auth_state.dart';

@lazySingleton
@Environment(Env.minimal)
class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepo;

  AuthCubit(this._userRepo) : super(AuthLoading()) {
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

  Future<void> googleSignIn() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      // Attempt Google Sign-In
      final firebase_auth.UserCredential? userCredential = await AuthService
          .instance
          .signInWithGoogle();

      if (userCredential == null) {
        // User canceled - return to previous state
        debugPrint('Google Sign-In canceled');
        emit(
          currentState.copyWith(
            signInOutLoading: false,
            effect: AuthEffect.signInFailure,
          ),
        );
        return;
      }

      final firebaseUser = userCredential.user!;
      final syncService = getIt<CloudSyncService>();
      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);
      final syncedUser = await syncService.syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: currentState.user,
        cloudUserDoc: cloudUserDoc,
      );

      await _userRepo.updateUser(syncedUser);
      await AuthService.instance.saveToken(firebaseUser.uid);

      emit(
        AuthAuthenticated(user: syncedUser, effect: AuthEffect.signInSuccess),
      );
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In exception: ${e.code} - ${e.description}');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    }
  }

  Future<void> appleSignIn() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      // Attempt Apple Sign-In
      final firebase_auth.UserCredential? userCredential = await AuthService
          .instance
          .signInWithApple();

      if (userCredential == null) {
        // User canceled - return to previous state
        debugPrint('Apple Sign-In canceled');
        emit(
          currentState.copyWith(
            signInOutLoading: false,
            effect: AuthEffect.signInFailure,
          ),
        );
        return;
      }

      final firebaseUser = userCredential.user!;
      final syncService = getIt<CloudSyncService>();
      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);
      final syncedUser = await syncService.syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: currentState.user,
        cloudUserDoc: cloudUserDoc,
      );

      await _userRepo.updateUser(syncedUser);
      await AuthService.instance.saveToken(firebaseUser.uid);

      emit(
        AuthAuthenticated(user: syncedUser, effect: AuthEffect.signInSuccess),
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple Sign-In exception: ${e.code} - ${e.message}');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    } catch (e) {
      debugPrint('Error signing in with Apple: $e');
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
      final userId = currentState.user.id;
      final isGuest = currentState.user.isGuest;

      debugPrint('Deleting account - isGuest: $isGuest');

      await AuthService.instance.deleteAccount(
        userId: userId,
        isGuest: isGuest,
      );

      await createNewUser(afterDeletion: true);
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
      await AuthService.instance.reauthenticateWithGoogle();

      await createNewUser(afterDeletion: true);
    } catch (e) {
      emit(currentState.copyWith(deleteAccountLoading: false));
      rethrow;
    }
  }

  Future<void> _handleAuthenticatedUser(firebase_auth.User firebaseUser) async {
    try {
      final bool hasInternet = await getIt<ConnectivityService>().hasInternet();

      // If not WiFi - Just return local user
      if (!hasInternet) {
        try {
          final localUser = await _userRepo.getCurrentUser();
          emit(AuthAuthenticated(user: localUser));
          return;
        } catch (e) {
          await _createUserFromFirebaseAuth(firebaseUser);
          return;
        }
      }

      UserEntity? localUser;
      try {
        localUser = await _userRepo.getCurrentUser();
      } catch (e) {
        debugPrint('No local user found');
      }

      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);

      // Firebase user exists but without any data
      if (cloudUserDoc == null || !cloudUserDoc.exists) {
        final newUser = await _createNewAuthenticatedUser(
          firebaseUser,
          localUser,
        );
        await _userRepo.createFirebaseUser(newUser);
        await _saveCloudUserAndToken(newUser, firebaseUser.uid);

        emit(AuthAuthenticated(user: newUser));
        return;
      }

      // Firebase user exists - sync local/cloud data
      final syncService = getIt<CloudSyncService>();
      final syncedUser = await syncService.syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: localUser,
        cloudUserDoc: cloudUserDoc,
      );

      // Save to local storage
      await _saveCloudUserAndToken(syncedUser, firebaseUser.uid);
      emit(AuthAuthenticated(user: syncedUser));
    } catch (e) {
      await _createUserFromFirebaseAuth(firebaseUser);
    }
  }

  Future<UserEntity> _createNewAuthenticatedUser(
    firebase_auth.User firebaseUser,
    UserEntity? localUser,
  ) async {
    final freezeState = getIt<FreezeCubit>().state;

    return UserEntity.authenticated(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      points: localUser?.points ?? AppValues.startingPoints,
      progressByLanguage:
          localUser?.progressByLanguage ??
          {
            AppLanguage.english: ProfileStatusModel.initial(
              AppLanguage.english,
            ),
            AppLanguage.greek: ProfileStatusModel.initial(AppLanguage.greek),
          },
      lastSyncedAt: DateTime.now(),
      joinedAt: localUser?.joinedAt ?? DateTime.now(),
      totalFreezes: localUser?.totalFreezes ?? freezeState.totalFreezes,
    );
  }

  Future<void> _createUserFromFirebaseAuth(
    firebase_auth.User firebaseUser,
  ) async {
    try {
      final newUser = UserEntity.authenticated(
        id: firebaseUser.uid,
        username: firebaseUser.displayName,
        email: firebaseUser.email,
        points: AppValues.startingPoints,
        progressByLanguage: {
          AppLanguage.english: ProfileStatusModel.initial(AppLanguage.english),
          AppLanguage.greek: ProfileStatusModel.initial(AppLanguage.greek),
        },
        lastSyncedAt: DateTime.now(),
        joinedAt: DateTime.now(),
        totalFreezes: 0,
      );

      await _saveCloudUserAndToken(newUser, firebaseUser.uid);
      await _userRepo.updateFirebaseUser(newUser);

      emit(AuthAuthenticated(user: newUser));
    } catch (e) {
      emit(
        AuthFailure(
          message:
              'Failed to initialize user. Please try again or contact support.',
        ),
      );
    }
  }

  Future<void> _saveCloudUserAndToken(UserEntity user, String id) async {
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
