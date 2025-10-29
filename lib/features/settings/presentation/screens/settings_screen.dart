import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/lang_bottomsheet.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/features/settings/presentation/widgets/settings_row_item.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BigHeading(pageTitle: context.translate.settingsScreenName),
              SettingsRowItem.navigateToPage(
                name: context.translate.settingsItemTheme,
                page: AppPages.theme,
              ),
              SettingsRowItem(
                name: context.translate.settingsItemLanguage,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return LangBottomsheet();
                    },
                  );
                },
              ),
              SettingsRowItem(
                name: context.translate.settingsItemSound,
                onTap: () {},
                iconWidget: SizedBox(
                  width: 40,
                  height: 32,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(value: true, onChanged: (bool value1) {}),
                  ),
                ),
              ),
              SettingsRowItem.navigateToPage(
                name: context.translate.settingsItemGameInstructions,
                page: AppPages.gameInstructions,
              ),
              SettingsRowItem(
                name: context.translate.settingsItemResetStage,
                onTap: () {},
              ),
              SettingsRowItem(
                name: context.translate.settingsItemReportBug,
                onTap: () {},
              ),
              SettingsRowItem(
                name: context.translate.settingsItemReportBadWord,
                onTap: () {},
              ),
              SettingsRowItem(
                name: context.translate.settingsItemReportContact,
                onTap: () {},
              ),
              SettingsRowItem.navigateToWeb(
                name: context.translate.settingsItemReportPrivacy,
                link: "https://github.com/Thanasis-Traitsis",
              ),
              SettingsRowItem.navigateToWeb(
                name: context.translate.settingsItemReportTermsConditions,
                link: "https://github.com/Thanasis-Traitsis",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
