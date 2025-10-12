import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageDataListItem extends StatelessWidget {
  final String title;
  final int value;

  const StageDataListItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingXS),
      child: Row(
        spacing: AppSpacing.spacingL,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title, textType: CustomTextType.regularBody),
          CustomText('$value', textType: CustomTextType.smallHeading),
        ],
      ),
    );
  }
}
