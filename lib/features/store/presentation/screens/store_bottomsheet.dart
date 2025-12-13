import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/store/presentation/widgets/current_boost_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/freeze_section/freeze_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/offer_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_points_widget.dart';
import 'package:flutter/material.dart';

class StoreBottomsheet extends StatelessWidget {
  const StoreBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      prefixIcon: CustomIcons.store,
      headerTitle: context.translate.storeBottomsheetTitle,
      suffixWidget: const StorePointsWidget(),
      bottomsheetContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.spacingXL,
        children: [
          CustomText(
            context.translate.storeBottomsheetDescription,
            textType: CustomTextType.regularBody,
          ),
          const CurrentBoostCard(),
          const OfferSection(),
          const FreezeSection(),
          const RewardsSection(),
        ],
      ),
    );
  }
}
