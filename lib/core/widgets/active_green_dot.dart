import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

class ActiveGreenDot extends StatelessWidget {
  const ActiveGreenDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppSizes.iconXXS,
          height: AppSizes.iconXXS,
          decoration: BoxDecoration(
            color: context.colors.lightGreen.withValues(alpha: 0.4),
            borderRadius: AppBorders.hugeBorderRadius,
          ),
        ),
        Positioned(
          left: 2,
          top: 2,
          right: 2,
          bottom: 2,
          child: Container(
            width: AppSizes.tinyHeight,
            height: AppSizes.tinyHeight,
            decoration: BoxDecoration(
              color: context.colors.lightGreen,
              borderRadius: AppBorders.hugeBorderRadius,
            ),
          ),
        ),
      ],
    );
  }
}
