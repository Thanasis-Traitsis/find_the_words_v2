import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.minimal)
class DictionaryService {
  Map<String, dynamic> cachedDictionary = {};

  Future<void> loadDictionaryJson({String? langCode}) async {
    final currentLang =
        langCode ?? getIt<LanguageCubit>().state.appLanguage.code;

    final dictionaryPath = FileUtils.dictionaryFile('dictionary', currentLang);
    cachedDictionary = await FileUtils.loadCompressedJson(dictionaryPath);
  }

  void setCachedDictionary(Map<String, dynamic> dictionary) {
    cachedDictionary = dictionary;
  }
}
