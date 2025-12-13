import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:flutter/material.dart';

class CardIconContainer extends StatelessWidget {
  final Color backgroundColor;
  final CustomIcons icon;

  const CardIconContainer({
    super.key,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.spacingM),
      decoration: BoxDecoration(
        borderRadius: AppBorders.bigBorderRadius,
        color: backgroundColor,
      ),
      child: CustomSvgIcon(
        icon: icon,
        color: context.colors.white,
        height: AppSizes.iconL,
      ),
    );
  }
}
