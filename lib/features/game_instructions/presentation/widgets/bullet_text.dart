import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText('• ', textType: CustomTextType.regularBody),
        Expanded(child: CustomText(text, textType: CustomTextType.regularBody)),
      ],
    );
  }
}
