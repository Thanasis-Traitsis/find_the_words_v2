import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingXL),
      padding: const EdgeInsets.all(AppSpacing.spacingL),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: AppBorders.regularBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.darkBlue,
        ),
      ),
      child: Row(
        spacing: AppSpacing.spacingL,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSvgIcon(
            icon: 'info',
            color: context.colors.darkBlue,
            height: AppSizes.buttonIconSize,
          ),
          Expanded(
            child: CustomText(
              context.translate.languageBottomsheetDescription,
              textType: CustomTextType.regularBody,
            ),
          ),
        ],
      ),
    );
  }
}
