import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SelectedOptionButton extends StatelessWidget {
  final String content;
  final VoidCallback onTap;
  final bool isSelected;
  final bool smallerContent;

  const SelectedOptionButton({
    super.key,
    required this.content,
    required this.onTap,
    this.isSelected = false,
    this.smallerContent = false,
  });

  @override
  Widget build(BuildContext context) {    
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
            content,
            textType: smallerContent ? CustomTextType.regularBody : CustomTextType.smallHeading,
            isWhite: isSelected,
          ),
        ),
      ),
    );
  }
}
