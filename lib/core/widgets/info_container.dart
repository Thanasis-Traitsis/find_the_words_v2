import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/string_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String? titleText;
  final String infoText;
  final double iconSize;
  final double infoSpacing;
  final CustomIcons icon;

  const InfoContainer.small({
    super.key,
    this.titleText,
    required this.infoText,
    this.iconSize = AppSizes.iconS,
    this.infoSpacing = AppSpacing.spacingM,
    this.icon = CustomIcons.info,
  });
  const InfoContainer.regular({
    super.key,
    this.titleText,
    required this.infoText,
    this.iconSize = AppSizes.iconM,
    this.infoSpacing = AppSpacing.spacingL,
    this.icon = CustomIcons.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingS),
      padding: EdgeInsets.all(infoSpacing),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: AppBorders.regularBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.darkBlue,
        ),
      ),
      child: Row(
        spacing: infoSpacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSvgIcon(
            icon: icon,
            color: context.colors.darkBlue,
            height: iconSize,
          ),
          Expanded(
            child: Column(
              spacing: AppSpacing.spacingS,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleText != null) 
                  CustomText(titleText!.toUpperCaseGreek(), textType: CustomTextType.smallHeading),
                CustomText(infoText, textType: CustomTextType.regularBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
