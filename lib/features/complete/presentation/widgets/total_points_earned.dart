import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TotalPointsEarned extends StatelessWidget {
  final int points;
  const TotalPointsEarned({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.spacingS,
          horizontal: AppSpacing.spacingL,
        ),
        decoration: BoxDecoration(
          color: context.colors.lightPink,
          borderRadius: AppBorders.hugeBorderRadius,
          border: Border.all(
            width: AppBorders.smallBorderWidth,
            color: context.colors.darkPink,
          ),
        ),
        child: Row(
          spacing: AppSpacing.spacingM,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              context.translate.completeTotalPoints(points),
              textStyle: TextStyle(
                fontSize: CustomTextType.smallHeading.fontSize,
                fontWeight: CustomTextType.smallHeading.fontWeight,
                color: context.colors.darkPink,
              ),
            ),
            CustomSvgIcon(
              icon: CustomIcons.star,
              color: context.colors.secondary,
              height: AppSizes.iconS,
            ),
          ],
        ),
      ),
    );
  }
}
