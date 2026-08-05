import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/auth/domain/usecases/create_guest_user_usecase.dart';
import 'package:find_the_words/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:find_the_words/features/auth/domain/usecases/resolve_initial_auth_state_usecase.dart';
import 'package:find_the_words/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

/// Thin orchestrator: every method here maps a UI action to a usecase call
/// and a state transition. The business logic (initial auth resolution,
/// sign-in + cloud sync, account deletion) lives in
/// features/auth/domain/usecases/ - see ResolveInitialAuthStateUsecase,
/// SignInUsecase, DeleteAccountUsecase, CreateGuestUserUsecase.
@lazySingleton
@Environment(Env.minimal)
class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepo;
  final ResolveInitialAuthStateUsecase _resolveInitialAuthState;
  final SignInUsecase _signIn;
  final DeleteAccountUsecase _deleteAccount;
  final CreateGuestUserUsecase _createGuestUser;

  AuthCubit(
    this._userRepo,
    this._resolveInitialAuthState,
    this._signIn,
    this._deleteAccount,
    this._createGuestUser,
  ) : super(AuthLoading()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final user = await _resolveInitialAuthState();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(
        AuthFailure(
          message: e is AuthResolutionFailure
              ? e.message
              : 'Failed to initialize user. Please try again or contact support.',
        ),
      );
    }
  }

  Future<void> googleSignIn() => _performSignIn(
    provider: 'Google',
    signIn: AuthService.instance.signInWithGoogle,
  );

  Future<void> appleSignIn() => _performSignIn(
    provider: 'Apple',
    signIn: AuthService.instance.signInWithApple,
  );

  Future<void> _performSignIn({
    required String provider,
    required Future<firebase_auth.UserCredential?> Function() signIn,
  }) async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      final syncedUser = await _signIn(
        signIn: signIn,
        currentUser: currentState.user,
      );

      if (syncedUser == null) {
        // User canceled - return to previous state
        debugPrint('$provider sign-in canceled');
        emit(
          currentState.copyWith(
            signInOutLoading: false,
            effect: AuthEffect.signInFailure,
          ),
        );
        return;
      }

      emit(
        AuthAuthenticated(user: syncedUser, effect: AuthEffect.signInSuccess),
      );
    } catch (e) {
      debugPrint('Error signing in with $provider: $e');
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

  Future<void> deleteAccount() =>
      _deleteAndRecreateGuest(reauthenticateFirst: false);

  Future<void> reauthenticateAndDeleteAccount() =>
      _deleteAndRecreateGuest(reauthenticateFirst: true);

  Future<void> _deleteAndRecreateGuest({
    required bool reauthenticateFirst,
  }) async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(deleteAccountLoading: true));

    try {
      await _deleteAccount(
        user: currentState.user,
        reauthenticateFirst: reauthenticateFirst,
      );

      emit(AuthUnauthenticated());
      await Future.delayed(Duration(seconds: 2));

      final newGuest = await _createGuestUser();
      emit(AuthAuthenticated(user: newGuest));
    } catch (e) {
      emit(currentState.copyWith(deleteAccountLoading: false));
      rethrow;
    }
  }

  void updateUser(UserEntity user) {
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(user: user));
    }
  }
}
