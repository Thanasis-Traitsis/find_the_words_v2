import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_routes.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';

class AppRedirectPolicy {
  String? resolve({
    required AuthState authState,
    required LanguageState langState,
    required VersionState versionState,
    required String currentLocation,
  }) {
    final isOnSplash = currentLocation == AppRoutes.splashPath;
    final isOnLang = currentLocation == AppRoutes.langPath;

    if (versionState.needsForceUpdate) {
      return AppRoutes.forceUpdatePath;
    }

    if (authState is AuthAuthenticated &&
        langState.isFirstTime &&
        !isOnLang) {
      return AppRoutes.langPath;
    }

    if (authState is AuthUnauthenticated) {
      return AppRoutes.splashPath;
    }

    if (authState is AuthLoading && !isOnSplash) {
      return AppRoutes.splashPath;
    }

    if (authState is AuthAuthenticated &&
        isOnSplash &&
        !langState.isFirstTime) {
      return AppRoutes.homePath;
    }

    return null;
  }
}
