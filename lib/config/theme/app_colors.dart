import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color white;
  final Color black;
  final Color background;
  final Color darkBackground;
  final Color primary;
  final Color secondary;
  final Color lightGreen;
  final Color darkGreen;
  final Color lightBlue;
  final Color darkBlue;
  final Color lightPink;
  final Color darkPink;
  final Color stageBlue;
  final Color text;
  final Color error;

  AppColors({
    required this.white,
    required this.black,
    required this.background,
    required this.darkBackground,
    required this.primary,
    required this.secondary,
    required this.lightGreen,
    required this.darkGreen,
    required this.lightBlue,
    required this.darkBlue,
    required this.lightPink,
    required this.darkPink,
    required this.stageBlue,
    required this.text,
    required this.error,
  });

  static final mainColors = AppColors(
    white: const Color(0xffFFFFFF),
    black: const Color(0xff000000),
    background: const Color(0xffFFF8F0),
    darkBackground: const Color(0xffF7BA9D),
    primary: const Color(0xff306897),
    secondary: const Color(0xffF17F7E),
    lightGreen: const Color(0xffB4F1C1),
    darkGreen: const Color(0xff0A3226),
    lightBlue: const Color(0xffDEECFF),
    darkBlue: const Color(0xff1C2541),
    lightPink: const Color(0xffFADDDC),
    darkPink: const Color(0xff9F4645),
    stageBlue: const Color(0xff8CA4C4),
    text: const Color(0xff000000),
    error: const Color(0xff9c1a1a),
  );

  static final darkColors = AppColors(
    white: const Color(0xff1a1a1a),
    black: const Color(0xffFFFFFF),
    background: const Color(0xff121212),
    darkBackground: const Color(0xff42342B),
    primary: const Color(0xff5A9BD5),
    secondary: const Color(0xffF49A99),
    lightGreen: const Color(0xff2F5237),
    darkGreen: const Color(0xffB4F1C1),
    lightBlue: const Color(0xff2C3A5A),
    darkBlue: const Color(0xffDEECFF),
    lightPink: const Color(0xff5A3A3A),
    darkPink: const Color(0xffFADDDC),
    stageBlue: const Color(0xffA8C4E4),
    text: const Color(0xffE0E0E0),
    error: const Color(0xffFF5252),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? white,
    Color? black,
    Color? background,
    Color? darkBackground,
    Color? primary,
    Color? secondary,
    Color? lightGreen,
    Color? darkGreen,
    Color? lightBlue,
    Color? darkBlue,
    Color? lightPink,
    Color? darkPink,
    Color? stageBlue,
    Color? text,
    Color? error,
  }) {
    return AppColors(
      white: white ?? this.white,
      black: black ?? this.black,
      background: background ?? this.background,
      text: text ?? this.text,
      error: error ?? this.error,
      darkBackground: darkBackground ?? this.darkBackground,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      lightGreen: lightGreen ?? this.lightGreen,
      darkGreen: darkGreen ?? this.darkGreen,
      lightBlue: lightBlue ?? this.lightBlue,
      darkBlue: darkBlue ?? this.darkBlue,
      lightPink: lightPink ?? this.lightPink,
      darkPink: darkPink ?? this.darkPink,
      stageBlue: stageBlue ?? this.stageBlue,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      background: Color.lerp(background, other.background, t)!,
      text: Color.lerp(text, other.text, t)!,
      error: Color.lerp(error, other.error, t)!,
      darkBackground: Color.lerp(darkBackground, other.darkBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      lightGreen: Color.lerp(lightGreen, other.lightGreen, t)!,
      darkGreen: Color.lerp(darkGreen, other.darkGreen, t)!,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t)!,
      darkBlue: Color.lerp(darkBlue, other.darkBlue, t)!,
      lightPink: Color.lerp(lightPink, other.lightPink, t)!,
      darkPink: Color.lerp(darkPink, other.darkPink, t)!,
      stageBlue: Color.lerp(stageBlue, other.stageBlue, t)!,
    );
  }
}
