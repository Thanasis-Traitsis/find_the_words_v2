import 'dart:math';

import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/crossword/crossword_letter_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrosswordContainer extends StatelessWidget {
  final StageActive stageState;
  final Map<int, GlobalKey> gridKeys;
  final Function(int) onCrosswordBoxTap;
  final List<int> revealedPositions;
  final List<int> remainingPositions;
  final List<int> newPositions;

  const CrosswordContainer({
    super.key,
    required this.stageState,
    required this.onCrosswordBoxTap,
    required this.gridKeys,
    required this.revealedPositions,
    required this.remainingPositions,
    required this.newPositions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FreezeCubit, FreezeState>(
      builder: (context, freezeState) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: AppSpacing.spacingM,
              bottom: AppSpacing.spacingM,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: freezeState.activeFreeze ? 1 : 0,
                child: Container(
                  padding: EdgeInsets.all(80),
                  decoration: BoxDecoration(
                    color: context.colors.white.withValues(alpha: 0.7),
                    border: Border.all(
                      width: AppBorders.smallBorderWidth,
                      color: context.colors.primary,
                    ),
                    borderRadius: AppBorders.regularBorderRadius,
                  ),
                  child: CustomSvgIcon(
                    icon: CustomIcons.freeze,
                    color: context.colors.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0, 
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = min(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );

                      return SizedBox(
                        width: size,
                        height: size,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: sqrt(
                                  stageState.stage.board.length,
                                ).ceil(),
                              ),
                          itemCount: stageState.stage.board.length,
                          itemBuilder: (context, index) {
                            final isRevealed = revealedPositions.contains(
                              index,
                            );
                            final shouldAnimate = newPositions.contains(index);

                            if (remainingPositions.contains(index) &&
                                !gridKeys.containsKey(index)) {
                              gridKeys[index] = GlobalKey();
                            }

                            return Container(
                              margin: stageState.stage.board.length < 10
                                  ? EdgeInsets.all(AppSpacing.spacingM)
                                  : stageState.stage.board.length < 80
                                  ? EdgeInsets.all(AppSpacing.spacingS)
                                  : EdgeInsets.all(AppSpacing.spacingXS),
                              child: CrosswordLetterBox(
                                key: gridKeys[index],
                                boardSize: stageState.stage.board.length,
                                crosswordBoxItem: stageState.stage.board[index],
                                isVisible: isRevealed,
                                shouldAnimate: shouldAnimate,
                                animationDelay:
                                    newPositions.indexOf(index) * 100,
                                onTap: () => onCrosswordBoxTap(index),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
