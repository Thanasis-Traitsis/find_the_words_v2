import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String? username;

  @HiveField(2)
  @override
  final String? email;

  @HiveField(3)
  @override
  final int points;

  @HiveField(4)
  @override
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;


  @HiveField(6)
  @override
  final DateTime? lastSyncedAt;

  @HiveField(7)
  @override
  final bool isGuest;

  @HiveField(8)
  @override
  final DateTime joinedAt;

  @HiveField(9)
  @override
  final int totalFreezes;

  UserModel({
    required this.id,
    this.username,
    this.email,
    required this.points,
    required this.totalFreezes,
    required this.progressByLanguage,
    this.lastSyncedAt,
    required this.joinedAt,
    bool? isGuest,
  })  : isGuest = isGuest ?? (username == null && email == null),
        super.authenticated(
          id: id,
          username: username,
          email: email,
          points: points,
          totalFreezes: totalFreezes,
          progressByLanguage: progressByLanguage,
          lastSyncedAt: lastSyncedAt,
          joinedAt: joinedAt
        );


  UserModel.guest({
    required this.id,
    required this.points,
    required this.totalFreezes,
    required this.progressByLanguage,
    this.lastSyncedAt,
    required this.joinedAt,
  })  : username = null,
        email = null,
        isGuest = true,
        super.guest(
          id: id,
          points: points,
          totalFreezes: totalFreezes,
          progressByLanguage: progressByLanguage,
          lastSyncedAt: lastSyncedAt,
          joinedAt: joinedAt
        );

  UserModel.authenticated({
    required this.id,
    required this.username,
    this.email,
    required this.points,
    required this.totalFreezes,
    required this.progressByLanguage,
    this.lastSyncedAt,
    required this.joinedAt,
  })  : isGuest = false,
        super.authenticated(
          id: id,
          username: username,
          email: email,
          points: points,
          totalFreezes: totalFreezes,
          progressByLanguage: progressByLanguage,
          lastSyncedAt: lastSyncedAt,
          joinedAt: joinedAt
        );

  factory UserModel.fromEntity(UserEntity entity) {
    if (entity.isGuest) {
      return UserModel.guest(
        id: entity.id,
        points: entity.points,
        totalFreezes: entity.totalFreezes,
        progressByLanguage: entity.progressByLanguage,
        lastSyncedAt: entity.lastSyncedAt,
        joinedAt: entity.joinedAt
      );
    } else {
      return UserModel.authenticated(
        id: entity.id,
        username: entity.username,
        email: entity.email,
        points: entity.points,
        totalFreezes: entity.totalFreezes,
        progressByLanguage: entity.progressByLanguage,
        lastSyncedAt: entity.lastSyncedAt,
        joinedAt: entity.joinedAt
      );
    }
  }

  UserEntity toEntity() => this;

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    int? points,
    int? totalFreezes,
    Map<AppLanguage, ProfileStatusModel>? progressByLanguage,
    DateTime? lastSyncedAt,
    bool? isGuest,
    DateTime? joinedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      points: points ?? this.points,
      totalFreezes: totalFreezes ?? this.totalFreezes,
      progressByLanguage: progressByLanguage ?? this.progressByLanguage,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isGuest: isGuest ?? this.isGuest,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
