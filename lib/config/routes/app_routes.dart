import 'package:find_the_words/core/services/navigation_service.dart';

class AppRoutes {
  static const String splashPath = '/splash';
  static const String langPath = '/lang';
  static const String homePath = '/';
  static const String stagePath = '/stage';
  static const String wordsPath = '/words';
  static const String settingsPath = '/settings';
  static const String themePath = '/theme';
  static const String completePath = '/complete';

  static const String splashScreenName = 'Splash';
  static const String langScreenName = 'Language';
  static const String homeScreenName = 'Home';
  static const String stageScreenName = 'Stage';
  static const String wordsScreenName = 'Total Words';
  static const String settingsScreenName = 'Settings';
  static const String themeScreenName = 'Choose Theme';
  static const String completeScreenName = 'Complete Stage';
}

class PageInfo {
  final String path;
  final String name;

  const PageInfo({required this.path, required this.name});

  void go({Object? extra}) => NavigationService.instance.go(path, extra: extra);
  void push({Object? extra}) =>
      NavigationService.instance.push(path, extra: extra);
}
