import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/auth/domain/usecases/create_guest_user_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
@Environment(Env.minimal)
class ResolveInitialAuthStateUsecase {
  final UserRepository _userRepo;
  final ConnectivityService _connectivityService;
  final CloudSyncService _cloudSyncService;
  final CreateGuestUserUsecase _createGuestUser;

  ResolveInitialAuthStateUsecase(
    this._userRepo,
    this._connectivityService,
    this._cloudSyncService,
    this._createGuestUser,
  );

  Future<UserEntity> call() async {
    final isOnline = await _connectivityService.hasInternet();
    if (!isOnline) return _loadLocalUser();

    final firebaseUser = AuthService.instance.currentFirebaseUser;
    if (firebaseUser == null) return _loadLocalUser();

    try {
      final localUser = await _tryGetLocalUser();
      return await _cloudSyncService.syncWithCloud(
        firebaseUser: firebaseUser,
        localUser: localUser,
      );
    } catch (e) {
      debugPrint('Cloud sync failed, falling back to local user: $e');
      return _loadLocalUser();
    }
  }

  Future<UserEntity> _loadLocalUser() async {
    final existing = await _tryGetLocalUser();
    if (existing != null) return existing;
    return _createGuestUser();
  }

  Future<UserEntity?> _tryGetLocalUser() async {
    try {
      return await _userRepo.getCurrentUser();
    } catch (_) {
      return null;
    }
  }
}
