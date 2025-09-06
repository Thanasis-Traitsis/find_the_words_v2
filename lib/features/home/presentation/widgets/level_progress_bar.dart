import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

class LevelProgressBar extends StatefulWidget {
  final double progress;

  const LevelProgressBar({super.key, required this.progress});

  @override
  State<LevelProgressBar> createState() => _LevelProgressBarState();
}

class _LevelProgressBarState extends State<LevelProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: AppSizes.progressBarHeight,
          decoration: BoxDecoration(
            color: context.colors.darkGreen.withValues(alpha: 0.2),
            borderRadius: AppBorders.regularBorderRadius,
            border: Border.all(
              width: AppBorders.smallBorderWidth,
              color: context.colors.darkGreen,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: Transform.scale(
            alignment: Alignment.centerLeft,
            scaleX: widget.progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppBorders.regularBorderRadius,
                color: context.colors.darkGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
