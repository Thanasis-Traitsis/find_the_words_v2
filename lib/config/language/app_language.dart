import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_language.g.dart';

@HiveType(typeId: 2)
enum AppLanguage {
  @HiveField(0)
  greek('el', 'Ελληνικά', 'gr-flag.png'),

  @HiveField(1)
  english('en', 'English', 'en-flag.png');

  final String code;
  final String displayName;
  final String flag;

  const AppLanguage(this.code, this.displayName, this.flag);

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }

  static AppLanguage fromLocale(Locale locale) {
    return fromCode(locale.languageCode);
  }

  static List<Locale> get langLocales => [
    AppLanguage.greek.locale,
    AppLanguage.english.locale,
  ];
}
