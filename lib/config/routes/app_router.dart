import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/routes/app_routes.dart';
import 'package:find_the_words/config/theme/screens/theme_screen.dart';
import 'package:find_the_words/config/version/force_update_screen.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/error_screen.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_status_listener.dart';
import 'package:find_the_words/features/complete/presentation/screens/complete_stage_screen.dart';
import 'package:find_the_words/features/game_instructions/presentation/screens/game_instructions_screen.dart';
import 'package:find_the_words/features/home/presentation/screens/home_screen.dart';
import 'package:find_the_words/config/language/presentation/screen/language_selection_screen.dart';
import 'package:find_the_words/features/settings/presentation/screens/settings_screen.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:find_the_words/features/stage/presentation/screens/stage_screen_provider.dart';
import 'package:find_the_words/features/words/presentation/screens/total_words_screen.dart';
import 'package:find_the_words/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static Page<void> _noAnimationPage(Widget child, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: child);
  }

  static final authStatusNotifier = AuthStatusNotifier(getIt<AuthCubit>());

  static final GoRouter router = GoRouter(
    refreshListenable: authStatusNotifier,
    redirect: (context, state) {
      final authState = getIt<AuthCubit>().state;
      final langState = getIt<LanguageCubit>().state;
      final isOnSplash = state.matchedLocation == AppRoutes.splashPath;
      final versionState = getIt<VersionBloc>().state;

      if (versionState.needsForceUpdate) {
        return AppRoutes.forceUpdatePath;
      }

      if (authState is AuthUnauthenticated) {
        return AppRoutes.splashPath;
      }

      if (authState is AuthLoading && !isOnSplash) {
        return AppRoutes.splashPath;
      }

      if (authState is AuthAuthenticated && isOnSplash) {
        if (langState.isFirstTime) {
          return AppRoutes.langPath;
        } else {
          return AppRoutes.homePath;
        }
      }

      return null;
    },
    initialLocation: AppRoutes.homePath,
    navigatorKey: NavigationService.rootNavigatorKey,
    routes: [
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.splash.info.path,
        name: AppPages.splash.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(SplashScreen(), state);
        },
      ),
      GoRoute(
        path: AppPages.forceUpdate.info.path,
        name: AppPages.forceUpdate.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(ForceUpdateScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.lang.info.path,
        name: AppPages.lang.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(LanguageSelectionScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.home.info.path,
        name: AppPages.home.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(HomeScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.stage.info.path,
        name: AppPages.stage.info.name,
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          final stage = params?['stage'] as int? ?? 0;
          final level = params?['level'] as int? ?? 1;
          return _noAnimationPage(
            StageScreenProvider(stage: stage, level: level),
            state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.words.info.path,
        name: AppPages.words.info.name,
        pageBuilder: (context, state) {
          final wordsModel =
              state.extra as WordsModel? ?? WordsModel(words: {});
          return _noAnimationPage(
            TotalWordsScreen(wordsModel: wordsModel),
            state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.settings.info.path,
        name: AppPages.settings.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(SettingsScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.theme.info.path,
        name: AppPages.theme.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(ThemeScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.gameInstructions.info.path,
        name: AppPages.gameInstructions.info.name,
        pageBuilder: (context, state) {
          return _noAnimationPage(GameInstructionsScreen(), state);
        },
      ),
      GoRoute(
        parentNavigatorKey: NavigationService.rootNavigatorKey,
        path: AppPages.complete.info.path,
        name: AppPages.complete.info.name,
        pageBuilder: (context, state) {
          final stageResults = state.extra as StageResults;
          return _noAnimationPage(
            CompleteStageScreen(stageResults: stageResults),
            state,
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const ErrorScreen();
    },
  );
}
