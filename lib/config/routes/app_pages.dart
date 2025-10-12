import 'package:find_the_words/config/routes/app_routes.dart';

enum AppPages {
  splash,
  lang,
  home,
  stage,
  words,
  settings,
  theme,
  complete;

  void go({Object? extra}) => info.go(extra: extra);
  void push({Object? extra}) => info.push(extra: extra);

  PageInfo get info => switch (this) {
    splash => const PageInfo(
      path: AppRoutes.splashPath,
      name: AppRoutes.splashScreenName,
    ),
    lang => const PageInfo(
      path: AppRoutes.langPath,
      name: AppRoutes.langScreenName,
    ),
    home => const PageInfo(
      path: AppRoutes.homePath,
      name: AppRoutes.homeScreenName,
    ),
    stage => const PageInfo(
      path: AppRoutes.stagePath,
      name: AppRoutes.stageScreenName,
    ),
    words => const PageInfo(
      path: AppRoutes.wordsPath,
      name: AppRoutes.wordsScreenName,
    ),
    settings => const PageInfo(
      path: AppRoutes.settingsPath,
      name: AppRoutes.settingsScreenName,
    ),
    theme => const PageInfo(
      path: AppRoutes.themePath,
      name: AppRoutes.themeScreenName,
    ),
    complete => const PageInfo(
      path: AppRoutes.completePath,
      name: AppRoutes.completeScreenName,
    ),
  };
}
