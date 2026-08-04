import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_redirect_policy.dart';
import 'package:find_the_words/config/routes/app_routes.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final policy = AppRedirectPolicy();

  const notFirstTimeLang = LanguageState(AppLanguage.greek);
  const firstTimeLang = LanguageState(AppLanguage.greek, isFirstTime: true);

  const noForceUpdate = VersionState();
  const forceUpdate = VersionState(needsForceUpdate: true);

  final authenticated = AuthAuthenticated(
    user: UserEntity.guest(
      id: 'test-user',
      points: 0,
      totalFreezes: 0,
      progressByLanguage: const {},
      joinedAt: DateTime(2026),
    ),
  );
  final loading = AuthLoading();
  final unauthenticated = AuthUnauthenticated();
  const failure = AuthFailure(message: 'boom');

  String? resolve({
    required AuthState authState,
    required LanguageState langState,
    VersionState versionState = noForceUpdate,
    required String currentLocation,
  }) {
    return policy.resolve(
      authState: authState,
      langState: langState,
      versionState: versionState,
      currentLocation: currentLocation,
    );
  }

  test('force update wins over every other branch', () {
    expect(
      resolve(
        authState: loading,
        langState: notFirstTimeLang,
        versionState: forceUpdate,
        currentLocation: AppRoutes.homePath,
      ),
      AppRoutes.forceUpdatePath,
    );
  });

  test(
    'authenticated + first time + not on lang screen -> lang screen',
    () {
      expect(
        resolve(
          authState: authenticated,
          langState: firstTimeLang,
          currentLocation: AppRoutes.homePath,
        ),
        AppRoutes.langPath,
      );
    },
  );

  test(
    'authenticated + first time + already on lang screen -> no redirect',
    () {
      expect(
        resolve(
          authState: authenticated,
          langState: firstTimeLang,
          currentLocation: AppRoutes.langPath,
        ),
        isNull,
      );
    },
  );

  test('unauthenticated -> splash, regardless of location', () {
    expect(
      resolve(
        authState: unauthenticated,
        langState: notFirstTimeLang,
        currentLocation: AppRoutes.homePath,
      ),
      AppRoutes.splashPath,
    );
  });

  test('loading + not on splash -> splash', () {
    expect(
      resolve(
        authState: loading,
        langState: notFirstTimeLang,
        currentLocation: AppRoutes.homePath,
      ),
      AppRoutes.splashPath,
    );
  });

  test('loading + already on splash -> no redirect', () {
    expect(
      resolve(
        authState: loading,
        langState: notFirstTimeLang,
        currentLocation: AppRoutes.splashPath,
      ),
      isNull,
    );
  });

  test(
    'authenticated + on splash + not first time -> home',
    () {
      expect(
        resolve(
          authState: authenticated,
          langState: notFirstTimeLang,
          currentLocation: AppRoutes.splashPath,
        ),
        AppRoutes.homePath,
      );
    },
  );

  test(
    'authenticated + already past splash + not first time -> no redirect',
    () {
      expect(
        resolve(
          authState: authenticated,
          langState: notFirstTimeLang,
          currentLocation: AppRoutes.homePath,
        ),
        isNull,
      );
    },
  );

  test('unhandled auth failure state falls through -> no redirect', () {
    expect(
      resolve(
        authState: failure,
        langState: notFirstTimeLang,
        currentLocation: AppRoutes.homePath,
      ),
      isNull,
    );
  });
}
