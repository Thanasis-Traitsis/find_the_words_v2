import 'package:flutter/material.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/config/theme/snackbar_theme.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar._({
    super.key,
    required BuildContext context,
    required String contentText,
    required SnackbarTheme theme,
  }) : super(
         duration: const Duration(seconds: 2),
         behavior: SnackBarBehavior.floating,
         margin: const EdgeInsets.all(AppSpacing.screenPadding),
         backgroundColor: theme.backgroundColor(context),
         shape: RoundedRectangleBorder(
           side: BorderSide(
             color: theme.contentColor(context),
             width: AppBorders.mediumBorderWidth,
           ),
           borderRadius: AppBorders.regularBorderRadius,
         ),
         content: Row(
           spacing: AppSpacing.spacingM,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             CustomSvgIcon(
               icon: theme.icon(),
               color: theme.contentColor(context),
             ),
             CustomText(
               contentText,
               textStyle: TextStyle(
                 fontSize: CustomTextType.regularBody.fontSize,
                 fontWeight: CustomTextType.regularBody.fontWeight,
                 color: theme.contentColor(context),
               ),
             ),
           ],
         ),
       );

  /// Success Snackbar
  factory CustomSnackbar.success({
    Key? key,
    required BuildContext context,
    required String contentText,
  }) {
    return CustomSnackbar._(
      key: key,
      context: context,
      contentText: contentText,
      theme: SnackbarTheme.success,
    );
  }

  /// Warning Snackbar
  factory CustomSnackbar.warning({
    Key? key,
    required BuildContext context,
    required String contentText,
  }) {
    return CustomSnackbar._(
      key: key,
      context: context,
      contentText: contentText,
      theme: SnackbarTheme.warning,
    );
  }

  /// Error Snackbar
  factory CustomSnackbar.error({
    Key? key,
    required BuildContext context,
    required String contentText,
  }) {
    return CustomSnackbar._(
      key: key,
      context: context,
      contentText: contentText,
      theme: SnackbarTheme.error,
    );
  }
}
