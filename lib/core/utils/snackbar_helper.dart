import 'package:find_the_words/config/theme/snackbar_theme.dart';
import 'package:find_the_words/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSuccessSnackbar(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    showCustomSnackbar(context, title, message, SnackbarTheme.success);
  }

  static void showWarningSnackbar(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    showCustomSnackbar(context, title, message, SnackbarTheme.warning);
  }

  static void showErrorSnackbar(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    showCustomSnackbar(context, title, message, SnackbarTheme.error);
  }
}
