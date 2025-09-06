import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
