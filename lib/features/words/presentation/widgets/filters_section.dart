import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FiltersSection extends StatelessWidget {
  final String sectionTitle;
  final Widget sectionContent;

  const FiltersSection({
    super.key,
    required this.sectionTitle,
    required this.sectionContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingL,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: AppBorders.smallBorderWidth,
                color: context.colors.text,
              ),
            ),
          ),
          child: CustomText(
            sectionTitle,
            textType: CustomTextType.smallHeading,
          ),
        ),
        sectionContent,
      ],
    );
  }
}
