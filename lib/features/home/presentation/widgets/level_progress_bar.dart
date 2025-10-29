import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:flutter/material.dart';

class LevelProgressBar extends StatefulWidget {
  final double progress;
  final StageResults? stageResults;

  const LevelProgressBar({
    super.key,
    required this.progress,
    this.stageResults,
  });

  @override
  State<LevelProgressBar> createState() => _LevelProgressBarState();
}

class _LevelProgressBarState extends State<LevelProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;
  double _endProgress = 0.0;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    // Calculate starting progress
    if (widget.stageResults != null) {
      _currentProgress = widget.stageResults!.currentProgress;
      _endProgress = widget.stageResults!.newProgress;
    } else {
      _currentProgress = widget.progress;
      _endProgress = widget.progress;
    }

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: _currentProgress, end: _endProgress).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Start animation immediately if xpEarned is provided
    if (widget.stageResults != null && widget.stageResults!.xpEarned > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _animationController.forward();
          _hasAnimated = true;
        }
      });
    }
  }

  @override
  void didUpdateWidget(LevelProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stageResults != null &&
        widget.stageResults!.xpEarned > 0 &&
        !_hasAnimated) {
      final startProgress = _currentProgress;
      final endProgress = widget.progress;

      _progressAnimation = Tween<double>(begin: startProgress, end: endProgress)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

      _animationController.forward(from: 0);
      _currentProgress = endProgress;
      _hasAnimated = true;
    } else if (widget.progress != oldWidget.progress) {
      setState(() {
        _currentProgress = widget.progress;
        _progressAnimation = Tween<double>(
          begin: _currentProgress,
          end: _currentProgress,
        ).animate(_animationController);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.iconXS,
      decoration: BoxDecoration(
        color: context.colors.darkGreen.withValues(alpha: 0.2),
        borderRadius: AppBorders.regularBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.darkGreen,
        ),
      ),
      child: ClipRRect(
        borderRadius: AppBorders.regularBorderRadius,
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_progressAnimation.value / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(color: context.colors.darkGreen),
              ),
            );
          },
        ),
      ),
    );
  }
}
