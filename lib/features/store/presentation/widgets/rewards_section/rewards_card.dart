import 'package:find_the_words/config/ads/rewarded_cubit/rewarded_ad_cubit.dart';
import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/screen_extensions.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/store/data/models/reward_type.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/countdown_timer_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsCard extends StatelessWidget {
  final RewardConfig rewardConfig;
  final String smallTitle;
  final String bigTitle;
  final String description;
  final CustomIcons rewardIcon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const RewardsCard({
    super.key,
    required this.rewardConfig,
    required this.smallTitle,
    required this.bigTitle,
    required this.description,
    required this.rewardIcon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardedAdCubit, RewardedAdState>(
      builder: (context, adState) {
        final adFailed = adState is RewardedAdFailed;
        final isAvailable = !rewardConfig.isActive && !adFailed;
        final showLoading = isAvailable && adState is RewardedAdLoading;
        
        return Stack(
          children: [
            Opacity(
              opacity: isAvailable ? 1 : 0.5,
              child: GestureDetector(
                onTap: !rewardConfig.isActive
                    ? () {
                        context.read<RewardedAdCubit>().showAd(
                          rewardConfig,
                          context,
                        );
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: AppBorders.regularBorderRadius,
                    border: Border.all(
                      width: AppBorders.mediumBorderWidth,
                      color: context.colors.black,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.spacingL),
                        decoration: BoxDecoration(
                          borderRadius: AppBorders.regularBorderRadius,
                        ),
                        child: Column(
                          spacing: AppSpacing.spacingL,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    spacing: AppSpacing.spacingM,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        smallTitle,
                                        textStyle: TextStyle(
                                          fontSize: CustomTextType
                                              .regularBody
                                              .fontSize,
                                          fontWeight: CustomTextType
                                              .smallHeading
                                              .fontWeight,
                                          color: textColor,
                                          height: 1,
                                        ),
                                      ),
                                      CustomText(
                                        bigTitle,
                                        textStyle: TextStyle(
                                          fontFamily: AppTheme.highlighFont,
                                          fontSize: CustomTextType
                                              .bigHeading
                                              .fontSize,
                                          fontWeight: CustomTextType
                                              .bigHeading
                                              .fontWeight,
                                          color: textColor,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                showLoading
                                    ? SizedBox.shrink()
                                    : CustomSvgIcon(
                                        icon: CustomIcons.arrowRight,
                                        color: context.colors.black,
                                        height: AppSizes.iconM,
                                      ),
                              ],
                            ),
                            SizedBox(
                              width: context.screenWidth * 0.5,
                              child: CustomText(
                                description,
                                textType: CustomTextType.regularBody,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -AppSpacing.spacingM,
                        bottom: -AppSpacing.spacingM,
                        child: Opacity(
                          opacity: 0.4,
                          child: CustomSvgIcon(
                            icon: rewardIcon,
                            color: iconColor,
                            height: AppSizes.rewardIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showLoading)
              Positioned(
                right: AppSpacing.spacingL,
                top: AppSpacing.spacingL,
                child: SizedBox(
                  height: AppSizes.iconM,
                  width: AppSizes.iconM,
                  child: CircularProgressIndicator(color: context.colors.black),
                ),
              ),
            if (!isAvailable)
              Positioned(
                right: AppSpacing.spacingL,
                top: AppSpacing.spacingL,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingL,
                    vertical: AppSpacing.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.error,
                    borderRadius: AppBorders.bigBorderRadius,
                  ),
                  child: Column(
                    spacing: AppSpacing.spacingS,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        context.translate.notAvailableTag,
                        textType: CustomTextType.smallTag,
                        isWhite: true,
                      ),
                      if (rewardConfig.notAvailableUntil != null)
                        CountdownTimerTag(
                          notAvailableUntil: rewardConfig.notAvailableUntil,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
