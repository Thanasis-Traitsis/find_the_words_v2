import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String infoText;
  final double iconSize;
  final double infoSpacing;

  const InfoContainer.small({
    super.key,
    required this.infoText,
    this.iconSize = AppSizes.iconS,
    this.infoSpacing = AppSpacing.spacingM,
  });
  const InfoContainer.regular({
    super.key,
    required this.infoText,
    this.iconSize = AppSizes.iconM,
    this.infoSpacing = AppSpacing.spacingL,
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
            icon: CustomIcons.info,
            color: context.colors.darkBlue,
            height: iconSize,
          ),
          Expanded(
            child: CustomText(infoText, textType: CustomTextType.regularBody),
          ),
        ],
      ),
    );
  }
}
