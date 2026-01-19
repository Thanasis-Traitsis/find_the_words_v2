import 'package:cloud_firestore/cloud_firestore.dart';
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

class UserRepositoryImpl extends UserRepository {
  @override
  Future<UserEntity> createUser(String id) async {
    final storageService = getIt<StorageService>();
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

    await storageService.saveUser(user);
    return user;
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final storageService = getIt<StorageService>();
    final user = storageService.getUser();

    if (user == null) {
      debugPrint('Warning: No user found in storage');
      throw Exception("No user found in local storage");
    }

    return user;
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
}
