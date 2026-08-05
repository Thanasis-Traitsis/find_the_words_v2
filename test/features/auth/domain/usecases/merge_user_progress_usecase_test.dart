import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/usecases/merge_user_progress_usecase.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

ProfileStatusModel _progress({
  required AppLanguage language,
  required int level,
  required double progress,
  int stage = 1,
  Map<String, dynamic> words = const {},
  CurrentStage? currentStage,
}) {
  return ProfileStatusModel(
    language: language,
    level: level,
    progress: progress,
    stage: stage,
    wordsModel: WordsModel(words: Map<String, dynamic>.from(words)),
    currentStage: currentStage,
  );
}

CurrentStage _stage() {
  return CurrentStage(
    allWords: const ['CAT'],
    letters: const ['C', 'A', 'T'],
    board: const ['C', 'A', 'T'],
    placementTracker: WordPlacementTracker(),
  );
}

UserEntity _user({
  required String id,
  required Map<AppLanguage, ProfileStatusModel> progressByLanguage,
  int points = 0,
  int totalFreezes = 0,
  String? username,
  String? email,
  DateTime? joinedAt,
}) {
  return UserEntity.authenticated(
    id: id,
    username: username,
    email: email,
    points: points,
    totalFreezes: totalFreezes,
    progressByLanguage: progressByLanguage,
    joinedAt: joinedAt ?? DateTime(2026, 1, 1),
  );
}

