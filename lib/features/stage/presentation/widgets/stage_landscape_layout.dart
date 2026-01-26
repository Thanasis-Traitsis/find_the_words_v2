import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/active_boost_tag.dart';
import 'package:find_the_words/features/stage/presentation/helpers/stage_controller.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/circle_container_with_word.dart';
import 'package:find_the_words/features/stage/presentation/widgets/crossword/crossword_container.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_action_buttons.dart';
import 'package:flutter/material.dart';

class StageLandscapeLayout extends StatelessWidget {
  final StageActive state;
  final StageController controller;
  final bool blockWordCreation;
  final ValueChanged<bool> onWordFormationChange;

  const StageLandscapeLayout({
    super.key,
    required this.state,
    required this.controller,
    required this.blockWordCreation,
    required this.onWordFormationChange,
  });

  @override
  Widget build(BuildContext context) {
    final newPositions = state is StageInProgress
        ? (state as StageInProgress).newPositions
        : <int>[];
    final revealedPositions = state.stage.placementTracker.revealedPositions;
    final remainingPositions = state.stage.placementTracker.remainingPositions;

    return Row(
      spacing: AppSpacing.spacingM,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: CrosswordContainer(
                stageState: state,
                onCrosswordBoxTap: controller.onCrosswordTap,
                gridKeys: controller.gridKeys,
                revealedPositions: revealedPositions,
                remainingPositions: remainingPositions,
                newPositions: newPositions,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              spacing: AppSpacing.spacingM,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        CircleContainerWithWord(
                          letters: state.stage.letters,
                          onWordFormationChange: onWordFormationChange,
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: ActiveBoostTag(
                            withData: true,
                            isExpandable: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StageActionButtons(
                  controller: controller,
                  state: state,
                  remainingPositions: remainingPositions,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
