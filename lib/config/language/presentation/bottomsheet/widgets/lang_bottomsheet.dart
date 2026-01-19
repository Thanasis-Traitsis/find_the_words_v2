import 'package:find_the_words/core/widgets/info_container.dart';
import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/select_language_list.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:flutter/material.dart';

class LangBottomsheet extends StatelessWidget {
  const LangBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      headerTitle: context.translate.languageBottomsheetTitle,
      bottomsheetContent: Column(
        children: [
          InfoContainer.regular(
            infoText: context.translate.languageBottomsheetDescription,
          ),
          const SelectLanguageList(),
        ],
      ),
    );
  }
}
