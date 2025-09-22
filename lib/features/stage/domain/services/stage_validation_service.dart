import 'package:find_the_words/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StageValidationService {
  static final StageValidationService _instance =
      StageValidationService._internal();
  StageValidationService._internal();
  static StageValidationService get instance => _instance;

  Future<List<String>> getWordsWithoutPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppKeys.failedWords) ?? [];
  }

  void removeWordFromFailedList(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final failedWords = prefs.getStringList(AppKeys.failedWords) ?? [];
    failedWords.removeWhere((failedWord) => failedWord == word);

    prefs.setStringList(AppKeys.failedWords, failedWords);
  }

  void wordUnableToFit(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final failedWords = prefs.getStringList(AppKeys.failedWords) ?? [];

    if (!failedWords.contains(word)) failedWords.add(word);

    prefs.setStringList(AppKeys.failedWords, failedWords);
  }

  void clearFailedWords() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppKeys.failedWords);
  }
}
