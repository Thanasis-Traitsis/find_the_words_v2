import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';

class RewardsSection extends StatelessWidget {
  const RewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreSection(
      sectionHeader: const RewardsSectionHeader(),
      sectionContent: Column(
        spacing: AppSpacing.spacingM,
        children: [
          RewardsCard(
            smallTitle: context.translate.rewardsFirstOfferTitleSmall,
            bigTitle: context.translate.rewardsFirstOfferTitleBig(60),
            description: context.translate.rewardsFirstOfferDescription(60),
            onTap: () {},
            rewardIcon: CustomIcons.stars,
            backgroundColor: context.colors.lightPink,
            iconColor: context.colors.secondary,
            textColor: context.colors.darkPink,
          ),
          RewardsCard(
            smallTitle: context.translate.rewardsSecondOfferTitleSmall,
            bigTitle: context.translate.rewardsSecondOfferTitleBig(50),
            description: context.translate.rewardsSecondOfferDescription(50),
            onTap: () {},
            rewardIcon: CustomIcons.discount,
            backgroundColor: context.colors.lightBlue,
            iconColor: context.colors.primary,
            textColor: context.colors.darkBlue,
          ),
          RewardsCard(
            smallTitle: context.translate.rewardsThirdOfferTitleSmall,
            bigTitle: context.translate.rewardsThirdOfferTitleBig(2),
            description: context.translate.rewardsThirdOfferDescription(2),
            onTap: () {},
            rewardIcon: CustomIcons.freeze,
            backgroundColor: context.colors.white,
            iconColor: context.colors.primary,
            textColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
