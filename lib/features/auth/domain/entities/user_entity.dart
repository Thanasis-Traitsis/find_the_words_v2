import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class UserEntity {
  final String id;
  final String? username;
  final int points;
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;
  final CurrentStage? currentStage;

  UserEntity.guest({
    required this.id,
    required this.points,
    required this.progressByLanguage,
    this.currentStage,
  }) : username = null;

  UserEntity.authenticated({
    required this.id,
    required this.username,
    required this.points,
    required this.progressByLanguage,
    this.currentStage,
  });

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
}
