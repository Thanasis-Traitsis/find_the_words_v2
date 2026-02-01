import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:find_the_words/features/auth/data/models/firebase_user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final freezeCubit = getIt<FreezeCubit>();

    final newUser = UserEntity.authenticated(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      points: localUser.points,
      progressByLanguage: localUser.progressByLanguage,
      lastSyncedAt: DateTime.now(),
      joinedAt: localUser.joinedAt,
      totalFreezes: freezeCubit.state.totalFreezes,
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
    final freezeCubit = getIt<FreezeCubit>();
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
        totalFreezes: freezeCubit.state.totalFreezes,
      );

      await _userRepo.updateFirebaseUser(mergedUser);
    } else if (cloudScore > localScore) {
      debugPrint('☁️ Cloud data is ahead - using cloud (returning player)');
      final cleanedProgressMap = <AppLanguage, ProfileStatusModel>{};

      for (final entry in cloudUser.progressByLanguage.entries) {
        final language = entry.key;
        final cloudProgress = entry.value;
        final localProgress = localUser.progressByLanguage[language];

        if (localProgress != null) {
          final mergedWords = _mergeWords(
            localWords: localProgress.wordsModel.words,
            cloudWords: cloudProgress.wordsModel.words,
          );

          debugPrint(
            '${language.displayName}: Merged ${mergedWords.length} words',
          );

          // If cloud level is higher, clear the currentStage (outdated)
          if (cloudProgress.level > localProgress.level) {
            debugPrint(
              'Clearing currentStage (cloud L${cloudProgress.level} > local L${localProgress.level})',
            );
            cleanedProgressMap[language] = cloudProgress.copyWith(
              words: WordsModel(words: mergedWords),
              clearCurrentStage: true,
            );
          } else {
            cleanedProgressMap[language] = cloudProgress.copyWith(
              words: WordsModel(words: mergedWords),
            );
          }
        } else {
          // No local progress for this language - use cloud as-is
          cleanedProgressMap[language] = cloudProgress;
        }
      }

      mergedUser = UserEntity.authenticated(
        id: firebaseUser.uid,
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        points: cloudUser.points,
        progressByLanguage: cleanedProgressMap,
        lastSyncedAt: DateTime.now(),
        joinedAt: earliestJoinedAt,
        totalFreezes: cloudUser.totalFreezes,
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

    await _userRepo.updateCurrentStageFromMerge(mergedUser);
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
        // Only cloud has this language
        mergedProgress[language] = cloudProgress!;
      } else if (cloudProgress == null) {
        // Only local has this language
        mergedProgress[language] = localProgress;
      } else {
        // Both have this language - compare level + progress
        final localScore = localProgress.level + (localProgress.progress / 100);
        final cloudScore = cloudProgress.level + (cloudProgress.progress / 100);

        final mergedWords = _mergeWords(
          localWords: localProgress.wordsModel.words,
          cloudWords: cloudProgress.wordsModel.words,
        );

        if (localScore > cloudScore) {
          debugPrint(
            '${language.displayName}: Using local (L${localProgress.level} ${localProgress.progress}%)',
          );
          mergedProgress[language] = localProgress.copyWith(
            words: WordsModel(words: mergedWords),
          );
        } else if (cloudScore > localScore) {
          debugPrint(
            '${language.displayName}: Using cloud (L${cloudProgress.level} ${cloudProgress.progress}%)',
          );

          if (cloudProgress.level > localProgress.level) {
            debugPrint('Clearing currentStage (cloud level is higher)');
            mergedProgress[language] = cloudProgress.copyWith(
              words: WordsModel(words: mergedWords),
              clearCurrentStage: true,
            );
          } else {
            mergedProgress[language] = cloudProgress.copyWith(
              words: WordsModel(words: mergedWords),
            );
          }
        } else {
          // Exactly equal - prefer local
          debugPrint('   ${language.displayName}: Equal - using local');
          mergedProgress[language] = localProgress.copyWith(
            words: WordsModel(words: mergedWords),
          );
        }
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
      totalFreezes: localUser.totalFreezes > cloudUser.totalFreezes
          ? localUser.totalFreezes
          : cloudUser.totalFreezes,
    );
  }

  Map<String, dynamic> _mergeWords({
    required Map<String, dynamic> localWords,
    required Map<String, dynamic> cloudWords,
  }) {
    final prefs = getIt<SharedPreferences>();

    final bannedWords = (prefs.getStringList(AppKeys.bannedWords) ?? [])
        .toSet();

    final mergedWords = <String, dynamic>{};

    for (final entry in cloudWords.entries) {
      final key = entry.key;
      if (!bannedWords.contains(key)) {
        mergedWords[key] = entry.value;
      }
    }

    for (final entry in localWords.entries) {
      final key = entry.key;
      if (!bannedWords.contains(key) && !mergedWords.containsKey(key)) {
        mergedWords[key] = entry.value;
      }
    }

    return mergedWords;
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
