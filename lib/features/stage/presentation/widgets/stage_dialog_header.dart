import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageDialogHeader extends StatelessWidget {
  final CustomIcons icon;
  final String headerTitle;
  final String headerDescription;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;

  const StageDialogHeader({
    super.key,
    required this.icon,
    required this.headerTitle,
    required this.headerDescription,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingM),
      padding: const EdgeInsets.all(AppSpacing.spacingL),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: AppBorders.mediumBorderWidth,
          color: borderColor,
        ),
        borderRadius: AppBorders.hugeBorderRadius,
      ),
      child: Column(
        spacing: AppSpacing.spacingM,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomSvgIcon(
                icon: icon,
                color: textColor,
                height: AppSizes.iconXL,
              ),
              Expanded(
                child: CustomText(
                  headerTitle,
                  textStyle: TextStyle(
                    height: 1,
                    fontSize: CustomTextType.bigHeading.fontSize,
                    fontWeight: CustomTextType.bigHeading.fontWeight,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          CustomText(
            headerDescription,
            textStyle: TextStyle(
              height: 1,
              fontSize: CustomTextType.regularBody.fontSize,
              fontWeight: CustomTextType.regularBody.fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
