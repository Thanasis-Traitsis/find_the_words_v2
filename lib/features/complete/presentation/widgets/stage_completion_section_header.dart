import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageCompletionSectionHeader extends StatelessWidget {
  final String header;

  const StageCompletionSectionHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingS),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: AppBorders.smallBorderWidth,
            color: context.colors.black,
          ),
        ),
      ),
      child: CustomText(header, textType: CustomTextType.smallHeading),
    );
  }
}
