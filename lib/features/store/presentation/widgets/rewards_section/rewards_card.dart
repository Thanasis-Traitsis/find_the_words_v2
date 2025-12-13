import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/screen_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class RewardsCard extends StatelessWidget {
  final String smallTitle;
  final String bigTitle;
  final String description;
  final VoidCallback onTap;
  final CustomIcons rewardIcon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const RewardsCard({
    super.key,
    required this.smallTitle,
    required this.bigTitle,
    required this.description,
    required this.onTap,
    required this.rewardIcon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppBorders.regularBorderRadius,
        border: Border.all(
          width: AppBorders.mediumBorderWidth,
          color: context.colors.black,
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacingL),
            decoration: BoxDecoration(
              borderRadius: AppBorders.regularBorderRadius,
            ),
            child: Column(
              spacing: AppSpacing.spacingL,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: AppSpacing.spacingM,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            smallTitle,
                            textStyle: TextStyle(
                              fontSize: CustomTextType.regularBody.fontSize,
                              fontWeight: CustomTextType.smallHeading.fontWeight,
                              color: textColor,
                              height: 1,
                            ),
                          ),
                          CustomText(
                            bigTitle,
                            textStyle: TextStyle(
                              fontSize: CustomTextType.bigHeading.fontSize,
                              fontWeight: CustomTextType.bigHeading.fontWeight,
                              color: textColor,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomSvgIcon(
                      icon: CustomIcons.arrowRight,
                      color: context.colors.black,
                      height: AppSizes.iconM,
                    ),
                  ],
                ),
                SizedBox(
                  width: context.screenWidth * 0.5,
                  child: CustomText(
                    description,
                    textType: CustomTextType.regularBody,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -AppSpacing.spacingM,
            bottom: -AppSpacing.spacingM,
            child: Opacity(
              opacity: 0.4,
              child: CustomSvgIcon(
                icon: rewardIcon,
                color: iconColor,
                height: AppSizes.rewardIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
