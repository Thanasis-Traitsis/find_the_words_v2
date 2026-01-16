import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/lang_bottomsheet.dart';
import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/snackbar_helper.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/core/widgets/custom_social_button.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
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
              if (state is SettingsStageReset) {
                SnackbarHelper.showSuccessSnackbar(
                  context,
                  title: context.translate.resetStageNotificationTitle,
                  message: context.translate.resetStageNotificationMessage,
                );
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
                          return const LangBottomsheet();
                        },
                      );
                    },
                  ),
                  const SoundSettingsItem(),
                  SettingsRowItem.navigateToPage(
                    name: context.translate.settingsItemGameInstructions,
                    page: AppPages.gameInstructions,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is! AuthAuthenticated) return Container();

                      return SettingsRowItem(
                        name: context.translate.settingsItemResetStage,
                        onTap: () {
                          final currentStage = state.user.currentProgress.stage;

                          showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return const ResetStageBottomsheet();
                            },
                          ).then((resetConfirmed) {
                            if (context.mounted) {
                              if (resetConfirmed != null &&
                                  resetConfirmed == true) {
                                context.read<SettingsCubit>().resetStage(
                                  currentStage,
                                );
                              }
                            }
                          });
                        },
                      );
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
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingL,
                    ),
                    child: CustomSocialButton(
                      social: CustomIcons.google,
                      text: "Google Sign in",
                      onPressed: () {
                        getIt<AuthCubit>().googleSignIn();
                      },
                    ),
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
