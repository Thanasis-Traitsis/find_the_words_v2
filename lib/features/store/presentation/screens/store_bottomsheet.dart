import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/core/widgets/points_container.dart';
import 'package:find_the_words/features/store/presentation/widgets/current_boost_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/current_discount_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/freeze_section/freeze_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/offer_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section.dart';
import 'package:flutter/material.dart';

class StoreBottomsheet extends StatelessWidget {
  const StoreBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      prefixIcon: CustomIcons.store,
      headerTitle: context.translate.storeBottomsheetTitle,
      suffixWidget: const PointsContainer(withVoidCallback: false,),
      bottomsheetContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            context.translate.storeBottomsheetDescription,
            textType: CustomTextType.regularBody,
          ),
          const CurrentDiscountCard(),
          const CurrentBoostCard(),
          const OfferSection(),
          const FreezeSection(),
          const RewardsSection(),
        ],
      ),
    );
  }
}
