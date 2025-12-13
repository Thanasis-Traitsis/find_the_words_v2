import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BoostMultiplierTag extends StatelessWidget {
  final int multiplier;
  final bool isWhite;

  const BoostMultiplierTag({super.key, required this.multiplier, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingM),
      decoration: BoxDecoration(
        borderRadius: AppBorders.regularBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: isWhite ? context.colors.white : context.colors.text,
        ),
      ),
      child: CustomText(
        "x$multiplier",
        textType: CustomTextType.smallHeading,
        isWhite: isWhite,
      ),
    );
  }
}