void main() {
  final usecase = MergeUserProgressUsecase();

  test(
    'compares progress independently per language, not by a global total',
    () {
      // Local is way ahead in Greek, cloud is way ahead in English.
      // A global-sum comparison would let one side's win wipe out the
      // other's progress in the language it's actually behind in.
      final local = _user(
        id: 'local-guest',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 10,
            progress: 50,
          ),
          AppLanguage.english: _progress(
            language: AppLanguage.english,
            level: 1,
            progress: 0,
          ),
        },
      );
      final cloud = _user(
        id: 'cloud-uid',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 1,
            progress: 0,
          ),
          AppLanguage.english: _progress(
            language: AppLanguage.english,
            level: 8,
            progress: 20,
          ),
        },
      );

      final merged = usecase(local: local, cloud: cloud, id: 'cloud-uid');

      expect(merged.progressByLanguage[AppLanguage.greek]!.level, 10);
      expect(merged.progressByLanguage[AppLanguage.english]!.level, 8);
    },
  );

  test('language present only on cloud is carried over as-is', () {
    final local = _user(id: 'local', progressByLanguage: {});
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 3,
          progress: 40,
        ),
      },
    );

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(merged.progressByLanguage[AppLanguage.greek]!.level, 3);
  });

  test('language present only on local is carried over as-is', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {
        AppLanguage.english: _progress(
          language: AppLanguage.english,
          level: 5,
          progress: 10,
        ),
      },
    );
    final cloud = _user(id: 'cloud', progressByLanguage: {});

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(merged.progressByLanguage[AppLanguage.english]!.level, 5);
  });

  test('words found on either side are unioned', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 5,
          progress: 0,
          words: {'CAT': true},
        ),
      },
    );
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 1,
          progress: 0,
          words: {'DOG': true},
        ),
      },
    );

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(
      merged.progressByLanguage[AppLanguage.greek]!.wordsModel.words.keys,
      containsAll(['CAT', 'DOG']),
    );
  });

  test('banned words are excluded from the merged word set', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 5,
          progress: 0,
          words: {'CAT': true, 'BANNED1': true},
        ),
      },
    );
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 1,
          progress: 0,
          words: {'DOG': true, 'BANNED2': true},
        ),
      },
    );

    final merged = usecase(
      local: local,
      cloud: cloud,
      id: 'cloud',
      bannedWords: {'BANNED1', 'BANNED2'},
    );

    final words = merged.progressByLanguage[AppLanguage.greek]!.wordsModel.words;
    expect(words.keys, containsAll(['CAT', 'DOG']));
    expect(words.keys, isNot(contains('BANNED1')));
    expect(words.keys, isNot(contains('BANNED2')));
  });

  test(
    'clears the winning side\'s currentStage when it wins by a full level',
    () {
      // Cloud wins this language and is a full level ahead of local - its
      // own recorded currentStage is treated as stale and cleared.
      final local = _user(
        id: 'local',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 1,
            progress: 0,
          ),
        },
      );
      final cloud = _user(
        id: 'cloud',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 3,
            progress: 0,
            currentStage: _stage(),
          ),
        },
      );

      final merged = usecase(local: local, cloud: cloud, id: 'cloud');

      expect(merged.progressByLanguage[AppLanguage.greek]!.currentStage, isNull);
    },
  );

  test(
    'keeps the winning side\'s currentStage when it only wins on progress% within the same level',
    () {
      final local = _user(
        id: 'local',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 3,
            progress: 10,
          ),
        },
      );
      final cloud = _user(
        id: 'cloud',
        progressByLanguage: {
          AppLanguage.greek: _progress(
            language: AppLanguage.greek,
            level: 3,
            progress: 90,
            currentStage: _stage(),
          ),
        },
      );

      final merged = usecase(local: local, cloud: cloud, id: 'cloud');

      expect(merged.progressByLanguage[AppLanguage.greek]!.level, 3);
      expect(
        merged.progressByLanguage[AppLanguage.greek]!.currentStage,
        isNotNull,
      );
    },
  );

  test('exact tie in a language prefers local and keeps its currentStage', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 4,
          progress: 50,
          currentStage: _stage(),
        ),
      },
    );
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {
        AppLanguage.greek: _progress(
          language: AppLanguage.greek,
          level: 4,
          progress: 50,
        ),
      },
    );

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(merged.progressByLanguage[AppLanguage.greek]!.currentStage, isNotNull);
  });

  test('points and totalFreezes are max(local, cloud)', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {},
      points: 500,
      totalFreezes: 1,
    );
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {},
      points: 200,
      totalFreezes: 4,
    );

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(merged.points, 500);
    expect(merged.totalFreezes, 4);
  });

  test('joinedAt is the earlier of the two', () {
    final local = _user(
      id: 'local',
      progressByLanguage: {},
      joinedAt: DateTime(2025, 6, 1),
    );
    final cloud = _user(
      id: 'cloud',
      progressByLanguage: {},
      joinedAt: DateTime(2024, 1, 1),
    );

    final merged = usecase(local: local, cloud: cloud, id: 'cloud');

    expect(merged.joinedAt, DateTime(2024, 1, 1));
  });

  test(
    'username/email prefer the explicit param, then cloud, then local',
    () {
      final local = _user(
        id: 'local',
        progressByLanguage: {},
        username: 'LocalName',
        email: 'local@example.com',
      );
      final cloud = _user(
        id: 'cloud',
        progressByLanguage: {},
        username: 'CloudName',
        email: 'cloud@example.com',
      );

      final withExplicit = usecase(
        local: local,
        cloud: cloud,
        id: 'cloud',
        username: 'LiveName',
        email: 'live@example.com',
      );
      expect(withExplicit.username, 'LiveName');
      expect(withExplicit.email, 'live@example.com');

      final withoutExplicit = usecase(local: local, cloud: cloud, id: 'cloud');
      expect(withoutExplicit.username, 'CloudName');
      expect(withoutExplicit.email, 'cloud@example.com');
    },
  );

  test('merged result id is the explicit id, not either side\'s own id', () {
    final local = _user(id: 'guest-token-123', progressByLanguage: {});
    final cloud = _user(id: 'firebase-uid-abc', progressByLanguage: {});

    final merged = usecase(local: local, cloud: cloud, id: 'firebase-uid-abc');

    expect(merged.id, 'firebase-uid-abc');
  });
}
