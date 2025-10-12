import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CrosswordLetterBox extends StatefulWidget {
  final int boardSize;
  final String crosswordBoxItem;
  final bool isVisible;
  final bool shouldAnimate;
  final int? animationDelay;

  const CrosswordLetterBox({
    super.key,
    required this.boardSize,
    required this.crosswordBoxItem,
    this.isVisible = false,
    this.shouldAnimate = false,
    this.animationDelay,
  });

  @override
  State<CrosswordLetterBox> createState() => _CrosswordLetterBoxState();
}

class _CrosswordLetterBoxState extends State<CrosswordLetterBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    double transformValue = widget.boardSize < 80 ? 1.1 : 1.05;

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
  }

  @override
  void didUpdateWidget(CrosswordLetterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration(milliseconds: widget.animationDelay ?? 0), () {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.crosswordBoxItem.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.shouldAnimate ? _scaleAnimation.value : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppBorders.smallBorderRadius,
              color: widget.isVisible
                  ? context.colors.primary
                  : context.colors.stageBlue.withValues(alpha: 0.6),
              border: Border.all(
                width: AppBorders.smallBorderWidth,
                color: widget.isVisible
                    ? context.colors.primary
                    : context.colors.stageBlue,
              ),
            ),
            child: CustomText(
              widget.isVisible ? widget.crosswordBoxItem : "",
              textStyle: TextStyle(
                color: widget.isVisible
                    ? context.colors.white
                    : Colors.transparent,
                fontSize: setFontSize(widget.boardSize),
              ),
            ),
          ),
        );
      },
    );
  }
}

double setFontSize(int board) {
  switch (board) {
    case 9: // 3x3
      return 40;
    case 16: // 4x4
      return 36;
    case 25: // 5x5
      return 32;
    case 36: // 6x6
      return 28;
    case 49: // 7x7
      return 26;
    case 64: // 8x8
      return 24;
    case 81: // 9x9
      return 22;
    case 100: // 10x10
      return 20;
    case 121: // 11x11
      return 18;
    case 144: // 12x12
      return 16;
    default:
      return 14;
  }
}
