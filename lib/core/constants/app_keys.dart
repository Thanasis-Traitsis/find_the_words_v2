class AppKeys {
  static const String themeModeKey = 'app_theme_mode';
  static const String languageCodeKey = 'language_code';
  static const String authTokenKey = 'auth_token';
  static String timerKey(int stage) => 'timer_key_$stage';

  static const String usedStageKey = 'used_stage';
  static const String bannedStageKey = 'banned_stage';
  static const String failedWords = 'failed_words';

  static const String boardPlaceholder = '/';
  static const String boardBannedPlace = '//';

  static const String usersFirebaseCollectionKey = 'users';
}
