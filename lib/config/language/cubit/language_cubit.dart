import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/language_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _langKey = AppKeys.languageCodeKey;

  LanguageCubit() : super(const LanguageState(AppLanguage.greek));

  Future<void> loadSelectedLang() async {
    try {
      final prefs = getIt<SharedPreferences>();
      final String? langCode = prefs.getString(_langKey);

      if (langCode != null) {
        emit(state.copyWith(appLanguage: AppLanguage.fromCode(langCode)));
      } else {
        String deviceLocaleCode = LanguageService.getDeviceLanguage();
        await prefs.setString(_langKey, deviceLocaleCode);

        emit(
          state.copyWith(
            appLanguage: AppLanguage.fromCode(deviceLocaleCode),
            isFirstTime: true,
          ),
        );
      }
    } catch (e) {
      debugPrint("${AppStrings.devLanguageLoadError}: $e");
    }
  }

  Future<void> _saveLanguage(String langCode) async {
    try {
      final prefs = getIt<SharedPreferences>();
      await prefs.setString(_langKey, langCode);
      emit(state.copyWith(appLanguage: AppLanguage.fromCode(langCode)));
    } catch (e) {
      debugPrint("${AppStrings.devLanguageSaveError}: $e");
    }
  }

  Future<void> setNewLanguage(String langCode) async {
    try {
      final dictionaryService = getIt<DictionaryService>();
      final userProfileService = getIt<UserProfileService>();

      final dictionaryPath = FileUtils.dictionaryFile('dictionary', langCode);
      final ByteData compressedData = await rootBundle.load(
        'assets/$dictionaryPath.gz',
      );
      final List<int> compressedBytes = compressedData.buffer.asUint8List();

      final dictionaryData = await compute(
        _decompressAndParseJson,
        compressedBytes,
      );

      dictionaryService.setCachedDictionary(dictionaryData);

      await userProfileService.onLanguageChanged(
        AppLanguage.fromCode(langCode),
      );
      await _saveLanguage(langCode);
    } catch (e) {
      rethrow;
    }
  }
}

Map<String, dynamic> _decompressAndParseJson(List<int> compressedBytes) {
  final List<int> decompressed = GZipDecoder().decodeBytes(compressedBytes);
  final String jsonString = utf8.decode(decompressed);
  return json.decode(jsonString);
}
