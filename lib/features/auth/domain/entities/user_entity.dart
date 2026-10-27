import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class UserEntity {
  final String id;
  final String? username;
  final String? email;
  final int points;
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;
  final DateTime? lastSyncedAt;
  final DateTime joinedAt;
  final int totalFreezes;
  final bool isGuest;

  UserEntity.guest({
    required this.id,
    required this.points,
    required this.totalFreezes,
    required this.progressByLanguage,
    required this.joinedAt,
    this.lastSyncedAt,
  }) : username = null,
       email = null,
       isGuest = true;

  UserEntity.authenticated({
    required this.id,
    required this.username,
    this.email,
    required this.points,
    required this.totalFreezes,
    required this.progressByLanguage,
    required this.joinedAt,
    this.lastSyncedAt,
  }) : isGuest = false;

  // Helper methods
  ProfileStatusModel get currentProgress {
    final currentLanguage = getIt<LanguageCubit>().state.appLanguage;
    return progressByLanguage[currentLanguage] ??
        _createDefaultProgress(currentLanguage);
  }

  CurrentStage? get currentStage {
    return currentProgress.currentStage;
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
    int? totalFreezes,
    Map<AppLanguage, ProfileStatusModel>? progressByLanguage,
    DateTime? lastSyncedAt,
    DateTime? joinedAt,
  }) {
    if (isGuest) {
      return UserEntity.guest(
        id: id ?? this.id,
        points: points ?? this.points,
        totalFreezes: totalFreezes ?? this.totalFreezes,
        progressByLanguage: progressByLanguage ?? this.progressByLanguage,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        joinedAt: joinedAt ?? this.joinedAt,
      );
    } else {
      return UserEntity.authenticated(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        points: points ?? this.points,
        totalFreezes: totalFreezes ?? this.totalFreezes,
        progressByLanguage: progressByLanguage ?? this.progressByLanguage,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        joinedAt: joinedAt ?? this.joinedAt,
      );
    }
  }
}
