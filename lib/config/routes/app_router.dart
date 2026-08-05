import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/routes/app_redirect_policy.dart';
import 'package:find_the_words/config/routes/app_routes.dart';
import 'package:find_the_words/config/routes/args/complete_route_args.dart';
import 'package:find_the_words/config/routes/args/stage_route_args.dart';
import 'package:find_the_words/config/theme/screens/theme_screen.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/error_screen.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_status_listener.dart';
import 'package:find_the_words/features/complete/presentation/screens/complete_stage_screen.dart';
import 'package:find_the_words/features/game_instructions/presentation/screens/game_instructions_screen.dart';
import 'package:find_the_words/features/home/presentation/screens/home_screen.dart';
import 'package:find_the_words/config/language/presentation/screen/language_selection_screen.dart';
import 'package:find_the_words/features/settings/presentation/screens/settings_screen.dart';
import 'package:find_the_words/features/stage/presentation/screens/stage_screen_provider.dart';
import 'package:find_the_words/features/words/presentation/screens/total_words_screen.dart';
import 'package:find_the_words/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static Page<void> _noAnimationPage(Widget child, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: child);
  }

  static final appStatusNotifier = AppStatusNotifier(
    getIt<AuthCubit>(),
    getIt<LanguageCubit>(),
  );

  static final _redirectPolicy = AppRedirectPolicy();

  static final GoRouter router = GoRouter(
    refreshListenable: appStatusNotifier,
    redirect: (context, state) {
      return _redirectPolicy.resolve(
        authState: getIt<AuthCubit>().state,
        langState: getIt<LanguageCubit>().state,
        currentLocation: state.matchedLocation,
      );
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
          final args = state.extra as StageRouteArgs;
          return _noAnimationPage(
            StageScreenProvider(stage: args.stage, level: args.level),
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
          final args = state.extra as CompleteRouteArgs;
          return _noAnimationPage(
            CompleteStageScreen(stageResults: args.stageResults),
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
