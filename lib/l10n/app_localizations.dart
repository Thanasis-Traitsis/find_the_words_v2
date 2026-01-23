import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Find the Words'**
  String get appName;

  /// No description provided for @splashScreenName.
  ///
  /// In en, this message translates to:
  /// **'Splash'**
  String get splashScreenName;

  /// No description provided for @langScreenName.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langScreenName;

  /// No description provided for @homeScreenName.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenName;

  /// No description provided for @stageScreenName.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stageScreenName;

  /// No description provided for @wordsScreenName.
  ///
  /// In en, this message translates to:
  /// **'Total Words'**
  String get wordsScreenName;

  /// No description provided for @settingsScreenName.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenName;

  /// No description provided for @themeScreenName.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get themeScreenName;

  /// No description provided for @gameInstructionsScreenName.
  ///
  /// In en, this message translates to:
  /// **'Game Instructions'**
  String get gameInstructionsScreenName;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @chooseLanguageHeader.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageHeader;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @logo.
  ///
  /// In en, this message translates to:
  /// **'home_logo_en.svg'**
  String get logo;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// Level with number
  ///
  /// In en, this message translates to:
  /// **'Level {levelNumber}'**
  String levelWithNumber(int levelNumber);

  /// Stage with number
  ///
  /// In en, this message translates to:
  /// **'Stage {stageNumber}'**
  String stageWithNumber(int stageNumber);

  /// No description provided for @languageBottomsheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get languageBottomsheetTitle;

  /// No description provided for @languageBottomsheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved separately for each language. Levels, and completed stages are tracked independently, allowing you to learn at your own pace in multiple languages.'**
  String get languageBottomsheetDescription;

  /// No description provided for @languageBottomsheetUpdateBtn.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get languageBottomsheetUpdateBtn;

  /// No description provided for @stageAndLevelCardDescription.
  ///
  /// In en, this message translates to:
  /// **'XP progress for next level'**
  String get stageAndLevelCardDescription;

  /// No description provided for @totalWordsCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Total words'**
  String get totalWordsCardDescription;

  /// No description provided for @nextStageBtnText.
  ///
  /// In en, this message translates to:
  /// **'Next Stage'**
  String get nextStageBtnText;

  /// No description provided for @stageButtonHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get stageButtonHelp;

  /// No description provided for @stageButtonShuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get stageButtonShuffle;

  /// No description provided for @settingsItemTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsItemTheme;

  /// No description provided for @settingsItemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsItemLanguage;

  /// No description provided for @settingsItemSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsItemSound;

  /// No description provided for @settingsItemGameInstructions.
  ///
  /// In en, this message translates to:
  /// **'Game instructions'**
  String get settingsItemGameInstructions;

  /// No description provided for @settingsItemResetStage.
  ///
  /// In en, this message translates to:
  /// **'Reset current stage'**
  String get settingsItemResetStage;

  /// No description provided for @settingsItemReportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get settingsItemReportBug;

  /// No description provided for @settingsItemReportBadWord.
  ///
  /// In en, this message translates to:
  /// **'Report a bad word'**
  String get settingsItemReportBadWord;

  /// No description provided for @settingsItemReportContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsItemReportContact;

  /// No description provided for @settingsItemReportPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Policy'**
  String get settingsItemReportPrivacy;

  /// No description provided for @settingsItemReportTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get settingsItemReportTermsConditions;

  /// No description provided for @settingsEmailSubjectReportBug.
  ///
  /// In en, this message translates to:
  /// **'Just found a bug'**
  String get settingsEmailSubjectReportBug;

  /// No description provided for @settingsEmailSubjectBadWord.
  ///
  /// In en, this message translates to:
  /// **'Report a bad word'**
  String get settingsEmailSubjectBadWord;

  /// No description provided for @settingsEmailSubjectContact.
  ///
  /// In en, this message translates to:
  /// **'Game Feedback'**
  String get settingsEmailSubjectContact;

  /// No description provided for @settingsResetStageBottomsheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Having trouble solving the stage? Or maybe something went wrong and the crossword didn’t load correctly? You can reset the stage and try again.'**
  String get settingsResetStageBottomsheetDescription;

  /// No description provided for @settingsResetStageBottomsheetRestartButton.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get settingsResetStageBottomsheetRestartButton;

  /// No description provided for @settingsResetStageDialogHeader.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get settingsResetStageDialogHeader;

  /// No description provided for @settingsResetStageDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the current stage? If you continue, all your progress will be lost and a new stage will start from the beginning.'**
  String get settingsResetStageDialogDescription;

  /// No description provided for @settingsResetStageDialogButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsResetStageDialogButtonCancel;

  /// No description provided for @settingsResetStageDialogButtonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get settingsResetStageDialogButtonSubmit;

  /// No description provided for @settingsBadWordBottomsheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Did you come across a word that you find inappropriate? If you noticed any offensive or unsuitable word, you can report it. Choose one of the words from the previous stage or type the word you think should be removed.'**
  String get settingsBadWordBottomsheetDescription;

  /// No description provided for @settingsBadWordBottomsheetSectionTitleStageWords.
  ///
  /// In en, this message translates to:
  /// **'Words from the previous stage'**
  String get settingsBadWordBottomsheetSectionTitleStageWords;

  /// No description provided for @settingsBadWordBottomsheetSectionTitleSelectedWord.
  ///
  /// In en, this message translates to:
  /// **'Type the word you want to be removed'**
  String get settingsBadWordBottomsheetSectionTitleSelectedWord;

  /// No description provided for @settingsBadWordBottomsheetTextfieldHint.
  ///
  /// In en, this message translates to:
  /// **'Type the word here'**
  String get settingsBadWordBottomsheetTextfieldHint;

  /// No description provided for @settingsBadWordBottomsheetButtonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsBadWordBottomsheetButtonClear;

  /// No description provided for @settingsBadWordBottomsheetButtonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get settingsBadWordBottomsheetButtonSubmit;

  /// No description provided for @themeOptionLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeOptionLight;

  /// No description provided for @themeOptionDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeOptionDark;

  /// No description provided for @themeOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeOptionSystem;

  /// No description provided for @themeOptionSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically match your device settings'**
  String get themeOptionSystemDescription;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPlaceholder;

  /// No description provided for @sortByAlphabeticalAZ.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical order A-Z'**
  String get sortByAlphabeticalAZ;

  /// No description provided for @sortByAlphabeticalZA.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical order Z-A'**
  String get sortByAlphabeticalZA;

  /// No description provided for @sortBySmallestToBiggest.
  ///
  /// In en, this message translates to:
  /// **'Smallest to largest'**
  String get sortBySmallestToBiggest;

  /// No description provided for @sortByBiggestToSmallest.
  ///
  /// In en, this message translates to:
  /// **'Largest to smallest'**
  String get sortByBiggestToSmallest;

  /// No description provided for @sortByNewestToOldest.
  ///
  /// In en, this message translates to:
  /// **'Most recent'**
  String get sortByNewestToOldest;

  /// No description provided for @sortByOldestToNewest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortByOldestToNewest;

  /// No description provided for @extraWordsDialogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No extra words found yet!'**
  String get extraWordsDialogEmpty;

  /// No description provided for @extraWordsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Extra Words'**
  String get extraWordsDialogTitle;

  /// No description provided for @extraWordsDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find hidden words that don\'t fit in the crossword and earn bonus points!'**
  String get extraWordsDialogSubtitle;

  /// No description provided for @helpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpDialogTitle;

  /// No description provided for @helpDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use available hints to reveal words or letters.'**
  String get helpDialogSubtitle;

  /// No description provided for @gameDialogCloseBtn.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get gameDialogCloseBtn;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @helpDialogShuffleTitle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get helpDialogShuffleTitle;

  /// No description provided for @helpDialogShuffleDescription.
  ///
  /// In en, this message translates to:
  /// **'Using this help, the letters are shuffled, giving you a fresh way to think.'**
  String get helpDialogShuffleDescription;

  /// No description provided for @helpDialogRandomLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Random Reveal'**
  String get helpDialogRandomLetterTitle;

  /// No description provided for @helpDialogRandomLetterDescription.
  ///
  /// In en, this message translates to:
  /// **'This hint will reveal a hidden letter in the crossword from a random position.'**
  String get helpDialogRandomLetterDescription;

  /// No description provided for @helpDialogSpecificLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Targeted Reveal'**
  String get helpDialogSpecificLetterTitle;

  /// No description provided for @helpDialogSpecificLetterDescription.
  ///
  /// In en, this message translates to:
  /// **'With this hint you choose which hidden letter of the crossword you want to reveal.'**
  String get helpDialogSpecificLetterDescription;

  /// No description provided for @helpSpecificLetterActive.
  ///
  /// In en, this message translates to:
  /// **'Pick which letter you want to uncover!'**
  String get helpSpecificLetterActive;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'EASY'**
  String get easy;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get normal;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'HARD'**
  String get hard;

  /// No description provided for @veryHard.
  ///
  /// In en, this message translates to:
  /// **'VERY HARD'**
  String get veryHard;

  /// No description provided for @completeStageTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get completeStageTitle;

  /// No description provided for @completeStageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed!'**
  String get completeStageSubtitle;

  /// No description provided for @completeStageStatisticsHeader.
  ///
  /// In en, this message translates to:
  /// **'Stage Statistics'**
  String get completeStageStatisticsHeader;

  /// No description provided for @completeStageDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Stage difficulty'**
  String get completeStageDifficulty;

  /// No description provided for @completeStageTimeSpent.
  ///
  /// In en, this message translates to:
  /// **'Stage duration'**
  String get completeStageTimeSpent;

  /// No description provided for @completeStageCrosswordWords.
  ///
  /// In en, this message translates to:
  /// **'Crossword words'**
  String get completeStageCrosswordWords;

  /// No description provided for @completeStageExtraWords.
  ///
  /// In en, this message translates to:
  /// **'Extra words'**
  String get completeStageExtraWords;

  /// No description provided for @completeStageRewardsHeader.
  ///
  /// In en, this message translates to:
  /// **'Stage Rewards'**
  String get completeStageRewardsHeader;

  /// No description provided for @completeStageCompletionPoints.
  ///
  /// In en, this message translates to:
  /// **'Stage completion'**
  String get completeStageCompletionPoints;

  /// No description provided for @completeStageWordsPoints.
  ///
  /// In en, this message translates to:
  /// **'Stage words'**
  String get completeStageWordsPoints;

  /// No description provided for @completeStageExtraWordsPoints.
  ///
  /// In en, this message translates to:
  /// **'Extra words'**
  String get completeStageExtraWordsPoints;

  /// No description provided for @completeStageLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level completion'**
  String get completeStageLevelUp;

  /// No description provided for @completeStageTotalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get completeStageTotalPoints;

  /// No description provided for @completeStageBackToHomeBtn.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get completeStageBackToHomeBtn;

  /// Total points from stage
  ///
  /// In en, this message translates to:
  /// **'Total: + {totalPoints}'**
  String completeTotalPoints(int totalPoints);

  /// No description provided for @gameRulesTitle1.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get gameRulesTitle1;

  /// No description provided for @gameRulesContent1.
  ///
  /// In en, this message translates to:
  /// **'Your goal is simple, find all the hidden words in each crossword puzzle.'**
  String get gameRulesContent1;

  /// No description provided for @gameRulesTitle2.
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get gameRulesTitle2;

  /// No description provided for @gameRulesContent2a.
  ///
  /// In en, this message translates to:
  /// **'Connect letters to form valid words.'**
  String get gameRulesContent2a;

  /// No description provided for @gameRulesContent2b.
  ///
  /// In en, this message translates to:
  /// **'Each stage is generated dynamically, so no two puzzles are the same!'**
  String get gameRulesContent2b;

  /// No description provided for @gameRulesContent2c.
  ///
  /// In en, this message translates to:
  /// **'The level number determines the size of the puzzle:'**
  String get gameRulesContent2c;

  /// No description provided for @gameRulesSubcontent2a.
  ///
  /// In en, this message translates to:
  /// **'Level 1 → the longest word has 3 letters'**
  String get gameRulesSubcontent2a;

  /// No description provided for @gameRulesSubcontent2b.
  ///
  /// In en, this message translates to:
  /// **'Level 2 → the longest word has 4 letters'**
  String get gameRulesSubcontent2b;

  /// No description provided for @gameRulesSubcontent2c.
  ///
  /// In en, this message translates to:
  /// **'Level 3 → the longest word has 5 letters, and so on'**
  String get gameRulesSubcontent2c;

  /// No description provided for @gameRulesTitle3.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get gameRulesTitle3;

  /// No description provided for @gameRulesContent3a.
  ///
  /// In en, this message translates to:
  /// **'Try forming different word combinations, you might discover bonus words!'**
  String get gameRulesContent3a;

  /// No description provided for @gameRulesContent3b.
  ///
  /// In en, this message translates to:
  /// **'Stuck? Use available hints to reveal letters or words.'**
  String get gameRulesContent3b;

  /// No description provided for @gameRulesContent3c.
  ///
  /// In en, this message translates to:
  /// **'The more you play, the more your vocabulary and word-finding skills will grow!'**
  String get gameRulesContent3c;

  /// No description provided for @gameRulesTitle4.
  ///
  /// In en, this message translates to:
  /// **'Endless Fun'**
  String get gameRulesTitle4;

  /// No description provided for @gameRulesContent4.
  ///
  /// In en, this message translates to:
  /// **'There’s no fixed path. Every puzzle is unique, offering endless word challenges and a fresh experience each time you play.'**
  String get gameRulesContent4;

  /// No description provided for @gameRulesTitle5.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your word adventure in Βρες τις Λέξεις!'**
  String get gameRulesTitle5;

  /// No description provided for @filterInfoText.
  ///
  /// In en, this message translates to:
  /// **'All letters are selected automatically, unless specific letters have been selected.'**
  String get filterInfoText;

  /// No description provided for @totalWordsEmptyResult.
  ///
  /// In en, this message translates to:
  /// **'No words found.'**
  String get totalWordsEmptyResult;

  /// No description provided for @filtersHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersHeaderTitle;

  /// No description provided for @filtersSectionHeaderAllLetters.
  ///
  /// In en, this message translates to:
  /// **'All letters'**
  String get filtersSectionHeaderAllLetters;

  /// No description provided for @filtersSectionContentShowAllLetters.
  ///
  /// In en, this message translates to:
  /// **'Show words from all letters'**
  String get filtersSectionContentShowAllLetters;

  /// No description provided for @filtersSectionHeaderSelectedLetters.
  ///
  /// In en, this message translates to:
  /// **'Select letters'**
  String get filtersSectionHeaderSelectedLetters;

  /// No description provided for @filtersSectionButtonClearLetters.
  ///
  /// In en, this message translates to:
  /// **'Clear letters'**
  String get filtersSectionButtonClearLetters;

  /// No description provided for @filtersSectionHeaderWordLength.
  ///
  /// In en, this message translates to:
  /// **'Word length'**
  String get filtersSectionHeaderWordLength;

  /// Show min and max word length
  ///
  /// In en, this message translates to:
  /// **'Selected word length from: {minLength} - {maxLength}'**
  String filtersSectionContentWordLength(int minLength, int maxLength);

  /// No description provided for @filtersButtonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filtersButtonApply;

  /// No description provided for @filtersButtonClean.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filtersButtonClean;

  /// No description provided for @chipAllLetters.
  ///
  /// In en, this message translates to:
  /// **'All letters'**
  String get chipAllLetters;

  /// Show selected letters
  ///
  /// In en, this message translates to:
  /// **'Selected letters: {letters}'**
  String chipSelectedLetters(String letters);

  /// Show selected letters
  ///
  /// In en, this message translates to:
  /// **'Word length: {minWordLength} - {maxWordLength}'**
  String chipSelectedRangeOfWordLength(int minWordLength, int maxWordLength);

  /// No description provided for @storeBottomsheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeBottomsheetTitle;

  /// No description provided for @storeBottomsheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you\'ll find many offers and boosts for your game!'**
  String get storeBottomsheetDescription;

  /// No description provided for @currentBoostTag.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE BOOST'**
  String get currentBoostTag;

  /// No description provided for @currentBoostXpMultiplierHeader.
  ///
  /// In en, this message translates to:
  /// **'Level XP Multiplier'**
  String get currentBoostXpMultiplierHeader;

  /// No description provided for @currentBoostXpMultiplierDurationSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get currentBoostXpMultiplierDurationSubtitle1;

  /// Plural form for levels
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{level} other{levels}}'**
  String currentBoostXpMultiplierStageSubtitle1(int count);

  /// Plural form for remaining
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{remaining} other{remaining}}'**
  String currentBoostXpMultiplierSubtitle2(num count);

  /// No description provided for @xpMultiplierHeader.
  ///
  /// In en, this message translates to:
  /// **'Multiplier'**
  String get xpMultiplierHeader;

  /// Define the multiplier
  ///
  /// In en, this message translates to:
  /// **'Multiply your experience! Earn x{multiplier} XP for every level you complete.'**
  String xpMultiplierDescription(int multiplier);

  /// No description provided for @xpMultiplierFirstOfferHeader.
  ///
  /// In en, this message translates to:
  /// **'By Time'**
  String get xpMultiplierFirstOfferHeader;

  /// No description provided for @xpMultiplierFirstOfferDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how long your boost will last.'**
  String get xpMultiplierFirstOfferDescription;

  /// Plural form for minutes
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{minute} other{minutes}}'**
  String xpMultiplierFirstOfferCardText(int count);

  /// No description provided for @xpMultiplierSecondOfferHeader.
  ///
  /// In en, this message translates to:
  /// **'By Levels'**
  String get xpMultiplierSecondOfferHeader;

  /// No description provided for @xpMultiplierSecondOfferDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how many levels you want to boost your experience for.'**
  String get xpMultiplierSecondOfferDescription;

  /// Plural form for levels
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{level} other{levels}}'**
  String xpMultiplierSecondOfferCardText(int count);

  /// No description provided for @freezeHeader.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get freezeHeader;

  /// No description provided for @freezeDescription.
  ///
  /// In en, this message translates to:
  /// **'Stop the timer and solve the level at your own pace! Think through your moves without the rush.'**
  String get freezeDescription;

  /// No description provided for @rewardsHeader.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsHeader;

  /// No description provided for @rewardsFirstOfferTitleSmall.
  ///
  /// In en, this message translates to:
  /// **'Earn'**
  String get rewardsFirstOfferTitleSmall;

  /// Points the user will earn
  ///
  /// In en, this message translates to:
  /// **'{rewardPoints} {rewardPoints, plural, =1{point} other{points}}!'**
  String rewardsFirstOfferTitleBig(int rewardPoints);

  /// Points the user will earn
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad and earn {rewardPoints} {rewardPoints, plural, =1{point} other{points}}!'**
  String rewardsFirstOfferDescription(int rewardPoints);

  /// No description provided for @rewardsSecondOfferTitleSmall.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get rewardsSecondOfferTitleSmall;

  /// Percentage the user will earn
  ///
  /// In en, this message translates to:
  /// **'{offerPercentage}% discount!'**
  String rewardsSecondOfferTitleBig(int offerPercentage);

  /// Percentage the user will earn
  ///
  /// In en, this message translates to:
  /// **'Watch an ad and activate {offerPercentage}% off on all products!'**
  String rewardsSecondOfferDescription(int offerPercentage);

  /// No description provided for @rewardsThirdOfferTitleSmall.
  ///
  /// In en, this message translates to:
  /// **'Earn'**
  String get rewardsThirdOfferTitleSmall;

  /// How many freezes the user will earn
  ///
  /// In en, this message translates to:
  /// **'{freezes} {freezes, plural, =1{freeze} other{freezes}}!'**
  String rewardsThirdOfferTitleBig(int freezes);

  /// How many freezes the user will earn
  ///
  /// In en, this message translates to:
  /// **'Watch an ad and {freezes} freeze {freezes, plural, =1{power} other{powers}} will instantly be yours!'**
  String rewardsThirdOfferDescription(int freezes);

  /// No description provided for @rewardActiveCard.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get rewardActiveCard;

  /// No description provided for @stageCompletionXpBoostHeader.
  ///
  /// In en, this message translates to:
  /// **'Multiplier XP'**
  String get stageCompletionXpBoostHeader;

  /// No description provided for @stageCompletionXpBoostDescription.
  ///
  /// In en, this message translates to:
  /// **'You won extra points of experience from this stage'**
  String get stageCompletionXpBoostDescription;

  /// No description provided for @notAvailableTag.
  ///
  /// In en, this message translates to:
  /// **'NOT AVAILABLE'**
  String get notAvailableTag;

  /// Points before discount
  ///
  /// In en, this message translates to:
  /// **'from {totalAmount}'**
  String priceBeforeDiscount(int totalAmount);

  /// No description provided for @currentDiscountHeader.
  ///
  /// In en, this message translates to:
  /// **'Active Discount'**
  String get currentDiscountHeader;

  /// The percentage of the discount
  ///
  /// In en, this message translates to:
  /// **'Get {discountPercentage}% off everything! Grab your items before time runs out!'**
  String currentDiscountDescription(int discountPercentage);

  /// No description provided for @confirmPurchaseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Confirmation'**
  String get confirmPurchaseDialogTitle;

  /// The cost of the purchase
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to complete this purchase? By confirming, {costPoints} points will be deducted from your account.'**
  String confirmPurchaseDialogDescription(int costPoints);

  /// No description provided for @confirmPurchaseDialogCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmPurchaseDialogCancelButton;

  /// No description provided for @confirmPurchaseDialogConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmPurchaseDialogConfirmButton;

  /// No description provided for @purchaseSnackbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Completed'**
  String get purchaseSnackbarTitle;

  /// No description provided for @purchaseFreezeSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ve unlocked Freeze! You can now use it in the game.'**
  String get purchaseFreezeSnackbarMessage;

  /// No description provided for @rewardNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reward Unlocked!'**
  String get rewardNotificationTitle;

  /// Rewarded points from ad
  ///
  /// In en, this message translates to:
  /// **'You’ve earned {points} bonus points!'**
  String rewardPointsNotificationMessage(int points);

  /// Store percentage offer after rewarded ad
  ///
  /// In en, this message translates to:
  /// **'You’ve unlocked a {percentage}% discount in the store!'**
  String rewardDiscountNotificationMessage(int percentage);

  /// No description provided for @rewardFreezeNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ve received a Freeze power-up for free!'**
  String get rewardFreezeNotificationMessage;

  /// No description provided for @notEnoughPointsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough points for this help...'**
  String get notEnoughPointsErrorMessage;

  /// No description provided for @resetStageNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'successful reset'**
  String get resetStageNotificationTitle;

  /// No description provided for @resetStageNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'The stage was successfully deleted. A brand new stage is waiting!'**
  String get resetStageNotificationMessage;

  /// Date that the user signed in
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String joinedOn(String date);

  /// No description provided for @logoutBtnText.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutBtnText;

  /// No description provided for @logoutDialogHeader.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutDialogHeader;

  /// No description provided for @logoutDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? After signing out, your progress will be saved only locally on your device and will not be synced to your online account until you sign in again.'**
  String get logoutDialogDescription;

  /// No description provided for @logoutDialogButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logoutDialogButtonCancel;

  /// No description provided for @logoutDialogButtonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutDialogButtonSubmit;

  /// No description provided for @googleSignInSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome in!'**
  String get googleSignInSuccessTitle;

  /// No description provided for @googleSignInSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully signed in.'**
  String get googleSignInSuccessMessage;

  /// No description provided for @googleSignInFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get googleSignInFailureTitle;

  /// No description provided for @googleSignInFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while signing you in. Please try again.'**
  String get googleSignInFailureMessage;

  /// No description provided for @googleSignOutSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get googleSignOutSuccessTitle;

  /// No description provided for @googleSignOutSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You are now signed out. Your progress will continue to be saved locally.'**
  String get googleSignOutSuccessMessage;

  /// No description provided for @googleSignOutFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-out failed'**
  String get googleSignOutFailureTitle;

  /// No description provided for @googleSignOutFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t sign you out. Please try again.'**
  String get googleSignOutFailureMessage;

  /// No description provided for @noWifiNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'offline mode'**
  String get noWifiNotificationTitle;

  /// No description provided for @noWifiNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Progress will sync when you’re online.'**
  String get noWifiNotificationMessage;

  /// No description provided for @profileBannerStatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Profile stats for every available language'**
  String get profileBannerStatsDescription;

  /// No description provided for @profileBannerStatsCardWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get profileBannerStatsCardWords;

  /// No description provided for @profileBannerStatsCardStages.
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get profileBannerStatsCardStages;

  /// No description provided for @profileBannerStatsCardPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profileBannerStatsCardPoints;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
