import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BottomsheetSection extends StatelessWidget {
  final String sectionTitle;
  final Widget sectionContent;

  const BottomsheetSection({
    super.key,
    required this.sectionTitle,
    required this.sectionContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.spacingM,
      children: [
        CustomText(
          sectionTitle,
          textType: CustomTextType.smallHeading,
        ),
        sectionContent,
      ],
    );
  }
}
