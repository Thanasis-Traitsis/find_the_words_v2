import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        borderRadius: AppBorders.bigBorderRadius,
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacingM),
          decoration: BoxDecoration(
            borderRadius: AppBorders.bigBorderRadius,
            border: Border.all(
              width: AppBorders.smallBorderWidth,
              color: context.colors.black,
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingM,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvgIcon(icon: 'filter', color: context.colors.black),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingS,
                  horizontal: AppSpacing.spacingM,
                ),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: AppBorders.regularBorderRadius,
                ),
                child: CustomText(
                  '1',
                  textType: CustomTextType.regularBody,
                  isWhite: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
