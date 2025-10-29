import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/config/language/presentation/screen/widgets/language_selection_item.dart';
import 'package:flutter/material.dart';

class LanguageListContainer extends StatefulWidget {
  const LanguageListContainer({super.key});

  @override
  State<LanguageListContainer> createState() => _LanguageListContainerState();
}

class _LanguageListContainerState extends State<LanguageListContainer> {
  AppLanguage selectedLanguage = getIt<LanguageCubit>().state.appLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacingS,
        horizontal: AppSpacing.spacingL,
      ),
      decoration: BoxDecoration(
        borderRadius: AppBorders.bigBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.black,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(AppLanguage.values.length, (index) {
          final language = AppLanguage.values[index];
          final isLast = index == AppLanguage.values.length - 1;

          return LanguageSelectionItem(
            isLast: isLast,
            language: language,
            isSelected: language == selectedLanguage,
            onTap: () {
              setState(() {
                selectedLanguage = language;
              });
              getIt<LanguageCubit>().setNewLanguage(language.code);
            },
          );
        }),
      ),
    );
  }
}
