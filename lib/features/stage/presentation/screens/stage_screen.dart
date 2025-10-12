import 'dart:math';

import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/circle_container_with_word.dart';
import 'package:find_the_words/features/stage/presentation/widgets/crossword/crossword_letter_box.dart';
import 'package:find_the_words/features/stage/presentation/widgets/extra_words/extra_word_box.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_dialog.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/widgets/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageScreen extends StatefulWidget {
  final int stage;
  const StageScreen({super.key, required this.stage});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  bool _showOverlay = false;
  final GlobalKey _buttonKey = GlobalKey();
  final Map<int, GlobalKey> _gridKeys = {};
  List<GlobalKey> keysToHighlight = <GlobalKey>[];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StageBloc, StageState>(
      listener: (context, state) async {
        if (state is StageCompleted) {
          await Future.delayed(const Duration(seconds: 1));
          AppPages.complete.go();
        }
      },
      builder: (context, state) {
        if (state is! StageActive) {
          return CustomScreen(
            appBar: CustomAppbar.withUserPoints(
              isHomePage: false,
              suffixWidget: const ExtraWordsBox(),
              leadingIcon: 'arrow_left',
              title: context.translate.stageWithNumber(widget.stage),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final newPositions = state is StageInProgress
            ? state.newPositions
            : <int>[];

        final revealedPositions =
            state.stage.placementTracker.revealedPositions;

        final remainingPositions =
            state.stage.placementTracker.remainingPositions;

        return AbsorbPointer(
          absorbing: state is StageCompleted,
          child: CustomScreen.withOverlay(
            showOverlay: _showOverlay,
            overlayWidgetKeys: keysToHighlight,
            onOverlayTap: () {
              setState(() {
                _showOverlay = false;
              });
            },
            appBar: CustomAppbar.withUserPoints(
              isHomePage: false,
              suffixWidget: const ExtraWordsBox(),
              leadingIcon: 'arrow_left',
              title: context.translate.stageWithNumber(widget.stage),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spacingL),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spacingM,
                      ),
                      child: Center(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: sqrt(
                                  state.stage.board.length,
                                ).ceil(),
                              ),
                          itemCount: state.stage.board.length,
                          itemBuilder: (context, index) {
                            final isRevealed = revealedPositions.contains(
                              index,
                            );
                            final shouldAnimate = newPositions.contains(index);

                            if (remainingPositions.contains(index) &&
                                !_gridKeys.containsKey(index)) {
                              _gridKeys[index] = GlobalKey();
                            }

                            return Container(
                              margin: state.stage.board.length < 10
                                  ? EdgeInsets.all(AppSpacing.spacingM)
                                  : state.stage.board.length < 80
                                  ? EdgeInsets.all(AppSpacing.spacingS)
                                  : EdgeInsets.all(AppSpacing.spacingXS),
                              child: CrosswordLetterBox(
                                key: _gridKeys[index],
                                boardSize: state.stage.board.length,
                                crosswordBoxItem: state.stage.board[index],
                                isVisible: isRevealed,
                                shouldAnimate: shouldAnimate,
                                animationDelay:
                                    newPositions.indexOf(index) * 100,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  CircleContainerWithWord(letters: state.stage.letters),
                  Row(
                    spacing: AppSpacing.spacingM,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const HelpDialog(),
                          );
                        },
                        child: CustomSvgIcon(
                          icon: 'info',
                          color: context.colors.text,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: AppSpacing.spacingM,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StageIconButton(
                              icon: 'shuffle',
                              onTap: () {
                                setState(() {
                                  state.stage.letters.shuffle();
                                });
                              },
                            ),
                            StageIconButton(
                              icon: 'magic_wond',
                              onTap: () {
                                context.read<StageBloc>().add(
                                  RandomLetterReveal(),
                                );
                              },
                            ),
                            StageIconButton(
                              key: _buttonKey,
                              icon: 'target',
                              onTap: () {
                                setState(() {
                                  if (!_showOverlay) {
                                    keysToHighlight = [
                                      _buttonKey,
                                      ...remainingPositions
                                          .where(
                                            (pos) => _gridKeys.containsKey(pos),
                                          )
                                          .map((pos) => _gridKeys[pos]!),
                                    ];
                                    _showOverlay = true;
                                  } else {
                                    _showOverlay = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
