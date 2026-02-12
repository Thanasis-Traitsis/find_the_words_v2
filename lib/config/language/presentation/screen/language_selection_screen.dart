import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/config/language/presentation/screen/widgets/language_list_container.dart';
import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.screenPadding,
            ),
            child: Column(
              spacing: AppSpacing.spacingL,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  context.translate.chooseLanguageHeader,
                  textType: CustomTextType.regularHeading,
                ),
                const LanguageListContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
