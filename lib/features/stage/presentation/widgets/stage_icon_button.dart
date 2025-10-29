import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageIconButton extends StatelessWidget {
  final String icon;
  final String? text;
  final int? points;
  final VoidCallback onTap;

  const StageIconButton({
    super.key,
    required this.icon,
    this.text,
    required this.onTap,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: context.colors.stageBlue.withValues(alpha: 0.4),
        borderRadius: AppBorders.regularBorderRadius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.iconButtonPadding),
          decoration: BoxDecoration(
            borderRadius: AppBorders.regularBorderRadius,
            border: Border.all(
              width: AppBorders.mediumBorderWidth,
              color: context.colors.black,
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingM,
            children: [
              CustomSvgIcon(
                icon: icon,
                color: context.colors.black,
                height: AppSizes.iconS,
              ),
              if (text != null)
                CustomText(text!, textType: CustomTextType.regularBody),
              if (points != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.smallBorderRadius,
                    border: Border.all(
                      width: AppBorders.smallBorderWidth,
                      color: context.colors.secondary,
                    ),
                    color: context.colors.lightPink,
                  ),
                  child: Row(
                    spacing: AppSpacing.spacingS,
                    children: [
                      CustomText(
                        '-$points',
                        textStyle: TextStyle(
                          color: context.colors.darkPink,
                          fontSize: CustomTextType.smallTag.fontSize,
                          fontWeight: CustomTextType.smallTag.fontWeight,
                        ),
                      ),
                      CustomSvgIcon(
                        icon: 'star',
                        color: context.colors.darkPink,
                        height: 8,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
