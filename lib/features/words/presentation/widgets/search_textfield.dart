import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:flutter/material.dart';

class SearchTextfield extends StatelessWidget {
  const SearchTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(),
      onChanged: (value) {},
      style: TextStyle(fontSize: CustomTextType.regularBody.fontSize),
      decoration: InputDecoration(
        hintText: '${context.translate.searchPlaceholder} ...',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingL,
          vertical: AppSpacing.spacingS,
        ),
        border: OutlineInputBorder(borderRadius: AppBorders.bigBorderRadius),
      ),
    );
  }
}
