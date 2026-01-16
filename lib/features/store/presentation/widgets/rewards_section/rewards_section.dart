import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/store/data/models/reward_type.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsSection extends StatelessWidget {
  const RewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final discountService = getIt<StoreDiscountService>();

    return ListenableBuilder(
      listenable: discountService,
      builder: (context, asyncSnapshot) {
        return StoreSection(
          sectionHeader: const RewardsSectionHeader(),
          sectionContent: Column(
            spacing: AppSpacing.spacingM,
            children: [
              RewardsCard(
                rewardConfig: RewardConfig(
                  type: RewardType.earnPoints,
                  amount: 20,
                  isActive: false,
                  notificationTitle: context.translate.rewardNotificationTitle,
                  notificationMessage: context.translate
                      .rewardPointsNotificationMessage(20),
                ),
                smallTitle: context.translate.rewardsFirstOfferTitleSmall,
                bigTitle: context.translate.rewardsFirstOfferTitleBig(20),
                description: context.translate.rewardsFirstOfferDescription(20),
                rewardIcon: CustomIcons.stars,
                backgroundColor: context.colors.lightPink,
                iconColor: context.colors.secondary,
                textColor: context.colors.darkPink,
              ),
              RewardsCard(
                rewardConfig: RewardConfig(
                  type: RewardType.storeDiscount,
                  amount: 50,
                  isActive: discountService.hasActiveDiscount,
                  notificationTitle: context.translate.rewardNotificationTitle,
                  notificationMessage: context.translate
                      .rewardDiscountNotificationMessage(50),
                ),
                smallTitle: context.translate.rewardsSecondOfferTitleSmall,
                bigTitle: context.translate.rewardsSecondOfferTitleBig(50),
                description: context.translate.rewardsSecondOfferDescription(
                  50,
                ),
                rewardIcon: CustomIcons.discount,
                backgroundColor: context.colors.lightBlue,
                iconColor: context.colors.primary,
                textColor: context.colors.darkBlue,
              ),
              BlocBuilder<FreezeCubit, FreezeState>(
                builder: (context, state) {
                  return RewardsCard(
                    rewardConfig: RewardConfig(
                      type: RewardType.freeze,
                      amount: 1,
                      isActive: !state.canWatchFreeAd,
                      notAvailableUntil: state.timeUntilNextFreeAd,
                      notificationTitle:
                          context.translate.rewardNotificationTitle,
                      notificationMessage:
                          context.translate.rewardFreezeNotificationMessage,
                    ),
                    smallTitle: context.translate.rewardsThirdOfferTitleSmall,
                    bigTitle: context.translate.rewardsThirdOfferTitleBig(1),
                    description: context.translate.rewardsThirdOfferDescription(
                      1,
                    ),
                    rewardIcon: CustomIcons.freeze,
                    backgroundColor: context.colors.white,
                    iconColor: context.colors.primary,
                    textColor: context.colors.primary,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
