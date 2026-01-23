import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  final int stat;
  final String label;
  final CustomIcons icon;
  final Color backgroundColor;
  final Color iconColor;

  const ProfileStatsCard({
    super.key,
    required this.stat,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacingM),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppBorders.smallBorderRadius,
              border: Border.all(
                width: AppBorders.smallBorderWidth,
                color: context.colors.darkBlue,
              ),
            ),
            child: Column(
              spacing: AppSpacing.spacingS,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  stat.toString(),
                  textType: CustomTextType.regularHeading,
                ),
                CustomText(label, textType: CustomTextType.regularBody),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.1,
              child: CustomSvgIcon(
                icon: icon,
                color: iconColor,
                height: AppSizes.iconXXL,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
