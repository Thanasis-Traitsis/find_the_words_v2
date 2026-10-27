import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/domain/usecases/change_language_usecase.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/language_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

@lazySingleton
@Environment(Env.minimal)
class LanguageCubit extends Cubit<LanguageState> {
  static const String _langKey = AppKeys.languageCodeKey;

  final SharedPreferences _prefs;
  ChangeLanguageUsecase get _changeLanguage => getIt<ChangeLanguageUsecase>();

  LanguageCubit(this._prefs) : super(const LanguageState(AppLanguage.greek));

  Future<void> loadSelectedLang() async {
    try {
      final String? langCode = _prefs.getString(_langKey);

      if (langCode != null) {
        emit(state.copyWith(appLanguage: AppLanguage.fromCode(langCode)));
      } else {
        String deviceLocaleCode = LanguageService.getDeviceLanguage();
        await _prefs.setString(_langKey, deviceLocaleCode);

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

  void triggerInitialLanguageSelection() {
    emit(LanguageState(state.appLanguage, isFirstTime: false));
  }

  Future<void> _saveLanguage(String langCode) async {
    try {
      await _prefs.setString(_langKey, langCode);
      emit(state.copyWith(appLanguage: AppLanguage.fromCode(langCode)));
    } catch (e) {
      debugPrint("${AppStrings.devLanguageSaveError}: $e");
    }
  }

  Future<void> setNewLanguage(String langCode) async {
    await _changeLanguage(langCode);
    await _saveLanguage(langCode);
  }
}
