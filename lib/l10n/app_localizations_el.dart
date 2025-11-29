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
  String get settingsEmailSubjectReportBug => 'Μόλις βρήκα ένα σφάλμα';

  @override
  String get settingsEmailSubjectBadWord => 'Αναφορά κακής λέξης';

  @override
  String get settingsEmailSubjectContact => 'Σχόλια για το παιχνίδι';

  @override
  String get settingsResetStageBottomsheetDescription => 'Δυσκολεύεσαι να λύσεις το στάδιο; Ή μήπως κάτι πήγε στραβά και το σταυρόλεξο δεν εμφανίστηκε σωστά; Μπορείς να επαναφέρεις το στάδιο και να δοκιμάσεις ξανά.';

  @override
  String get settingsResetStageBottomsheetRestartButton => 'Επανεκκίνηση';

  @override
  String get settingsResetStageDialogHeader => 'Προσοχή!';

  @override
  String get settingsResetStageDialogDescription => 'Είσαι σίγουρος ότι θέλεις να διαγράψεις το τρέχον στάδιο; Αν συνεχίσεις, όλη η πρόοδος που έχεις κάνει θα χαθεί και ένα νέο στάδιο θα ξεκινήσει ξανά από την αρχή';

  @override
  String get settingsResetStageDialogButtonCancel => 'Κλείσιμο';

  @override
  String get settingsResetStageDialogButtonSubmit => 'Υποβολή';

  @override
  String get settingsBadWordBottomsheetDescription => 'Συνάντησες μια λέξη που θεωρείς ακατάλληλη; Αν εντόπισες κάποια προσβλητική ή ακατάλληλη λέξη, μπορείς να την αναφέρεις. Επίλεξε μία από τις λέξεις του προηγούμενου σταδίου ή πληκτρολόγησε τη λέξη που θεωρείς ότι πρέπει να αφαιρεθεί.';

  @override
  String get settingsBadWordBottomsheetSectionTitleStageWords => 'Λέξεις από το προηγόυμενο στάδιο';

  @override
  String get settingsBadWordBottomsheetSectionTitleSelectedWord => 'Γράψε τη λέξη που θα ήθελες να αφαιρεθεί';

  @override
  String get settingsBadWordBottomsheetTextfieldHint => 'Γράψε τη λέξη εδώ';

  @override
  String get settingsBadWordBottomsheetButtonClear => 'Καθαρισμός';

  @override
  String get settingsBadWordBottomsheetButtonSubmit => 'Υποβολή';

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
  String get sortByAlphabeticalAZ => 'Αλφαβητική σειρά Α-Ω';

  @override
  String get sortByAlphabeticalZA => 'Αλφαβητική σειρά Ω-Α';

  @override
  String get sortBySmallestToBiggest => 'Από μικρ. στο μεγ.';

  @override
  String get sortByBiggestToSmallest => 'Από μεγ. στο μικρ.';

  @override
  String get sortByNewestToOldest => 'Πιο πρόσφατα';

  @override
  String get sortByOldestToNewest => 'Πιο παλιά';

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
  String get completeStageWordsPoints => 'Λέξεις σταδίου';

  @override
  String get completeStageExtraWordsPoints => 'Έξτρα λέξεις';

  @override
  String get completeStageLevelUp => 'Ολοκλήρωση επιπέδου';

  @override
  String get completeStageTotalPoints => 'Σύνολο';

  @override
  String get completeStageBackToHomeBtn => 'Πίσω στην αρχική';

  @override
  String completeTotalPoints(int totalPoints) {
    return 'Σύνολο: + $totalPoints';
  }

  @override
  String get gameRulesTitle1 => 'Πώς να παίξεις';

  @override
  String get gameRulesContent1 => 'Ο στόχος σου είναι απλός. Bρες όλες τις κρυμμένες λέξεις σε κάθε σταυρόλεξο.';

  @override
  String get gameRulesTitle2 => 'Κανόνες Παιχνιδιού';

  @override
  String get gameRulesContent2a => 'Σύνδεσε γράμματα για να σχηματίσεις έγκυρες λέξεις.';

  @override
  String get gameRulesContent2b => 'Κάθε στάδιο δημιουργείται δυναμικά, οπότε κανένα παζλ δεν είναι το ίδιο!';

  @override
  String get gameRulesContent2c => 'Ο αριθμός του επιπέδου καθορίζει το μέγεθος του παζλ:';

  @override
  String get gameRulesSubcontent2a => 'Επίπεδο 1 → η μεγαλύτερη λέξη έχει 3 γράμματα';

  @override
  String get gameRulesSubcontent2b => 'Επίπεδο 2 → η μεγαλύτερη λέξη έχει 4 γράμματα';

  @override
  String get gameRulesSubcontent2c => 'Επίπεδο 3 → η μεγαλύτερη λέξη έχει 5 γράμματα, και ούτω καθεξής';

  @override
  String get gameRulesTitle3 => 'Συμβουλές';

  @override
  String get gameRulesContent3a => 'Δοκίμασε διαφορετικούς συνδυασμούς γραμμάτων, μπορεί να ανακαλύψεις bonus λέξεις!';

  @override
  String get gameRulesContent3b => 'Κόλλησες; Χρησιμοποίησε τις διαθέσιμες βοήθειες για να αποκαλύψεις γράμματα ή λέξεις.';

  @override
  String get gameRulesContent3c => 'Όσο περισσότερο παίζεις, τόσο βελτιώνεις το λεξιλόγιο και την ικανότητα εύρεσης λέξεων!';

  @override
  String get gameRulesTitle4 => 'Ατελείωτη Διασκέδαση';

  @override
  String get gameRulesContent4 => 'Δεν υπάρχει προκαθορισμένη πορεία. Κάθε παζλ είναι μοναδικό, προσφέροντας ατελείωτες προκλήσεις λέξεων και μια φρέσκια εμπειρία κάθε φορά που παίζεις.';

  @override
  String get gameRulesTitle5 => 'Απόλαυσε την περιπέτεια λέξεων στο Βρες τις Λέξεις!';

  @override
  String get filterInfoText => 'Η επιλογή όλων των γραμμάτων γίνεται αυτόματα, εφόσον δεν έχουν επιλεγεί συγκεκριμένα γράμματα.';

  @override
  String get totalWordsEmptyResult => 'Δε βρέθηκε καμία λέξη.';

  @override
  String get filtersHeaderTitle => 'Φίλτρα';

  @override
  String get filtersSectionHeaderAllLetters => 'Όλα τα γράμματα';

  @override
  String get filtersSectionContentShowAllLetters => 'Εμφάνισε τις λέξεις από όλα τα γράμματα';

  @override
  String get filtersSectionHeaderSelectedLetters => 'Επιλογή γραμμάτων';

  @override
  String get filtersSectionButtonClearLetters => 'Καθαρισμός γραμμάτων';

  @override
  String get filtersSectionHeaderWordLength => 'Μέγεθος λέξεων';

  @override
  String filtersSectionContentWordLength(int minLength, int maxLength) {
    return 'Επιλεγμένο μέγεθος λέξεων: $minLength - $maxLength';
  }

  @override
  String get filtersButtonApply => 'Εφαρμογή φίλτρων';

  @override
  String get filtersButtonClean => 'Καθαρισμός';

  @override
  String get chipAllLetters => 'Όλα τα γράμματα';

  @override
  String chipSelectedLetters(String letters) {
    return 'Επιλεγμένα γράμματα: $letters';
  }

  @override
  String chipSelectedRangeOfWordLength(int minWordLength, int maxWordLength) {
    return 'Μέγεθος λέξεων: $minWordLength - $maxWordLength';
  }
}
