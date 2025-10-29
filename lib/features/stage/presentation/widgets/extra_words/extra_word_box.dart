import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/extra_words/extra_words_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ExtraWordsBoxState extends State<ExtraWordsBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;
  bool _hasBeenInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const ExtraWordsDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.spacingM),
            decoration: BoxDecoration(
              color: context.colors.lightBlue,
              borderRadius: AppBorders.bigBorderRadius,
              border: Border.all(
                width: AppBorders.smallBorderWidth,
                color: context.colors.darkBlue,
              ),
            ),
            child: CustomSvgIcon(icon: 'box', color: context.colors.darkBlue),
          ),
        ),
        BlocBuilder<StageBloc, StageState>(
          builder: (context, state) {
            if (state is! StageActive) return const SizedBox.shrink();

            final currentCount = state.stage.placementTracker.extraWords.length;

            if (currentCount > _previousCount) {
              if (_hasBeenInitialized) {
                _controller.forward(from: 0);
              }
            }
            _hasBeenInitialized = true;
            _previousCount = currentCount;

            return Positioned(
              left: -AppSizes.extraWordsNumberSpacing,
              bottom: 0,
              child: Opacity(
                opacity: currentCount > 0 ? 1.0 : 0.0,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.spacingS),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: AppBorders.smallBorderRadius,
                    ),
                    child: CustomText(
                      "$currentCount",
                      textType: CustomTextType.smallTag,
                      isWhite: true,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ExtraWordsBox extends StatefulWidget {
  const ExtraWordsBox({super.key});

  @override
  State<ExtraWordsBox> createState() => _ExtraWordsBoxState();
}
