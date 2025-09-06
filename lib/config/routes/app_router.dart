import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/routes/app_routes.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/error_screen.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/home/presentation/screens/home_screen.dart';
import 'package:find_the_words/features/language/presentation/screens/language_selection_screen.dart';
import 'package:find_the_words/features/stage/presentation/screens/stage_screen.dart';
import 'package:find_the_words/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static Page<void> _noAnimationPage(Widget child, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: child);
  }

  static final GoRouter router = GoRouter(
    refreshListenable: getIt<AuthCubit>(),
    redirect: (context, state) {
      final authState = getIt<AuthCubit>().state;
      final langState = getIt<LanguageCubit>().state;
      final isOnSplash = state.matchedLocation == AppRoutes.splashPath;

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
          final stage = state.extra as int? ?? 0;
          return _noAnimationPage(StageScreen(stage: stage,), state);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const ErrorScreen();
    },
  );
}
