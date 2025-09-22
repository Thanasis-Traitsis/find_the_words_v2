// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Find the Words';

  @override
  String get loading => 'Loading';

  @override
  String get chooseLanguageHeader => 'Choose your language';

  @override
  String get submit => 'Submit';

  @override
  String get logo => 'home_logo_en.svg';

  @override
  String get level => 'Level';

  @override
  String get stage => 'Stage';

  @override
  String levelWithNumber(int levelNumber) {
    return 'Level $levelNumber';
  }

  @override
  String stageWithNumber(int stageNumber) {
    return 'Stage $stageNumber';
  }

  @override
  String get languageBottomsheetTitle => 'Change Language';

  @override
  String get languageBottomsheetDescription =>
      'Your progress is saved separately for each language. Levels, and completed stages are tracked independently, allowing you to learn at your own pace in multiple languages.';

  @override
  String get languageBottomsheetUpdateBtn => 'Update';

  @override
  String get stageAndLevelCardDescription => 'XP progress for next level';

  @override
  String get totalWordsCardDescription => 'Total words';

  @override
  String get nextStageBtnText => 'Next Stage';

  @override
  String get stageButtonHelp => 'Help';

  @override
  String get stageButtonShuffle => 'Shuffle';
}
