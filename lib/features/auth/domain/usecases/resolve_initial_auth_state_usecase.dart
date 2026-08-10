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
