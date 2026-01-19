import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class UserEntity {
  final String id;
  final String? username;
  final String? email;
  final int points;
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;
  final CurrentStage? currentStage;
  final DateTime? lastSyncedAt;
  final DateTime joinedAt;
  final bool isGuest;

  UserEntity.guest({
    required this.id,
    required this.points,
    required this.progressByLanguage,
    required this.joinedAt,
    this.currentStage,
    this.lastSyncedAt,
  }) : username = null,
       email = null,
       isGuest = true;

  UserEntity.authenticated({
    required this.id,
    required this.username,
    this.email,
    required this.points,
    required this.progressByLanguage,
    required this.joinedAt,
    this.currentStage,
    this.lastSyncedAt,
  }) : isGuest = false;

  // Helper methods
  ProfileStatusModel get currentProgress {
    final currentLanguage = getIt<LanguageCubit>().state.appLanguage;
    return progressByLanguage[currentLanguage] ??
        _createDefaultProgress(currentLanguage);
  }

  ProfileStatusModel _createDefaultProgress(AppLanguage language) {
    return ProfileStatusModel.initial(language);
  }

  ProfileStatusModel progressFor(AppLanguage language) {
    return progressByLanguage[language] ?? _createDefaultProgress(language);
  }

  double get totalProgressScore {
    return progressByLanguage.values.fold(0.0, (sum, progress) {
      return sum + progress.level + (progress.progress / 100);
    });
  }

  int get totalLevel {
    return progressByLanguage.values.fold(
      0,
      (sum, progress) => sum + progress.level,
    );
  }

  UserEntity copyWith({
    String? id,
    String? username,
    String? email,
    int? points,
    Map<AppLanguage, ProfileStatusModel>? progressByLanguage,
    CurrentStage? currentStage,
    DateTime? lastSyncedAt,
    DateTime? joinedAt,
  }) {
    if (isGuest) {
      return UserEntity.guest(
        id: id ?? this.id,
        points: points ?? this.points,
        progressByLanguage: progressByLanguage ?? this.progressByLanguage,
        currentStage: currentStage ?? this.currentStage,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        joinedAt: joinedAt ?? this.joinedAt,
      );
    } else {
      return UserEntity.authenticated(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        points: points ?? this.points,
        progressByLanguage: progressByLanguage ?? this.progressByLanguage,
        currentStage: currentStage ?? this.currentStage,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        joinedAt: joinedAt ?? this.joinedAt,
      );
    }
  }
}
