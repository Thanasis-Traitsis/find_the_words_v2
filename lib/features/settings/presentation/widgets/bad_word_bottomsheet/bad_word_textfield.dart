import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class BadWordTextfield extends StatelessWidget {
  final TextEditingController controller;
  
  const BadWordTextfield({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      hintText: '${context.translate.settingsBadWordBottomsheetTextfieldHint} ...',
      textEditingController: controller,
      onChanged: (query) {},
      onClearPressed: () {},
    );
  }
}
