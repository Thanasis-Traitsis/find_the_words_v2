import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GetRewardCard extends StatelessWidget {
  const GetRewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: AppBorders.smallBorderWidth,
            color: context.colors.darkPink,
          ),
          borderRadius: AppBorders.bigBorderRadius,
          color: context.colors.secondary,
        ),
        margin: const EdgeInsets.only(top: AppSpacing.spacingL),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.spacingM,
          horizontal: AppSpacing.spacingL,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacingM,
          children: [
            CustomSvgIcon(
              icon: CustomIcons.gift,
              color: context.colors.white,
              height: AppSizes.iconS,
            ),
            Row(
              spacing: AppSpacing.spacingM,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  '+ 20',
                  textType: CustomTextType.smallHeading,
                  isWhite: true,
                ),
                CustomSvgIcon(
                  icon: CustomIcons.star,
                  color: context.colors.white,
                  height: AppSizes.iconXS,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
