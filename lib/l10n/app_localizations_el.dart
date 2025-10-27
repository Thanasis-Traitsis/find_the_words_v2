// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Βρες τις Λέξεις';

  @override
  String get splashScreenName => 'Εκκίνηση';

  @override
  String get langScreenName => 'Γλώσσα';

  @override
  String get homeScreenName => 'Αρχική';

  @override
  String get stageScreenName => 'Στάδιο';

  @override
  String get wordsScreenName => 'Συνολικές Λέξεις';

  @override
  String get settingsScreenName => 'Ρυθμίσεις';

  @override
  String get themeScreenName => 'Επιλογή Θέματος';

  @override
  String get gameInstructionsScreenName => 'Οδηγίες παιχνιδιού';

  @override
  String get loading => 'Φόρτωση';

  @override
  String get chooseLanguageHeader => 'Διάλεξε τη γλώσσα σου';

  @override
  String get submit => 'Υποβολή';

  @override
  String get logo => 'home_logo.svg';

  @override
  String get level => 'Επίπεδο';

  @override
  String get stage => 'Στάδιο';

  @override
  String levelWithNumber(int levelNumber) {
    return 'Επίπεδο $levelNumber';
  }

  @override
  String stageWithNumber(int stageNumber) {
    return 'Στάδιο $stageNumber';
  }

  @override
  String get languageBottomsheetTitle => 'Αλλαγή Γλώσσας';

  @override
  String get languageBottomsheetDescription => 'Η πρόοδός σας αποθηκεύεται ξεχωριστά για κάθε γλώσσα. Τα επίπεδα και τα ολοκληρωμένα στάδια παρακολουθούνται ανεξάρτητα, επιτρέποντάς σας να μαθαίνετε με το δικό σας ρυθμό σε πολλές γλώσσες.';

  @override
  String get languageBottomsheetUpdateBtn => 'Ενημέρωση';

  @override
  String get stageAndLevelCardDescription => 'XP πρόοδος επόμενου επιπέδου';

  @override
  String get totalWordsCardDescription => 'Συνολικές λέξεις';

  @override
  String get nextStageBtnText => 'Επόμενο Στάδιο';

  @override
  String get stageButtonHelp => 'Βοήθεια';

  @override
  String get stageButtonShuffle => 'Ανακάτεμα';

  @override
  String get settingsItemTheme => 'Θέμα';

  @override
  String get settingsItemLanguage => 'Γλώσσα';

  @override
  String get settingsItemSound => 'Ήχος';

  @override
  String get settingsItemGameInstructions => 'Οδηγίες παιχνιδιού';

  @override
  String get settingsItemResetStage => 'Επανεκκίνηση σταδίου';

  @override
  String get settingsItemReportBug => 'Αναφορά προβλήματος';

  @override
  String get settingsItemReportBadWord => 'Αναφορά κακής λέξης';

  @override
  String get settingsItemReportContact => 'Επικοινωνία';

  @override
  String get settingsItemReportPrivacy => 'Πολιτική Απορρήτου';

  @override
  String get settingsItemReportTermsConditions => 'Όροι και Προϋποθέσεις';

  @override
  String get themeOptionLight => 'Ανοιχτό';

  @override
  String get themeOptionDark => 'Σκούρο';

  @override
  String get themeOptionSystem => 'Σύστημα';

  @override
  String get themeOptionSystemDescription => 'Ακολουθεί αυτόματα τις ρυθμίσεις της συσκευής';

  @override
  String get searchPlaceholder => 'Αναζήτηση';

  @override
  String get sortByAlphabetical => 'Αλφαβητική σειρά';

  @override
  String get sortBySmallestToBiggest => 'Από μικρ. στο μεγ.';

  @override
  String get sortByBiggestToSmallest => 'Από μεγ. στο μικρ.';

  @override
  String get extraWordsDialogEmpty => 'Δεν έχει βρεθεί καμία έξτρα λέξη!';

  @override
  String get extraWordsDialogTitle => 'Έξτρα Λέξεις';

  @override
  String get extraWordsDialogSubtitle => 'Βρες κρυφές λέξεις που δεν χωράνε στο σταυρόλεξο και κέρδισε επιπλέον πόντους!';

  @override
  String get helpDialogTitle => 'Βοήθεια';

  @override
  String get helpDialogSubtitle => 'Χρησιμοποίησε τις διαθέσιμες βοήθειες για να αποκαλύψεις λέξεις ή γράμματα.';

  @override
  String get gameDialogCloseBtn => 'Κλείσιμο';

  @override
  String get free => 'Δωρεάν';

  @override
  String get helpDialogShuffleTitle => 'Ανακάτεμα';

  @override
  String get helpDialogShuffleDescription => 'Χρησιμοποιώντας αυτή τη βοήθεια, τα γράμματα ανακατεύονται, δίνοντάς σου έναν νέο τρόπο σκέψης.';

  @override
  String get helpDialogRandomLetterTitle => 'Τυχαία αποκάλυψη';

  @override
  String get helpDialogRandomLetterDescription => 'Με αυτή τη βοήθεια θα εμφανιστεί ένα κρυφό γράμμα μέσα στο σταυρόλεξο από μία τυχαία θέση.';

  @override
  String get helpDialogSpecificLetterTitle => 'Στοχευμένη αποκάλυψη';

  @override
  String get helpDialogSpecificLetterDescription => 'Με αυτή τη βοήθεια διαλέγεις ποιο κρυφό γράμμα του σταυρολέξου θέλεις να εμφανιστεί.';

  @override
  String get helpSpecificLetterActive => 'Διάλεξε ποιο γράμμα θέλεις να σου αποκαλυφθεί!';

  @override
  String get easy => 'ΕΥΚΟΛΟ';

  @override
  String get normal => 'ΜΕΤΡΙΟ';

  @override
  String get hard => 'ΔΥΣΚΟΛΟ';

  @override
  String get veryHard => 'ΠΟΛΥ ΔΥΣΚΟΛΟ';

  @override
  String get completeStageTitle => 'Στάδιο';

  @override
  String get completeStageSubtitle => 'Ολοκληρώθηκε!';

  @override
  String get completeStageStatisticsHeader => 'Στατιστικά Σταδίου';

  @override
  String get completeStageDifficulty => 'Δυσκολία σταδίου';

  @override
  String get completeStageTimeSpent => 'Χρόνος επίλυσης';

  @override
  String get completeStageCrosswordWords => 'Λέξεις σταυρολέξου';

  @override
  String get completeStageExtraWords => 'Έξτρα λέξεις';

  @override
  String get completeStageRewardsHeader => 'Επιβραβεύσεις Σταδίου';

  @override
  String get completeStageCompletionPoints => 'Ολοκλήρωση σταδίου';

  @override
  String get completeStageWordsPoints => 'Λέξεις Σταδίου';

  @override
  String get completeStageExtraWordsPoints => 'Έξτρα λέξεις';

  @override
  String get completeStageTotalPoints => 'Σύνολο';

  @override
  String get completeStageBackToHomeBtn => 'Πίσω στην αρχική';

  @override
  String completeTotalPoints(int totalPoints) {
    return 'Σύνολο: + $totalPoints';
  }
}
