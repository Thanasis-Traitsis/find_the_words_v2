import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HelpListItem extends StatelessWidget {
  final int points;
  final String icon;
  final String helpTitle;
  final String helpDescription;

  const HelpListItem({
    super.key,
    required this.points,
    required this.icon,
    required this.helpTitle,
    required this.helpDescription,
  });

  const HelpListItem.free({
    super.key,
    required this.icon,
    required this.helpTitle,
    required this.helpDescription,
  }) : points = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.spacingL),
      child: Column(
        spacing: AppSpacing.spacingM,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingM,
              vertical: AppSpacing.spacingS,
            ),
            decoration: BoxDecoration(
              color: context.colors.lightPink,
              border: Border.all(
                width: AppBorders.smallBorderWidth,
                color: context.colors.secondary,
              ),
              borderRadius: AppBorders.hugeBorderRadius,
            ),
            child: points > 0
                ? Row(
                    spacing: AppSpacing.spacingM,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        '- $points',
                        textStyle: TextStyle(
                          fontSize: CustomTextType.regularBody.fontSize,
                          fontWeight: CustomTextType.smallHeading.fontWeight,
                          color: context.colors.darkPink,
                        ),
                      ),
                      CustomSvgIcon(
                        icon: 'star',
                        color: context.colors.darkPink,
                        height: AppSizes.rewardStarIconSize,
                      ),
                    ],
                  )
                : CustomText(
                    context.translate.free,
                    textStyle: TextStyle(
                      fontSize: CustomTextType.regularBody.fontSize,
                      fontWeight: CustomTextType.smallHeading.fontWeight,
                      color: context.colors.darkPink,
                    ),
                  ),
          ),
          Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomSvgIcon(icon: icon, color: context.colors.text),
              Expanded(
                child: CustomText(
                  helpTitle,
                  textType: CustomTextType.smallHeading,
                ),
              ),
            ],
          ),
          CustomText(helpDescription, textType: CustomTextType.regularBody),
        ],
      ),
    );
  }
}
