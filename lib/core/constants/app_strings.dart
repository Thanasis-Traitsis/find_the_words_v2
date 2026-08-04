class AppStrings {
  static const String appName = 'Βρες τις Λέξεις';

  // Errors
  // Developer-facing (logs only)
  static const String devThemeLoadError = 'Failed to load theme';
  static const String devThemeSaveError = 'Failed to save theme';
  static const String devLanguageLoadError = 'Failed to load selected language';
  static const String devLanguageSaveError = 'Failed to save new language';
  static const String devFreezeLoadError = 'Failed to load freeze';

  // Bootstrap failure (user-facing, shown before localization loads)
  static const String bootstrapErrorMessage =
      'Something went wrong while starting the app.';
  static const String bootstrapErrorRetry = 'Try Again';
}
