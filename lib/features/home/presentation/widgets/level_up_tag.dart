import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LevelUpTag extends StatefulWidget {
  const LevelUpTag({super.key});

  @override
  State<LevelUpTag> createState() => _LevelUpTagState();
}

class _LevelUpTagState extends State<LevelUpTag>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    double transformValue = 1.1;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: transformValue,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: transformValue,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingM,
                horizontal: AppSpacing.spacingL,
              ),
              decoration: BoxDecoration(
                color: context.colors.darkGreen,
                borderRadius: AppBorders.hugeBorderRadius,
              ),
              child: CustomText(
                'LEVEL UP!',
                textType: CustomTextType.smallTag,
                isWhite: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
