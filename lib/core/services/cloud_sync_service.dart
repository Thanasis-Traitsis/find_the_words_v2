import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/firebase_user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/auth/domain/usecases/build_authenticated_user_usecase.dart';
import 'package:find_the_words/features/auth/domain/usecases/merge_user_progress_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
@Environment(Env.full)
class CloudSyncService {
  final UserRepository _userRepo;
  final MergeUserProgressUsecase _mergeUserProgress;
  final BuildAuthenticatedUserUsecase _buildAuthenticatedUser;
  Timer? _syncDebounceTimer;

  CloudSyncService(
    this._userRepo,
    this._mergeUserProgress,
    this._buildAuthenticatedUser,
  );

  Future<UserEntity> syncWithCloud({
    required firebase_auth.User firebaseUser,
    UserEntity? localUser,
    DocumentSnapshot? cloudUserDoc,
  }) async {
    // No cloud doc - upload local
    if (cloudUserDoc == null || !cloudUserDoc.exists) {
      return await _uploadLocalToCloud(localUser!, firebaseUser);
    }

    // Cloud exists - merge
    final cloudData = cloudUserDoc.data() as Map<String, dynamic>;
    final firebaseModel = FirebaseUserModel.fromFirestore(cloudData);
    final cloudUser = firebaseModel.toEntity();

    if (localUser == null) {
      return cloudUser;
    }

    return await _mergeUserData(localUser, cloudUser, firebaseUser);
  }

  Future<UserEntity> _uploadLocalToCloud(
    UserEntity localUser,
    firebase_auth.User firebaseUser,
  ) async {
    final newUser = _buildAuthenticatedUser(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      localUser: localUser,
    );

    await _userRepo.createFirebaseUser(newUser);
    debugPrint('Uploaded local data to cloud');
    return newUser;
  }

  Future<UserEntity> _mergeUserData(
    UserEntity localUser,
    UserEntity cloudUser,
    firebase_auth.User firebaseUser,
  ) async {
    final bannedWords = (getIt<SharedPreferences>().getStringList(
      AppKeys.bannedWords,
    ) ?? []).toSet();

    final mergedUser = _mergeUserProgress(
      local: localUser,
      cloud: cloudUser,
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      bannedWords: bannedWords,
    );

    await _userRepo.updateFirebaseUser(mergedUser);
    await _userRepo.updateCurrentStageFromMerge(mergedUser);

    return mergedUser;
  }

  void scheduleSync(UserEntity user) {
    _syncDebounceTimer?.cancel();
    _syncDebounceTimer = Timer(const Duration(seconds: 3), () {
      _syncToCloud(user);
    });
  }

  Future<void> _syncToCloud(UserEntity user) async {
    try {
      final hasInternet = await getIt<ConnectivityService>().hasInternet();

      if (!hasInternet) {
        debugPrint('No internet - skipping cloud sync');
        return;
      }

      debugPrint('Syncing to cloud...');

      final updatedUser = user.copyWith(lastSyncedAt: DateTime.now());
      await _userRepo.updateFirebaseUser(updatedUser);

      debugPrint('Cloud sync successful');
    } catch (e) {
      debugPrint('Cloud sync failed: $e');
    }
  }

  void dispose() {
    _syncDebounceTimer?.cancel();
  }
}
