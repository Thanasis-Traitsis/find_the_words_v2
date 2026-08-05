import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

/// Builds a fresh authenticated [UserEntity]. Carries over an existing
/// local user's points/progress/freezes/joinedAt when present (a guest who
/// just signed in, or a returning session) — otherwise starts fresh.
@injectable
@Environment(Env.minimal)
class BuildAuthenticatedUserUsecase {
  UserEntity call({
    required String id,
    String? username,
    String? email,
    UserEntity? localUser,
    int fallbackTotalFreezes = 0,
  }) {
    return UserEntity.authenticated(
      id: id,
      username: username,
      email: email,
      points: localUser?.points ?? AppValues.startingPoints,
      progressByLanguage:
          localUser?.progressByLanguage ?? _defaultProgressByLanguage(),
      lastSyncedAt: DateTime.now(),
      joinedAt: localUser?.joinedAt ?? DateTime.now(),
      totalFreezes: localUser?.totalFreezes ?? fallbackTotalFreezes,
    );
  }

  Map<AppLanguage, ProfileStatusModel> _defaultProgressByLanguage() {
    return {
      for (final language in AppLanguage.values)
        language: ProfileStatusModel.initial(language),
    };
  }
}
