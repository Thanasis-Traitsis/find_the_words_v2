import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/store/data/models/offer_card_model.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/offer_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/section_with_offer_cards.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';

class OfferSection extends StatelessWidget {
  const OfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreSection(
      sectionHeader: const OfferSectionHeader(),
      sectionContent: Column(
        spacing: AppSpacing.spacingXL,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionWithOfferCards(
            icon: CustomIcons.time,
            header: context.translate.xpMultiplierFirstOfferHeader,
            description: context.translate.xpMultiplierFirstOfferDescription,
            offerCardsList: [
              OfferCardModel(
                boostType: AccountBoostType.minutes,
                costPoints: 20,
                amount: 1,
              ),
              OfferCardModel(
                boostType: AccountBoostType.minutes,
                costPoints: 40,
                amount: 5,
              ),
              OfferCardModel(
                boostType: AccountBoostType.minutes,
                costPoints: 70,
                amount: 10,
              ),
              OfferCardModel(
                boostType: AccountBoostType.minutes,
                costPoints: 100,
                amount: 15,
              ),
            ],
          ),
          SectionWithOfferCards(
            icon: CustomIcons.stage,
            header: context.translate.xpMultiplierSecondOfferHeader,
            description: context.translate.xpMultiplierSecondOfferDescription,
            offerCardsList: [
              OfferCardModel(
                boostType: AccountBoostType.stages,
                costPoints: 20,
                amount: 1,
              ),
              OfferCardModel(
                boostType: AccountBoostType.stages,
                costPoints: 50,
                amount: 3,
              ),
              OfferCardModel(
                boostType: AccountBoostType.stages,
                costPoints: 80,
                amount: 5,
              ),
              OfferCardModel(
                boostType: AccountBoostType.stages,
                costPoints: 140,
                amount: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
