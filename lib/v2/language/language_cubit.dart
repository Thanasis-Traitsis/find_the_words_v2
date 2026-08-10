import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/services/language_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState extends Equatable {
  final AppLanguage appLanguage;
  final bool isFirstTime;

  const LanguageState(this.appLanguage, {this.isFirstTime = false});

  @override
  List<Object?> get props => [appLanguage, isFirstTime];
}

/// Loads the saved language, or falls back to the device locale and
/// persists it (marking isFirstTime so the UI can offer a confirmation
/// screen later). SharedPreferences is passed in directly - no service
/// locator involved.
class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences _prefs;

  LanguageCubit(this._prefs) : super(const LanguageState(AppLanguage.greek));

  Future<void> load() async {
    final String? savedCode = _prefs.getString(AppKeys.languageCodeKey);

    if (savedCode != null) {
      emit(LanguageState(AppLanguage.fromCode(savedCode)));
      return;
    }

    final String deviceCode = LanguageService.getDeviceLanguage();
    await _prefs.setString(AppKeys.languageCodeKey, deviceCode);
    emit(LanguageState(AppLanguage.fromCode(deviceCode), isFirstTime: true));
  }
}
