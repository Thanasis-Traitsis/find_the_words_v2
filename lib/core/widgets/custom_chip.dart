import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String chipLabel;

  const CustomChip({super.key, required this.chipLabel});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: context.colors.primary,
      label: CustomText(
        chipLabel,
        textType: CustomTextType.regularBody,
        isWhite: true,
      ),
    );
  }
}
