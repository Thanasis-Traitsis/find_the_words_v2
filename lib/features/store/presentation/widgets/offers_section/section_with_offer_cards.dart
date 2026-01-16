import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/store/data/models/offer_card_model.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/offer_card.dart';
import 'package:flutter/material.dart';

class SectionWithOfferCards extends StatelessWidget {
  final String header;
  final String description;
  final List<OfferCardModel> offerCardsList;
  final CustomIcons icon;

  const SectionWithOfferCards({
    super.key,
    required this.header,
    required this.description,
    required this.offerCardsList,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingL,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          spacing: AppSpacing.spacingM,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.spacingM,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomSvgIcon(
                  icon: icon,
                  color: context.colors.text,
                  height: AppSizes.iconM,
                ),
                Expanded(child: CustomText(header, textType: CustomTextType.smallHeading)),
              ],
            ),
            CustomText(description, textType: CustomTextType.regularBody),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              spacing: AppSpacing.spacingM,
              children: List.generate(offerCardsList.length, (index) {
                return OfferCard(
                  offerCardModel: OfferCardModel(
                    key: offerCardsList[index].key,
                    boostType: offerCardsList[index].boostType,
                    originalCostPoints: offerCardsList[index].originalCostPoints,
                    amount: offerCardsList[index].amount,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
