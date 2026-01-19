import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/app_borders.dart';
import 'package:find_the_words/core/constants/app_sizes.dart';
import 'package:find_the_words/core/constants/app_spacing.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/date_extensions.dart';
import 'package:find_the_words/core/utils/string_extensions.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) return Container();
        if (state.user.isGuest) return Container();

        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivityState) {
            final hasInternet = connectivityState is ConnectivityOnline;

            return Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: hasInternet
                      ? const SizedBox.shrink()
                      : ClipRect(
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            offset: hasInternet
                                ? const Offset(0, 1)
                                : const Offset(0, 0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: hasInternet ? 0.0 : 1.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.spacingL,
                                  vertical: AppSpacing.spacingM,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.darkBlue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                ),
                                child: Row(
                                  spacing: AppSpacing.spacingM,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomSvgIcon(
                                      icon: CustomIcons.noWifi,
                                      color: context.colors.white,
                                      height: AppSizes.iconXS,
                                    ),
                                    Expanded(
                                      child: Column(
                                        spacing: AppSpacing.spacingS,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            context
                                                .translate
                                                .noWifiNotificationTitle
                                                .toUpperCaseGreek(),
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: CustomTextType
                                                  .smallBody
                                                  .fontSize,
                                              height: 1,
                                              color: context.colors.white,
                                            ),
                                            isWhite: true,
                                          ),
                                          CustomText(
                                            context
                                                .translate
                                                .noWifiNotificationMessage,
                                            textType: CustomTextType.smallBody,
                                            isWhite: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        child: hasInternet
                            ? const SizedBox.shrink()
                            : Container(
                                height: 60,
                                color: context.colors.darkBlue,
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.spacingL),
                      decoration: BoxDecoration(
                        color: context.colors.background,
                        borderRadius: AppBorders.regularBorderRadius,
                        border: Border.all(
                          width: AppBorders.smallBorderWidth,
                          color: context.colors.text,
                        ),
                      ),
                      child: Row(
                        spacing: AppSpacing.spacingM,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.spacingM),
                            decoration: BoxDecoration(
                              color: context.colors.background,
                              borderRadius: AppBorders.smallBorderRadius,
                              border: Border.all(
                                width: AppBorders.smallBorderWidth,
                                color: context.colors.text,
                              ),
                            ),
                            child: CustomSvgIcon(
                              icon: CustomIcons.avatar,
                              color: context.colors.text,
                              height: AppSizes.iconM,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: AppSpacing.spacingS,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  state.user.username ??
                                      state.user.email ??
                                      "Guest_${state.user.id}",
                                  textType: CustomTextType.smallHeading,
                                ),
                                CustomText(
                                  context.translate.joinedOn(
                                    state.user.joinedAt.toShortDate(),
                                  ),
                                  textType: CustomTextType.regularBody,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
