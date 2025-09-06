import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const String appFont = 'Roboto Condensed';
  final AppColors chosenColor;

  AppTheme(this.chosenColor);

  ThemeData getTheme() {
    return ThemeData(
      fontFamily: appFont,
      useMaterial3: true,
      scaffoldBackgroundColor: chosenColor.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: chosenColor.primary,
        primary: chosenColor.primary,
        onPrimary: chosenColor.white,
        surface: chosenColor.background,
        onSurface: chosenColor.text,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: chosenColor.background,
        titleTextStyle: TextStyle(
          color: chosenColor.text,
          // fontSize: AppTextSizes.textSizeL,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: IconThemeData(color: chosenColor.white),
      ),
      extensions: <ThemeExtension<dynamic>>[chosenColor],
    );
  }
}
