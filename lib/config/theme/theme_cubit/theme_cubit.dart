import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/constants/app_strings.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

@lazySingleton
@Environment(Env.minimal)
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = AppKeys.themeModeKey;

  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState());

  Future<void> loadTheme() async {
    try {
      final String? themeMode = _prefs.getString(_themeKey);

      if (themeMode != null) {
        emit(state.copyWith(themeMode: ThemeMode.values.byName(themeMode)));
      }
    } catch (e) {
      debugPrint("${AppStrings.devThemeLoadError}: $e");
    }
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      await _prefs.setString(_themeKey, themeMode.name);
    } catch (e) {
      debugPrint("${AppStrings.devThemeSaveError}: $e");
    }
  }

  Future<void> setLightTheme() async {
    emit(state.copyWith(themeMode: ThemeMode.light));
    await _saveTheme(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    emit(state.copyWith(themeMode: ThemeMode.dark));
    await _saveTheme(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    emit(state.copyWith(themeMode: ThemeMode.system));
    await _saveTheme(ThemeMode.system);
  }
}
