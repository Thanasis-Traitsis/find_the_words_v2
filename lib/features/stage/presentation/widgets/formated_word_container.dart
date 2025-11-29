import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormatedWordContainer extends StatefulWidget {
  final StringBuffer word;

  const FormatedWordContainer({super.key, required this.word});

  @override
  State<FormatedWordContainer> createState() => _FormatedWordContainerState();
}

class _FormatedWordContainerState extends State<FormatedWordContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: AppValues.wrongWordAnimationDurationMil,
      ),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StageBloc, StageState>(
      listener: (context, state) {
        if (state is WordAlreadyFound || state is WordInvalid) {
          _shake();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: child,
          );
        },
        child: Opacity(
          opacity: widget.word.isNotEmpty ? 1 : 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingM,
              vertical: AppSpacing.spacingS,
            ),
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: AppBorders.regularBorderRadius,
              border: Border.all(
                width: AppBorders.smallBorderWidth,
                color: context.colors.darkBlue,
              ),
            ),
            child: CustomText(
              widget.word.toString(),
              textStyle: TextStyle(
                fontSize: CustomTextType.smallHeading.fontSize,
                fontWeight: CustomTextType.smallHeading.fontWeight,
                color: context.colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
