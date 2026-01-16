import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

enum SnackbarTheme { success, warning, error }

extension SnackbarThemeColors on SnackbarTheme {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case SnackbarTheme.success:
        return context.colors.lightGreen;
      case SnackbarTheme.warning:
        return context.colors.lightOrange;
      case SnackbarTheme.error:
        return context.colors.lightPink;
    }
  }

  Color contentColor(BuildContext context) {
    switch (this) {
      case SnackbarTheme.success:
        return context.colors.darkGreen;
      case SnackbarTheme.warning:
        return context.colors.orange;
      case SnackbarTheme.error:
        return context.colors.error;
    }
  }

  CustomIcons icon() {
    switch (this) {
      case SnackbarTheme.success:
        return CustomIcons.check;
      case SnackbarTheme.warning:
        return CustomIcons.warning;
      case SnackbarTheme.error:
        return CustomIcons.error;
    }
  }
}
