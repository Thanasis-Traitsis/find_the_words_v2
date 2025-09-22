import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/helpers/circle_layout_delegate.dart';
import 'package:find_the_words/features/stage/presentation/helpers/line_painter.dart';
import 'package:find_the_words/features/stage/presentation/widgets/formated_word_container.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';

class CircleContainerWithWord extends StatefulWidget {
  final List<String> letters;

  const CircleContainerWithWord({super.key, required this.letters});

  @override
  State<CircleContainerWithWord> createState() =>
      _CircleContainerWithWordState();
}

class _CircleContainerWithWordState extends State<CircleContainerWithWord> {
  StringBuffer formatedWord = StringBuffer();

  List<Offset> selectedPositions = [];
  List<int> selectedIndices = [];
  Offset? currentDragPosition;
  bool isDragging = false;

  final Map<int, Offset> letterCenters = {};

  static const double containerPadding = AppSpacing.spacingM;
  static const double letterSize = AppSizes.stageLetterSize;
  static const double offsetAdjustment = containerPadding + (letterSize / 2);

  void _handlePointerDown(Offset localPosition) {
    final letterIndex = _findLetterAtPosition(localPosition);

    if (letterIndex != null) {
      setState(() {
        isDragging = true;
        selectedIndices.clear();
        selectedPositions.clear();

        selectedIndices.add(letterIndex);
        selectedPositions.add(letterCenters[letterIndex]!);
        formatedWord.write(widget.letters[letterIndex]);
      });
    }
  }

  void _handlePointerMove(Offset localPosition) {
    if (!isDragging) return;

    setState(() {
      if (selectedIndices.length < widget.letters.length) {
        currentDragPosition = localPosition;
      }

      final letterIndex = _findLetterAtPosition(localPosition);

      if (letterIndex != null && !selectedIndices.contains(letterIndex)) {
        selectedIndices.add(letterIndex);
        selectedPositions.add(letterCenters[letterIndex]!);
        formatedWord.write(widget.letters[letterIndex]);

        if (selectedIndices.length >= widget.letters.length) {
          currentDragPosition = null;
        }
      }
    });
  }

  void _handlePointerUp() {
    setState(() {
      isDragging = false;
      currentDragPosition = null;

      if (mounted) {
        setState(() {
          selectedIndices.clear();
          selectedPositions.clear();
          formatedWord.clear();
        });
      }
    });
  }

  int? _findLetterAtPosition(Offset position) {
    for (var entry in letterCenters.entries) {
      final distance = (entry.value - position).distance;

      if (distance <= offsetAdjustment - containerPadding) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormatedWordContainer(word: formatedWord),
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM),
          alignment: Alignment.center,
          child: Listener(
            onPointerDown: (event) {
              _handlePointerDown(event.localPosition);
            },
            onPointerMove: (event) {
              _handlePointerMove(event.localPosition);
            },
            onPointerUp: (event) {
              _handlePointerUp();
            },
            child: Container(
              padding: const EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.stageBlue.withValues(alpha: 0.8),
                border: Border.all(
                  width: 1,
                  color: context.colors.darkBlue.withValues(alpha: 0.4),
                ),
              ),
              child: Stack(
                children: [
                  if (selectedPositions.isNotEmpty ||
                      currentDragPosition != null)
                    CustomPaint(
                      painter: LinePainter(
                        selectedLetters: selectedIndices.length,
                        context: context,
                        positions: selectedPositions,
                        currentDragPosition: currentDragPosition,
                      ),
                    ),
                  Flow(
                    delegate: CircleLayoutDelegate(
                      onPositionsCalculated: (positions) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            letterCenters.clear();
                            positions.forEach((index, offset) {
                              letterCenters[index] = Offset(
                                offset.dx + offsetAdjustment,
                                offset.dy + offsetAdjustment,
                              );
                            });
                          }
                        });
                      },
                    ),
                    children: List.generate(widget.letters.length, (index) {
                      final isSelected = selectedIndices.contains(index);

                      return Container(
                        alignment: Alignment.center,
                        width: letterSize,
                        height: letterSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? context.colors.primary
                              : Colors.transparent,
                        ),
                        child: CustomText(
                          widget.letters[index],
                          textStyle: TextStyle(
                            fontSize: CustomTextType.regularHeading.fontSize,
                            fontWeight:
                                CustomTextType.regularHeading.fontWeight,
                            color: isSelected
                                ? context.colors.white
                                : context.colors.darkBlue,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            spacing: AppSpacing.spacingM,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StageIconButton(
                icon: 'help',
                text: context.translate.stageButtonHelp,
              ),
              StageIconButton(
                icon: 'shuffle',
                // text: context.translate.stageButtonShuffle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
