import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:find_the_words/features/auth/data/models/firebase_user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class CloudSyncService {
  final UserRepository _userRepo;
  Timer? _syncDebounceTimer;

  CloudSyncService(this._userRepo);

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
    final newUser = UserEntity.authenticated(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      points: localUser.points,
      progressByLanguage: localUser.progressByLanguage,
      lastSyncedAt: DateTime.now(),
      joinedAt: localUser.joinedAt,
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
    final localScore = localUser.totalProgressScore;
    final cloudScore = cloudUser.totalProgressScore;

    debugPrint('🔀 Merging: Local=$localScore vs Cloud=$cloudScore');

    final earliestJoinedAt = localUser.joinedAt.isBefore(cloudUser.joinedAt)
        ? localUser.joinedAt
        : cloudUser.joinedAt;

    UserEntity mergedUser;

    if (localScore > cloudScore) {
      debugPrint('📱 Local data is ahead - using local progress');
      mergedUser = UserEntity.authenticated(
        id: firebaseUser.uid,
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        points: localUser.points,
        progressByLanguage: localUser.progressByLanguage,
        lastSyncedAt: DateTime.now(),
        joinedAt: earliestJoinedAt,
      );

      await _userRepo.updateFirebaseUser(mergedUser);
    } else if (cloudScore > localScore) {
      debugPrint('☁️ Cloud data is ahead - using cloud (returning player)');
      mergedUser = cloudUser.copyWith(
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        lastSyncedAt: DateTime.now(),
        joinedAt: earliestJoinedAt,
      );
    } else {
      // ✅ Same level - merge carefully
      debugPrint('⚖️ Same level - merging both');
      mergedUser = _mergeProgressMaps(
        localUser,
        cloudUser,
        firebaseUser,
        earliestJoinedAt,
      );
      await _userRepo.updateFirebaseUser(mergedUser);
    }

    return mergedUser;
  }

  UserEntity _mergeProgressMaps(
    UserEntity localUser,
    UserEntity cloudUser,
    firebase_auth.User firebaseUser,
    DateTime joinedAt,
  ) {
    final mergedProgress = <AppLanguage, ProfileStatusModel>{};

    for (final language in AppLanguage.values) {
      final localProgress = localUser.progressByLanguage[language];
      final cloudProgress = cloudUser.progressByLanguage[language];

      if (localProgress == null && cloudProgress == null) {
        continue;
      } else if (localProgress == null) {
        mergedProgress[language] = cloudProgress!;
      } else if (cloudProgress == null) {
        mergedProgress[language] = localProgress;
      } else {
        final localScore = localProgress.level + (localProgress.progress / 100);
        final cloudScore = cloudProgress.level + (cloudProgress.progress / 100);
        mergedProgress[language] = localScore >= cloudScore
            ? localProgress
            : cloudProgress;
      }
    }

    return UserEntity.authenticated(
      id: firebaseUser.uid,
      username: cloudUser.username ?? firebaseUser.displayName,
      email: cloudUser.email ?? firebaseUser.email,
      points: localUser.points > cloudUser.points
          ? localUser.points
          : cloudUser.points,
      progressByLanguage: mergedProgress,
      lastSyncedAt: DateTime.now(),
      joinedAt: joinedAt,
    );
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
