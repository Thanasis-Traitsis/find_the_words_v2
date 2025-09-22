import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;

  const CustomIconButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: AppSizes.minAccessibleToucharea,
          minWidth: AppSizes.minAccessibleToucharea,
        ),
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppBorders.regularBorderRadius,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.iconButtonPadding),
              child: CustomSvgIcon(icon: icon, color: context.colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
