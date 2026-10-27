import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
@Environment(Env.minimal)
class ChangeLanguageUsecase {
  final DictionaryService _dictionaryService;
  final UserProfileService _userProfileService;

  ChangeLanguageUsecase(this._dictionaryService, this._userProfileService);

  Future<void> call(String langCode) async {
    final dictionaryPath = FileUtils.dictionaryFile('dictionary', langCode);
    final ByteData compressedData = await rootBundle.load(
      'assets/$dictionaryPath.gz',
    );
    final List<int> compressedBytes = compressedData.buffer.asUint8List();

    final dictionaryData = await compute(
      _decompressAndParseJson,
      compressedBytes,
    );

    _dictionaryService.setCachedDictionary(dictionaryData);

    await _userProfileService.onLanguageChanged(AppLanguage.fromCode(langCode));
  }
}

Map<String, dynamic> _decompressAndParseJson(List<int> compressedBytes) {
  final List<int> decompressed = GZipDecoder().decodeBytes(compressedBytes);
  final String jsonString = utf8.decode(decompressed);
  return json.decode(jsonString);
}
