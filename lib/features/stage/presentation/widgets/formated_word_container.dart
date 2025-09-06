import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FormatedWordContainer extends StatelessWidget {
  final StringBuffer word;

  const FormatedWordContainer({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: word.isNotEmpty ? 1 : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingM,
          vertical: AppSpacing.spacingS,
        ),
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: AppBorders.regularBorderRadius,
          border: Border.all(
            width: AppBorders.smallBorderWidth,
            color: context.colors.darkBlue,
          ),
        ),
        child: CustomText(
          word.toString(),
          textStyle: TextStyle(
            fontSize: CustomTextType.smallHeading.fontSize,
            fontWeight: CustomTextType.smallHeading.fontWeight,
            color: context.colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
