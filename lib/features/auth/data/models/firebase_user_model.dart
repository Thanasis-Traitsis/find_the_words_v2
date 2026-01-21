import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';

class FirebaseUserModel {
  final String id;
  final String? username;
  final String? email;
  final int points;
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;
  final DateTime? lastSyncedAt;
  final DateTime joinedAt;
  final bool isGuest;

  FirebaseUserModel({
    required this.id,
    this.username,
    this.email,
    required this.points,
    required this.progressByLanguage,
    this.lastSyncedAt,
    required this.joinedAt,
    this.isGuest = false,
  });

  factory FirebaseUserModel.fromEntity(UserEntity entity) {
    return FirebaseUserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      points: entity.points,
      progressByLanguage: entity.progressByLanguage,
      lastSyncedAt: entity.lastSyncedAt,
      joinedAt: entity.joinedAt,
      isGuest: entity.isGuest,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'points': points,
      'isGuest': isGuest,
      'lastSyncedAt': FieldValue.serverTimestamp(),
      'joinedAt': Timestamp.fromDate(joinedAt),
      'progressByLanguage': progressByLanguage.map(
        (language, progress) => MapEntry(language.code, progress.toMap()),
      ),
    };
  }

  factory FirebaseUserModel.fromFirestore(Map<String, dynamic> data) {
    final progressMap = <AppLanguage, ProfileStatusModel>{};
    final progressData =
        data['progressByLanguage'] as Map<String, dynamic>? ?? {};

    for (final entry in progressData.entries) {
      final language = AppLanguage.fromCode(entry.key);
      progressMap[language] = ProfileStatusModel.fromMap(entry.value);
    }

    return FirebaseUserModel(
      id: data['id'] as String,
      username: data['username'] as String?,
      email: data['email'] as String?,
      points: data['points'] as int? ?? 0,
      progressByLanguage: progressMap,
      lastSyncedAt: (data['lastSyncedAt'] as Timestamp?)?.toDate(),
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isGuest: data['isGuest'] as bool? ?? false,
    );
  }

  UserEntity toEntity() {
    if (isGuest) {
      return UserEntity.guest(
        id: id,
        points: points,
        progressByLanguage: progressByLanguage,
        lastSyncedAt: lastSyncedAt,
        joinedAt: joinedAt,
      );
    } else {
      return UserEntity.authenticated(
        id: id,
        username: username,
        email: email,
        points: points,
        progressByLanguage: progressByLanguage,
        lastSyncedAt: lastSyncedAt,
        joinedAt: joinedAt,
      );
    }
  }
}
