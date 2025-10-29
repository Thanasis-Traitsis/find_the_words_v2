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
  String get splashScreenName => 'Splash';

  @override
  String get langScreenName => 'Language';

  @override
  String get homeScreenName => 'Home';

  @override
  String get stageScreenName => 'Stage';

  @override
  String get wordsScreenName => 'Total Words';

  @override
  String get settingsScreenName => 'Settings';

  @override
  String get themeScreenName => 'Choose Theme';

  @override
  String get gameInstructionsScreenName => 'Game Instructions';

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
  String get languageBottomsheetDescription => 'Your progress is saved separately for each language. Levels, and completed stages are tracked independently, allowing you to learn at your own pace in multiple languages.';

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

  @override
  String get settingsItemTheme => 'Theme';

  @override
  String get settingsItemLanguage => 'Language';

  @override
  String get settingsItemSound => 'Sound';

  @override
  String get settingsItemGameInstructions => 'Game instructions';

  @override
  String get settingsItemResetStage => 'Reset current stage';

  @override
  String get settingsItemReportBug => 'Report a bug';

  @override
  String get settingsItemReportBadWord => 'Report a bad word';

  @override
  String get settingsItemReportContact => 'Contact us';

  @override
  String get settingsItemReportPrivacy => 'Privacy & Policy';

  @override
  String get settingsItemReportTermsConditions => 'Terms & Conditions';

  @override
  String get themeOptionLight => 'Light';

  @override
  String get themeOptionDark => 'Dark';

  @override
  String get themeOptionSystem => 'System';

  @override
  String get themeOptionSystemDescription => 'Automatically match your device settings';

  @override
  String get searchPlaceholder => 'Search';

  @override
  String get sortByAlphabetical => 'Alphabetical order';

  @override
  String get sortBySmallestToBiggest => 'Smallest to largest';

  @override
  String get sortByBiggestToSmallest => 'Largest to smallest';

  @override
  String get extraWordsDialogEmpty => 'No extra words found yet!';

  @override
  String get extraWordsDialogTitle => 'Extra Words';

  @override
  String get extraWordsDialogSubtitle => 'Find hidden words that don\'t fit in the crossword and earn bonus points!';

  @override
  String get helpDialogTitle => 'Help';

  @override
  String get helpDialogSubtitle => 'Use available hints to reveal words or letters.';

  @override
  String get gameDialogCloseBtn => 'Close';

  @override
  String get free => 'Free';

  @override
  String get helpDialogShuffleTitle => 'Shuffle';

  @override
  String get helpDialogShuffleDescription => 'Using this help, the letters are shuffled, giving you a fresh way to think.';

  @override
  String get helpDialogRandomLetterTitle => 'Random Reveal';

  @override
  String get helpDialogRandomLetterDescription => 'This hint will reveal a hidden letter in the crossword from a random position.';

  @override
  String get helpDialogSpecificLetterTitle => 'Targeted Reveal';

  @override
  String get helpDialogSpecificLetterDescription => 'With this hint you choose which hidden letter of the crossword you want to reveal.';

  @override
  String get helpSpecificLetterActive => 'Pick which letter you want to uncover!';

  @override
  String get easy => 'EASY';

  @override
  String get normal => 'NORMAL';

  @override
  String get hard => 'HARD';

  @override
  String get veryHard => 'VERY HARD';

  @override
  String get completeStageTitle => 'Stage';

  @override
  String get completeStageSubtitle => 'Completed!';

  @override
  String get completeStageStatisticsHeader => 'Stage Statistics';

  @override
  String get completeStageDifficulty => 'Stage difficulty';

  @override
  String get completeStageTimeSpent => 'Stage duration';

  @override
  String get completeStageCrosswordWords => 'Crossword words';

  @override
  String get completeStageExtraWords => 'Extra words';

  @override
  String get completeStageRewardsHeader => 'Stage Rewards';

  @override
  String get completeStageCompletionPoints => 'Stage completion';

  @override
  String get completeStageWordsPoints => 'Stage words';

  @override
  String get completeStageExtraWordsPoints => 'Extra words';

  @override
  String get completeStageTotalPoints => 'Total';

  @override
  String get completeStageBackToHomeBtn => 'Back to home';

  @override
  String completeTotalPoints(int totalPoints) {
    return 'Total: + $totalPoints';
  }

  @override
  String get gameRulesTitle1 => 'How to Play';

  @override
  String get gameRulesContent1 => 'Your goal is simple, find all the hidden words in each crossword puzzle.';

  @override
  String get gameRulesTitle2 => 'Game Rules';

  @override
  String get gameRulesContent2a => 'Connect letters to form valid words.';

  @override
  String get gameRulesContent2b => 'Each stage is generated dynamically, so no two puzzles are the same!';

  @override
  String get gameRulesContent2c => 'The level number determines the size of the puzzle:';

  @override
  String get gameRulesSubcontent2a => 'Level 1 → the longest word has 3 letters';

  @override
  String get gameRulesSubcontent2b => 'Level 2 → the longest word has 4 letters';

  @override
  String get gameRulesSubcontent2c => 'Level 3 → the longest word has 5 letters, and so on';

  @override
  String get gameRulesTitle3 => 'Tips';

  @override
  String get gameRulesContent3a => 'Try forming different word combinations, you might discover bonus words!';

  @override
  String get gameRulesContent3b => 'Stuck? Use available hints to reveal letters or words.';

  @override
  String get gameRulesContent3c => 'The more you play, the more your vocabulary and word-finding skills will grow!';

  @override
  String get gameRulesTitle4 => 'Endless Fun';

  @override
  String get gameRulesContent4 => 'There’s no fixed path. Every puzzle is unique, offering endless word challenges and a fresh experience each time you play.';

  @override
  String get gameRulesTitle5 => 'Enjoy your word adventure in Βρες τις Λέξεις!';
}
