import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomBorderContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;
  final bool fullWidth;
  final bool isLoading;

  const CustomBorderContainer({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    this.fullWidth = true,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: borderColor,
        ),
        borderRadius: AppBorders.hugeBorderRadius,
        color: backgroundColor,
      ),
      margin: const EdgeInsets.only(top: AppSpacing.spacingL),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacingM,
        horizontal: AppSpacing.spacingL,
      ),
      child: child,
    );
  }
}
