import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/config/language/presentation/screen/widgets/language_selection_item.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';

class LanguageListContainer extends StatefulWidget {
  const LanguageListContainer({super.key});

  @override
  State<LanguageListContainer> createState() => _LanguageListContainerState();
}

class _LanguageListContainerState extends State<LanguageListContainer> {
  AppLanguage selectedLanguage = getIt<LanguageCubit>().state.appLanguage;
  bool _isApplying = false;

  Future<void> applyNewLanguage() async {
    setState(() {
      _isApplying = true;
    });
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      await getIt<LanguageCubit>().setNewLanguage(selectedLanguage.code);

      setState(() {
        _isApplying = false;
      });
    } catch (e) {
      setState(() {
        _isApplying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingL,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
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
                onTap: _isApplying
                    ? null
                    : () {
                        setState(() {
                          selectedLanguage = language;
                        });
                      },
              );
            }),
          ),
        ),
        CustomPrimaryButton.large(
          isLoading: _isApplying,
          text: context.translate.submit,
          onTap: () async {
            if (_isApplying) return;

            if (selectedLanguage != getIt<LanguageCubit>().state.appLanguage) {
              await applyNewLanguage();
            }

            AppPages.home.go();
          },
        ),
      ],
    );
  }
}
