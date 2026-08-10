import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.system});

  @override
  List<Object?> get props => [themeMode];
}

/// Loads the saved theme mode, defaulting to ThemeMode.system if nothing
/// has been saved yet. SharedPreferences is passed in directly - no
/// service locator involved.
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState());

  Future<void> load() async {
    final String? saved = _prefs.getString(AppKeys.themeModeKey);
    if (saved == null) return;

    emit(ThemeState(themeMode: ThemeMode.values.byName(saved)));
  }
}
