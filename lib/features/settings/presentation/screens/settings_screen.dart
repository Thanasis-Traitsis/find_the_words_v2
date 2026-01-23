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
import 'package:find_the_words/features/settings/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:find_the_words/features/settings/presentation/widgets/profile_banner/profile_banner.dart';
import 'package:find_the_words/features/settings/presentation/widgets/reset_stage_bottomsheet/reset_stage_bottomsheet.dart';
import 'package:find_the_words/features/settings/presentation/widgets/settings_row_item.dart';
import 'package:find_the_words/features/settings/presentation/widgets/sound_settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          switch (state.effect) {
            case AuthEffect.signInSuccess:
              SnackbarHelper.showSuccessSnackbar(
                context,
                title: context.translate.googleSignInSuccessTitle,
                message: context.translate.googleSignInSuccessMessage,
              );
              break;
            case AuthEffect.signInFailure:
              SnackbarHelper.showErrorSnackbar(
                context,
                title: context.translate.googleSignInFailureTitle,
                message: context.translate.googleSignInFailureMessage,
              );
              break;
            case AuthEffect.signOutSuccess:
              SnackbarHelper.showSuccessSnackbar(
                context,
                title: context.translate.googleSignOutSuccessTitle,
                message: context.translate.googleSignOutSuccessMessage,
              );
              break;
            case AuthEffect.signOutFailure:
              SnackbarHelper.showErrorSnackbar(
                context,
                title: context.translate.googleSignOutFailureTitle,
                message: context.translate.googleSignOutFailureMessage,
              );
              break;
            case null:
              null;
          }

          state.clearEffect();
        }
      },
      builder: (context, state) {
        if (state is! AuthAuthenticated) return Container();

        final currentUser = state.user;
        final currentStage = currentUser.currentProgress.stage;

        return CustomScreen(
          loadingScreen: state.signInOutLoading,
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
                      BigHeading(
                        pageTitle: context.translate.settingsScreenName,
                      ),
                      const ProfileBanner(),
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
                      SettingsRowItem(
                        name: context.translate.settingsItemResetStage,
                        onTap: () {
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
                      ),
                      SettingsRowItem(
                        name: context.translate.settingsItemReportBadWord,
                        onTap: () =>
                            context.read<SettingsCubit>().openReportBadWord(),
                      ),
                      SettingsRowItem(
                        name: context.translate.settingsItemReportBug,
                        onTap: () => context.read<SettingsCubit>().openEmail(
                          subject:
                              context.translate.settingsEmailSubjectReportBug,
                        ),
                      ),
                      SettingsRowItem(
                        name: context.translate.settingsItemReportContact,
                        onTap: () => context.read<SettingsCubit>().openEmail(
                          subject:
                              context.translate.settingsEmailSubjectContact,
                        ),
                      ),
                      SettingsRowItem.navigateToWeb(
                        name: context.translate.settingsItemReportPrivacy,
                        link: "https://github.com/Thanasis-Traitsis",
                      ),
                      SettingsRowItem.navigateToWeb(
                        name:
                            context.translate.settingsItemReportTermsConditions,
                        link: "https://github.com/Thanasis-Traitsis",
                      ),
                      currentUser.isGuest
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: AppSpacing.spacingL,
                              ),
                              child: CustomSocialButton(
                                social: CustomIcons.google,
                                text: "Google Sign in",
                                onPressed: () {
                                  getIt<AuthCubit>().googleSignIn();
                                },
                                requiresInternet: true,
                              ),
                            )
                          : SettingsRowItem.logout(
                              name: context.translate.logoutBtnText,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const LogoutConfirmationDialog(),
                                );
                              },
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
