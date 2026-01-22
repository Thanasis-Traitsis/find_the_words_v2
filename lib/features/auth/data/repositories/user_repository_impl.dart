import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/auth/data/models/firebase_user_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl extends UserRepository {
  final StorageService _storageService;

  UserRepositoryImpl(this._storageService);

  @override
  Future<UserEntity> createUser(String id) async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    final user = UserModel.guest(
      id: id,
      points: AppValues.startingPoints,
      progressByLanguage: {
        currentLang: ProfileStatusModel.initial(currentLang),
      },
      lastSyncedAt: DateTime.now(),
      joinedAt: DateTime.now(),
    );

    await _storageService.saveUser(user);
    return user.toEntity();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = _storageService.getUser();

    if (user == null) {
      debugPrint('Warning: No user found in storage');
      throw Exception("No user found in local storage");
    }

    return user.toEntity();
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _storageService.saveUser(userModel);
  }

  @override
  Future<UserEntity> refreshUserFromStorage() async {
    final userModel = _storageService.getUser();

    if (userModel == null) {
      throw Exception("No user found in storage");
    }

    final updatedProgressMap = <AppLanguage, ProfileStatusModel>{};

    for (final entry in userModel.progressByLanguage.entries) {
      final language = entry.key;
      final progress = entry.value;

      final currentStage = _storageService.getCurrentStage(language);

      updatedProgressMap[language] = progress.copyWith(
        currentStage: currentStage,
      );
    }

    final updatedUserModel = userModel.copyWith(
      progressByLanguage: updatedProgressMap,
    );

    await _storageService.saveUser(updatedUserModel);
    return updatedUserModel.toEntity();
  }

  @override
  Future<DocumentSnapshot<Object?>?> getFirebaseUser(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(AppKeys.usersFirebaseCollectionKey)
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error checking Firebase auth: $e');
      return null;
    }
  }

  @override
  Future<void> createFirebaseUser(UserEntity user) async {
    final firebaseModel = FirebaseUserModel.fromEntity(user);
    await FirebaseFirestore.instance
        .collection(AppKeys.usersFirebaseCollectionKey)
        .doc(user.id)
        .set(firebaseModel.toFirestore());
  }

  @override
  Future<void> updateFirebaseUser(UserEntity user) async {
    final firebaseModel = FirebaseUserModel.fromEntity(user);
    await FirebaseFirestore.instance
        .collection(AppKeys.usersFirebaseCollectionKey)
        .doc(user.id)
        .update(firebaseModel.toFirestore());
  }

  @override
  Future<void> updateBannedWords() async {
    final firestore = FirebaseFirestore.instance;
    final prefs = getIt<SharedPreferences>();

    final bannedCollection = firestore.collection(AppKeys.bannedWords);

    // Fetch both documents
    final greekDoc = await bannedCollection.doc(AppKeys.greekBannedWordsId).get();
    final englishDoc = await bannedCollection.doc(AppKeys.englishBannedWordsId).get();

    final List<String> greekWords = List<String>.from(
      greekDoc.data()?['words'] ?? [],
    );

    final List<String> englishWords = List<String>.from(
      englishDoc.data()?['words'] ?? [],
    );

    // Merge + deduplicate
    final allBannedWords = <String>{...greekWords, ...englishWords}.toList();

    // Persist to SharedPreferences
    print(allBannedWords);
    await prefs.setStringList(AppKeys.bannedWords, allBannedWords);
  }
}
