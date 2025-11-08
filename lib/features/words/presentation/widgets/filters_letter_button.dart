import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FiltersLetterButton extends StatelessWidget {
  final List<String> selectedLetters;
  final String letter;
  final VoidCallback onTap;

  const FiltersLetterButton({
    super.key,
    required this.letter,
    required this.selectedLetters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedLetters.contains(letter);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.regularBorderRadius,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.spacingM,
            horizontal: AppSpacing.spacingXL,
          ),
          decoration: BoxDecoration(
            borderRadius: AppBorders.regularBorderRadius,
            border: Border.all(
              width: AppBorders.smallBorderWidth,
              color: context.colors.black,
            ),
            color: isSelected ? context.colors.primary : null,
          ),
          child: CustomText(
            letter,
            textType: CustomTextType.smallHeading,
            isWhite: isSelected,
          ),
        ),
      ),
    );
  }
}
