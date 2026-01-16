import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter/material.dart';

enum CustomTextType {
  bigHeading,
  regularHeading,
  smallHeading,
  bigBody,
  regularBody,
  smallBody,
  smallTag,
}

extension CustomFontSize on CustomTextType {
  double get fontSize => switch (this) {
    CustomTextType.bigHeading => AppTextSizes.textSizeXL,
    CustomTextType.regularHeading => AppTextSizes.textSizeL,
    CustomTextType.smallHeading ||
    CustomTextType.bigBody => AppTextSizes.textSizeM,
    CustomTextType.regularBody => AppTextSizes.textSizeS,
    CustomTextType.smallBody ||
    CustomTextType.smallTag => AppTextSizes.textSizeXS,
  };
}

extension CustomFontWeight on CustomTextType {
  FontWeight get fontWeight => switch (this) {
    CustomTextType.bigHeading ||
    CustomTextType.regularHeading ||
    CustomTextType.smallHeading ||
    CustomTextType.smallTag => FontWeight.bold,
    CustomTextType.bigBody ||
    CustomTextType.regularBody ||
    CustomTextType.smallBody => FontWeight.normal,
  };
}

extension CustomFontFamily on CustomTextType {
  String get fontFamily => switch (this) {
    CustomTextType.bigHeading ||
    CustomTextType.regularHeading ||
    CustomTextType.smallHeading ||
    CustomTextType.smallTag => AppTheme.highlighFont,
    CustomTextType.bigBody ||
    CustomTextType.regularBody ||
    CustomTextType.smallBody => AppTheme.appFont,
  };
}

extension CustomTextStyle on CustomTextType {
  TextStyle getTextStyle(BuildContext context, bool isWhite, bool isItalic) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: isItalic ? FontStyle.italic : null,
      color: isWhite ? appColors.white : appColors.text,
      height: 1,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
