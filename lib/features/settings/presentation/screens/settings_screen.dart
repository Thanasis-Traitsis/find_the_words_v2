import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/lang_bottomsheet.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/features/settings/presentation/settings_cubit/settings_cubit.dart';
import 'package:find_the_words/features/settings/presentation/widgets/bad_word_bottomsheet/bad_word_bottomsheet.dart';
import 'package:find_the_words/features/settings/presentation/widgets/reset_stage_bottomsheet/reset_stage_bottomsheet.dart';
import 'package:find_the_words/features/settings/presentation/widgets/settings_row_item.dart';
import 'package:find_the_words/features/settings/presentation/widgets/sound_settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: BlocConsumer<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is SettingsEmailFailed) {
                // TODO: add snackbar here when you have no internet connection or something else happened
              }
              if (state is SettingsReportBadWord) {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return BadWordBottomsheet(
                      previousStageWords: state.previousStageWords,
                    );
                  },
                ).then((value) {
                  if (context.mounted) {
                    context.read<SettingsCubit>().resetSettingsState();
                  }
                });
              }
              if (state is SettingsEmailOpened) {
                // TODO: add snackbar here showing appreciation for the support
              }
              if (state is SettingsStageReset) {
                print("object");
              }
            },
            builder: (context, state) {
              return Column(
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
                  const SoundSettingsItem(),
                  SettingsRowItem.navigateToPage(
                    name: context.translate.settingsItemGameInstructions,
                    page: AppPages.gameInstructions,
                  ),
                  SettingsRowItem(
                    name: context.translate.settingsItemResetStage,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return ResetStageBottomsheet();
                        },
                      ).then((resetConfirmed) {
                        if (context.mounted) {
                          if (resetConfirmed != null &&
                              resetConfirmed == true) {
                            context.read<SettingsCubit>().resetStage();
                          }
                        }
                      });
                    },
                  ),
                  SettingsRowItem(
                    name: context.translate.settingsItemReportBadWord,
                    onTap: () =>
                        context.read<SettingsCubit>().openReportBadWord(),
                  ),
                  SettingsRowItem(
                    name: context.translate.settingsItemReportBug,
                    onTap: () => context.read<SettingsCubit>().openEmail(
                      subject: context.translate.settingsEmailSubjectReportBug,
                    ),
                  ),
                  SettingsRowItem(
                    name: context.translate.settingsItemReportContact,
                    onTap: () => context.read<SettingsCubit>().openEmail(
                      subject: context.translate.settingsEmailSubjectContact,
                    ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
