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
  String get settingsEmailSubjectReportBug => 'Just found a bug';

  @override
  String get settingsEmailSubjectBadWord => 'Report a bad word';

  @override
  String get settingsEmailSubjectContact => 'Game Feedback';

  @override
  String get settingsResetStageBottomsheetDescription => 'Having trouble solving the stage? Or maybe something went wrong and the crossword didn’t load correctly? You can reset the stage and try again.';

  @override
  String get settingsResetStageBottomsheetRestartButton => 'Restart';

  @override
  String get settingsResetStageDialogHeader => 'Warning!';

  @override
  String get settingsResetStageDialogDescription => 'Are you sure you want to delete the current stage? If you continue, all your progress will be lost and a new stage will start from the beginning.';

  @override
  String get settingsResetStageDialogButtonCancel => 'Close';

  @override
  String get settingsResetStageDialogButtonSubmit => 'Submit';

  @override
  String get settingsBadWordBottomsheetDescription => 'Did you come across a word that you find inappropriate? If you noticed any offensive or unsuitable word, you can report it. Choose one of the words from the previous stage or type the word you think should be removed.';

  @override
  String get settingsBadWordBottomsheetSectionTitleStageWords => 'Words from the previous stage';

  @override
  String get settingsBadWordBottomsheetSectionTitleSelectedWord => 'Type the word you want to be removed';

  @override
  String get settingsBadWordBottomsheetTextfieldHint => 'Type the word here';

  @override
  String get settingsBadWordBottomsheetButtonClear => 'Clear';

  @override
  String get settingsBadWordBottomsheetButtonSubmit => 'Submit';

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
  String get sortByAlphabeticalAZ => 'Alphabetical order A-Z';

  @override
  String get sortByAlphabeticalZA => 'Alphabetical order Z-A';

  @override
  String get sortBySmallestToBiggest => 'Smallest to largest';

  @override
  String get sortByBiggestToSmallest => 'Largest to smallest';

  @override
  String get sortByNewestToOldest => 'Most recent';

  @override
  String get sortByOldestToNewest => 'Oldest';

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
  String get helpDialogFreezeTitle => 'Freeze';

  @override
  String get helpDialogFreezeDescription => 'Freeze allows you to temporarily stop the stage timer. This gives you more time to complete challenges and earn increased rewards when finishing the stage.';

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
  String get completeStageLevelUp => 'Level completion';

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

  @override
  String get filterInfoText => 'All letters are selected automatically, unless specific letters have been selected.';

  @override
  String get totalWordsEmptyResult => 'No words found.';

  @override
  String get filtersHeaderTitle => 'Filters';

  @override
  String get filtersSectionHeaderAllLetters => 'All letters';

  @override
  String get filtersSectionContentShowAllLetters => 'Show words from all letters';

  @override
  String get filtersSectionHeaderSelectedLetters => 'Select letters';

  @override
  String get filtersSectionButtonClearLetters => 'Clear letters';

  @override
  String get filtersSectionHeaderWordLength => 'Word length';

  @override
  String get filtersSectionDescriptionSelectedLetters => 'Select one or more letters to display only words that start with them.';

  @override
  String filtersSectionContentWordLength(int minLength, int maxLength) {
    return 'Selected word length from: $minLength - $maxLength';
  }

  @override
  String get filtersSectionHeaderPreviousStageWords => 'Words from the previous stage';

  @override
  String get filtersSectionDescriptionPreviousStageWords => 'Select a word from the previous stage and instantly see its meaning with a single tap.';

  @override
  String get filtersSectionButtonQuickSearch => 'Quick search';

  @override
  String get filtersButtonApply => 'Apply filters';

  @override
  String get filtersButtonClean => 'Clear';

  @override
  String get chipAllLetters => 'All letters';

  @override
  String chipSelectedLetters(String letters) {
    return 'Selected letters: $letters';
  }

  @override
  String chipSelectedRangeOfWordLength(int minWordLength, int maxWordLength) {
    return 'Word length: $minWordLength - $maxWordLength';
  }

  @override
  String get storeBottomsheetTitle => 'Store';

  @override
  String get storeBottomsheetDescription => 'Here you\'ll find many offers and boosts for your game!';

  @override
  String get currentBoostTag => 'ACTIVE BOOST';

  @override
  String get currentBoostXpMultiplierHeader => 'Level XP Multiplier';

  @override
  String get currentBoostXpMultiplierDurationSubtitle1 => 'minutes';

  @override
  String currentBoostXpMultiplierStageSubtitle1(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'levels',
      one: 'level',
    );
    return '$_temp0';
  }

  @override
  String currentBoostXpMultiplierSubtitle2(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'remaining',
      one: 'remaining',
    );
    return '$_temp0';
  }

  @override
  String get xpMultiplierHeader => 'Multiplier';

  @override
  String xpMultiplierDescription(int multiplier) {
    return 'Multiply your experience! Earn x$multiplier XP for every level you complete.';
  }

  @override
  String get xpMultiplierFirstOfferHeader => 'By Time';

  @override
  String get xpMultiplierFirstOfferDescription => 'Choose how long your boost will last.';

  @override
  String xpMultiplierFirstOfferCardText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$_temp0';
  }

  @override
  String get xpMultiplierSecondOfferHeader => 'By Levels';

  @override
  String get xpMultiplierSecondOfferDescription => 'Choose how many levels you want to boost your experience for.';

  @override
  String xpMultiplierSecondOfferCardText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'levels',
      one: 'level',
    );
    return '$_temp0';
  }

  @override
  String get freezeHeader => 'Freeze';

  @override
  String get freezeDescription => 'Stop the timer and solve the level at your own pace! Think through your moves without the rush.';

  @override
  String get rewardsHeader => 'Rewards';

  @override
  String get rewardsFirstOfferTitleSmall => 'Earn';

  @override
  String rewardsFirstOfferTitleBig(int rewardPoints) {
    String _temp0 = intl.Intl.pluralLogic(
      rewardPoints,
      locale: localeName,
      other: 'points',
      one: 'point',
    );
    return '$rewardPoints $_temp0!';
  }

  @override
  String rewardsFirstOfferDescription(int rewardPoints) {
    String _temp0 = intl.Intl.pluralLogic(
      rewardPoints,
      locale: localeName,
      other: 'points',
      one: 'point',
    );
    return 'Watch a short ad and earn $rewardPoints $_temp0!';
  }

  @override
  String get rewardsSecondOfferTitleSmall => 'Activate';

  @override
  String rewardsSecondOfferTitleBig(int offerPercentage) {
    return '$offerPercentage% discount!';
  }

  @override
  String rewardsSecondOfferDescription(int offerPercentage) {
    return 'Watch an ad and activate $offerPercentage% off on all products!';
  }

  @override
  String get rewardsThirdOfferTitleSmall => 'Earn';

  @override
  String rewardsThirdOfferTitleBig(int freezes) {
    String _temp0 = intl.Intl.pluralLogic(
      freezes,
      locale: localeName,
      other: 'freezes',
      one: 'freeze',
    );
    return '$freezes $_temp0!';
  }

  @override
  String rewardsThirdOfferDescription(int freezes) {
    String _temp0 = intl.Intl.pluralLogic(
      freezes,
      locale: localeName,
      other: 'powers',
      one: 'power',
    );
    return 'Watch an ad and $freezes freeze $_temp0 will instantly be yours!';
  }

  @override
  String get rewardActiveCard => 'ACTIVE';

  @override
  String get stageCompletionXpBoostHeader => 'Multiplier XP';

  @override
  String get stageCompletionXpBoostDescription => 'You won extra points of experience from this stage';

  @override
  String get notAvailableTag => 'NOT AVAILABLE';

  @override
  String priceBeforeDiscount(int totalAmount) {
    return 'from $totalAmount';
  }

  @override
  String get currentDiscountHeader => 'Active Discount';

  @override
  String currentDiscountDescription(int discountPercentage) {
    return 'Get $discountPercentage% off everything! Grab your items before time runs out!';
  }

  @override
  String get confirmPurchaseDialogTitle => 'Purchase Confirmation';

  @override
  String confirmPurchaseDialogDescription(int costPoints) {
    return 'Are you sure you want to complete this purchase? By confirming, $costPoints points will be deducted from your account.';
  }

  @override
  String get confirmPurchaseDialogCancelButton => 'Cancel';

  @override
  String get confirmPurchaseDialogConfirmButton => 'Confirm';

  @override
  String get purchaseSnackbarTitle => 'Purchase Completed';

  @override
  String get purchaseFreezeSnackbarMessage => 'You’ve unlocked Freeze! You can now use it in the game.';

  @override
  String get rewardNotificationTitle => 'Reward Unlocked!';

  @override
  String rewardPointsNotificationMessage(int points) {
    return 'You’ve earned $points bonus points!';
  }

  @override
  String rewardDiscountNotificationMessage(int percentage) {
    return 'You’ve unlocked a $percentage% discount in the store!';
  }

  @override
  String get rewardFreezeNotificationMessage => 'You’ve received a Freeze power-up for free!';

  @override
  String get notEnoughPointsErrorMessage => 'You don\'t have enough points for this help...';

  @override
  String get resetStageNotificationTitle => 'successful reset';

  @override
  String get resetStageNotificationMessage => 'The stage was successfully deleted. A brand new stage is waiting!';

  @override
  String joinedOn(String date) {
    return 'Joined on $date';
  }

  @override
  String get logoutBtnText => 'Logout';

  @override
  String get logoutDialogHeader => 'Sign out';

  @override
  String get logoutDialogDescription => 'Are you sure you want to sign out? After signing out, your progress will be saved only locally on your device and will not be synced to your online account until you sign in again.';

  @override
  String get logoutDialogButtonCancel => 'Cancel';

  @override
  String get logoutDialogButtonSubmit => 'Sign out';

  @override
  String get googleSignInSuccessTitle => 'Welcome in!';

  @override
  String get googleSignInSuccessMessage => 'You have successfully signed in.';

  @override
  String get googleSignInFailureTitle => 'Sign-in failed';

  @override
  String get googleSignInFailureMessage => 'Something went wrong while signing you in. Please try again.';

  @override
  String get googleSignOutSuccessTitle => 'Signed out';

  @override
  String get googleSignOutSuccessMessage => 'You are now signed out. Your progress will continue to be saved locally.';

  @override
  String get googleSignOutFailureTitle => 'Sign-out failed';

  @override
  String get googleSignOutFailureMessage => 'We couldn’t sign you out. Please try again.';

  @override
  String get noWifiNotificationTitle => 'offline mode';

  @override
  String get noWifiNotificationMessage => 'Progress will sync when you’re online.';

  @override
  String get profileBannerStatsDescription => 'Profile stats for every available language';

  @override
  String get profileBannerStatsCardWords => 'Words';

  @override
  String get profileBannerStatsCardStages => 'Stages';

  @override
  String get profileBannerStatsCardPoints => 'Points';
}
