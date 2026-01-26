import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/language_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _langKey = AppKeys.languageCodeKey;

  LanguageCubit() : super(const LanguageState(AppLanguage.greek));

  Future<void> loadSelectedLang() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? langCode = prefs.getString(_langKey);

      if (langCode != null) {
        emit(state.copyWith(appLanguage: AppLanguage.fromCode(langCode)));
      } else {
        String deviceLocaleCode = LanguageService.getDeviceLanguage();

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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langKey, langCode);
      emit(
        state.copyWith(
          appLanguage: AppLanguage.fromCode(langCode),
          isLoading: false,
        ),
      );
    } catch (e) {
      debugPrint("${AppStrings.devLanguageSaveError}: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> setNewLanguage(String langCode) async {
    emit(state.copyWith(isLoading: true));
    final dictionaryService = getIt<DictionaryService>();
    final userProfileService = getIt<UserProfileService>();

    await dictionaryService.loadDictionaryJson(langCode: langCode);
    await userProfileService.onLanguageChanged(AppLanguage.fromCode(langCode));
    await _saveLanguage(langCode);
  }
}
