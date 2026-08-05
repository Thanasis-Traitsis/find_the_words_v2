import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/auth/domain/usecases/build_authenticated_user_usecase.dart';
import 'package:find_the_words/features/auth/domain/usecases/create_guest_user_usecase.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Resolves what the current user's state should be at app start: an
/// existing Firebase session (merged/created against the cloud), an
/// existing local guest, or a freshly-created guest. Always resolves to a
/// [UserEntity] — throws [AuthResolutionFailure] only on the one
/// unrecoverable path (an authenticated session whose data we can neither
/// read locally nor safely reconcile with the cloud).
@injectable
@Environment(Env.minimal)
class ResolveInitialAuthStateUsecase {
  final UserRepository _userRepo;
  final ConnectivityService _connectivityService;
  final CloudSyncService _cloudSyncService;
  final BuildAuthenticatedUserUsecase _buildAuthenticatedUser;
  final CreateGuestUserUsecase _createGuestUser;

  ResolveInitialAuthStateUsecase(
    this._userRepo,
    this._connectivityService,
    this._cloudSyncService,
    this._buildAuthenticatedUser,
    this._createGuestUser,
  );

  // FreezeCubit is deliberately NOT a constructor dependency: FreezeCubit's
  // own @PostConstruct(preResolve: true) eagerly constructs
  // UserProfileService -> AuthCubit during registerRemainingDependencies().
  // If this usecase (a dependency of AuthCubit) constructor-injected
  // FreezeCubit too, that eager chain would need FreezeCubit again before
  // its own registration finishes constructing - a synchronous circular
  // dependency. Looking it up lazily here instead is safe because this
  // method only runs later, after AuthCubit's constructor has already
  // returned and an earlier await has yielded past the synchronous
  // registration cascade.
  FreezeCubit get _freezeCubit => getIt<FreezeCubit>();

  Future<UserEntity> call() async {
    await _userRepo.updateBannedWords();

    final firebase_auth.User? firebaseUser =
        AuthService.instance.currentFirebaseUser;

    if (firebaseUser != null) {
      return _resolveAuthenticatedUser(firebaseUser);
    }

    final bool hasToken = await AuthService.instance.userHasToken();
    if (hasToken) {
      try {
        return await _userRepo.getCurrentUser();
      } catch (e) {
        return _createGuestUser();
      }
    }

    return _createGuestUser();
  }

  Future<UserEntity> _resolveAuthenticatedUser(
    firebase_auth.User firebaseUser,
  ) async {
    final bool hasInternet = await _connectivityService.hasInternet();
    if (!hasInternet) {
      return _localOnlyUser(firebaseUser);
    }

    DocumentSnapshot? cloudUserDoc;
    try {
      cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);
    } catch (e) {
      // Can't verify cloud state right now (network/permissions/etc) - fall
      // back to local data rather than risk creating or overwriting the
      // real cloud document based on a guess.
      debugPrint('Could not reach cloud, using local user for now: $e');
      return _localOnlyUser(firebaseUser);
    }

    final localUser = await _tryGetLocalUser();

    try {
      if (cloudUserDoc == null) {
        final newUser = _buildAuthenticatedUser(
          id: firebaseUser.uid,
          username: firebaseUser.displayName,
          email: firebaseUser.email,
          localUser: localUser,
          fallbackTotalFreezes: _freezeCubit.state.totalFreezes,
        );

        await _userRepo.createFirebaseUser(newUser);
        await _saveUserAndToken(newUser, firebaseUser.uid);
        return newUser;
      }

      final syncedUser = await _cloudSyncService.syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: localUser,
        cloudUserDoc: cloudUserDoc,
      );

      await _saveUserAndToken(syncedUser, firebaseUser.uid);
      return syncedUser;
    } catch (e) {
      throw AuthResolutionFailure(
        'Failed to initialize user. Please try again or contact support.',
        cause: e,
      );
    }
  }

  Future<UserEntity> _localOnlyUser(firebase_auth.User firebaseUser) async {
    final localUser = await _tryGetLocalUser();

    final user =
        localUser ??
        _buildAuthenticatedUser(
          id: firebaseUser.uid,
          username: firebaseUser.displayName,
          email: firebaseUser.email,
          fallbackTotalFreezes: _freezeCubit.state.totalFreezes,
        );

    await _userRepo.updateUser(user);
    return user;
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
}

class AuthResolutionFailure implements Exception {
  final String message;
  final Object? cause;

  const AuthResolutionFailure(this.message, {this.cause});

  @override
  String toString() => 'AuthResolutionFailure: $message (cause: $cause)';
}
