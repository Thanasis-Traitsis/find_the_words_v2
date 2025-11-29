import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousStageWordsService {
  final String _prevWordsKey = AppKeys.previousStageWordsKey;
  final _prefs = getIt<SharedPreferences>();

  Future<void> savePrevStageWords(List<String> words) async {
     await _prefs.setStringList(_prevWordsKey, words);
  }

  Future<List<String>> getPrevStageWords() async {
    return _prefs.getStringList(_prevWordsKey,) ?? [];
  }
}
