import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/home/presentation/widgets/logo_container.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.translate.loading;
    final letters = text.split('');

    return CustomScreen(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.spacingXL,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoContainer(),
              Wrap(
                spacing: AppSpacing.spacingM,
                runSpacing: AppSpacing.spacingM,
                children: List.generate(letters.length, (index) {
                  return _AnimatedLetter(
                    letter: letters[index],
                    animation: _controller,
                    index: index,
                    totalLetters: letters.length,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLetter extends StatelessWidget {
  final String letter;
  final Animation<double> animation;
  final int index;
  final int totalLetters;

  const _AnimatedLetter({
    required this.letter,
    required this.animation,
    required this.index,
    required this.totalLetters,
  });

  @override
  Widget build(BuildContext context) {
    final delayPerLetter = 1.0 / totalLetters;
    final animationDuration = 0.3;

    final start = delayPerLetter * index;
    final end = start + animationDuration;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double scale = 1.0;

        if (animation.value >= start && animation.value <= end) {
          final progress = (animation.value - start) / animationDuration;
          scale = 1.0 + (0.1 * Curves.elasticOut.transform(progress));
        }

        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.spacingM),
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: AppBorders.smallBorderRadius,
            ),
            child: CustomText(
              letter.toUpperCase(),
              textType: CustomTextType.regularHeading,
              isWhite: true,
            ),
          ),
        );
      },
    );
  }
}
