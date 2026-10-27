import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
@Environment(Env.full)
class PreviousStageWordsService {
  final _prefs = getIt<SharedPreferences>();

  Future<void> savePrevStageWords(List<String> words) async {
    final selectedLang = getIt<LanguageCubit>().state.appLanguage;
    final prevStageWordKey = AppKeys.previousStageWordsKey(selectedLang.code);

    await _prefs.setStringList(prevStageWordKey, words);
  }

  Future<List<String>> getPrevStageWords() async {
    final selectedLang = getIt<LanguageCubit>().state.appLanguage;
    final prevStageWordKey = AppKeys.previousStageWordsKey(selectedLang.code);
    
    return _prefs.getStringList(prevStageWordKey) ?? [];
  }
}
