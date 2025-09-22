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
  String get languageBottomsheetDescription =>
      'Η πρόοδός σας αποθηκεύεται ξεχωριστά για κάθε γλώσσα. Τα επίπεδα και τα ολοκληρωμένα στάδια παρακολουθούνται ανεξάρτητα, επιτρέποντάς σας να μαθαίνετε με το δικό σας ρυθμό σε πολλές γλώσσες.';

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
}
