import 'package:find_the_words/core/utils/file_utils.dart';

class DictionaryService {
  Map<String, dynamic> cachedDictionary = {};

  Future<void> loadDictionaryJson() async {
    final dictionaryPath = FileUtils.dictionaryFile('dictionary');
    cachedDictionary = await FileUtils.loadCompressedJson(dictionaryPath);
  }
}
