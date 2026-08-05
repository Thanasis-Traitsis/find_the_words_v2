import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

/// Merges a local and cloud [UserEntity] belonging to the same account.
///
/// Progress is compared independently per language — how far a player has
/// gotten in Greek says nothing about their English progress — rather than
/// by a single combined total. For each language, whichever side has the
/// higher `level + progress/100` wins that language's level/stage/progress/
/// currentStage wholesale; words found are unioned from both sides either
/// way. `points`/`totalFreezes` are `max(local, cloud)` — a placeholder
/// until the points economy gets its own merge design.
@injectable
@Environment(Env.minimal)
class MergeUserProgressUsecase {
  UserEntity call({
    required UserEntity local,
    required UserEntity cloud,
    required String id,
    String? username,
    String? email,
    Set<String> bannedWords = const {},
  }) {
    final mergedProgress = <AppLanguage, ProfileStatusModel>{};

    for (final language in AppLanguage.values) {
      final localProgress = local.progressByLanguage[language];
      final cloudProgress = cloud.progressByLanguage[language];

      if (localProgress == null && cloudProgress == null) {
        continue;
      } else if (localProgress == null) {
        mergedProgress[language] = cloudProgress!;
      } else if (cloudProgress == null) {
        mergedProgress[language] = localProgress;
      } else {
        mergedProgress[language] = _mergeLanguageProgress(
          local: localProgress,
          cloud: cloudProgress,
          bannedWords: bannedWords,
        );
      }
    }

    final earlierJoinedAt = local.joinedAt.isBefore(cloud.joinedAt)
        ? local.joinedAt
        : cloud.joinedAt;

    return UserEntity.authenticated(
      id: id,
      username: username ?? cloud.username ?? local.username,
      email: email ?? cloud.email ?? local.email,
      points: local.points > cloud.points ? local.points : cloud.points,
      totalFreezes: local.totalFreezes > cloud.totalFreezes
          ? local.totalFreezes
          : cloud.totalFreezes,
      progressByLanguage: mergedProgress,
      lastSyncedAt: DateTime.now(),
      joinedAt: earlierJoinedAt,
    );
  }

  ProfileStatusModel _mergeLanguageProgress({
    required ProfileStatusModel local,
    required ProfileStatusModel cloud,
    required Set<String> bannedWords,
  }) {
    final mergedWords = _mergeWords(
      local: local.wordsModel.words,
      cloud: cloud.wordsModel.words,
      bannedWords: bannedWords,
    );

    final localScore = local.level + (local.progress / 100);
    final cloudScore = cloud.level + (cloud.progress / 100);

    if (localScore >= cloudScore) {
      return local.copyWith(words: WordsModel(words: mergedWords));
    }

    // Cloud is ahead for this language. Only clear the losing side's
    // in-progress puzzle if cloud is a full level ahead — a narrower lead
    // (same level, higher progress%) doesn't necessarily invalidate
    // whatever stage local was mid-way through.
    return cloud.copyWith(
      words: WordsModel(words: mergedWords),
      clearCurrentStage: cloud.level > local.level,
    );
  }

  Map<String, dynamic> _mergeWords({
    required Map<String, dynamic> local,
    required Map<String, dynamic> cloud,
    required Set<String> bannedWords,
  }) {
    final merged = <String, dynamic>{};

    for (final entry in cloud.entries) {
      if (!bannedWords.contains(entry.key)) {
        merged[entry.key] = entry.value;
      }
    }
    for (final entry in local.entries) {
      if (!bannedWords.contains(entry.key)) {
        merged[entry.key] = entry.value;
      }
    }

    return merged;
  }
}
