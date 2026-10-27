import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/usecases/build_authenticated_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usecase = BuildAuthenticatedUserUsecase();

  test('with no local user, starts fresh with default progress for every language', () {
    final user = usecase(id: 'uid-1', username: 'Name', email: 'a@b.com');

    expect(user.id, 'uid-1');
    expect(user.isGuest, isFalse);
    expect(user.totalFreezes, 0);
    expect(user.progressByLanguage.keys, containsAll(AppLanguage.values));
    for (final progress in user.progressByLanguage.values) {
      expect(progress.level, 1);
      expect(progress.progress, 0);
    }
  });

  test('carries over an existing local user\'s points/progress/freezes/joinedAt', () {
    final joinedAt = DateTime(2024, 3, 1);
    final localUser = UserEntity.guest(
      id: 'guest-token',
      points: 250,
      totalFreezes: 2,
      progressByLanguage: {
        AppLanguage.greek: ProfileStatusModel(
          language: AppLanguage.greek,
          level: 4,
          progress: 30,
          stage: 12,
          wordsModel: WordsModel(words: {'CAT': true}),
        ),
      },
      joinedAt: joinedAt,
    );

    final user = usecase(id: 'uid-1', localUser: localUser);

    expect(user.points, 250);
    expect(user.totalFreezes, 2);
    expect(user.joinedAt, joinedAt);
    expect(user.progressByLanguage[AppLanguage.greek]!.level, 4);
  });

  test('fallbackTotalFreezes is only used when there is no local user', () {
    final withoutLocal = usecase(id: 'uid-1', fallbackTotalFreezes: 3);
    expect(withoutLocal.totalFreezes, 3);

    final localUser = UserEntity.guest(
      id: 'guest',
      points: 0,
      totalFreezes: 7,
      progressByLanguage: const {},
      joinedAt: DateTime(2026),
    );
    final withLocal = usecase(
      id: 'uid-1',
      localUser: localUser,
      fallbackTotalFreezes: 3,
    );
    expect(withLocal.totalFreezes, 7);
  });
}
