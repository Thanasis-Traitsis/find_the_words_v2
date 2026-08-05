import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/store/data/models/offer_card_model.dart';
import 'package:find_the_words/features/store/presentation/widgets/custom_offer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferCard extends StatelessWidget {
  final OfferCardModel offerCardModel;

  const OfferCard({super.key, required this.offerCardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBoostCubit, AccountBoostEntity?>(
      builder: (context, boost) {
        bool noActiveBoost =
            boost == null || !boost.isActive || boost.isExpired;
        bool isActive = boost != null && offerCardModel.key == boost.activeKey;

        bool hideCard = !noActiveBoost && !isActive;
        bool highlightCard = !noActiveBoost && isActive;

        return Opacity(
          opacity: hideCard ? 0.6 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingL,
              vertical: AppSpacing.spacingM,
            ),
            decoration: BoxDecoration(
              color: highlightCard
                  ? context.colors.lightGreen
                  : context.colors.lightBlue,
              borderRadius: AppBorders.regularBorderRadius,
              border: Border.all(
                width: highlightCard
                    ? AppBorders.largeBorderWidth
                    : AppBorders.smallBorderWidth,
                color: highlightCard
                    ? context.colors.darkGreen
                    : context.colors.darkBlue,
              ),
            ),
            child: Column(
              spacing: AppSpacing.spacingL,
              children: [
                Column(
                  spacing: AppSpacing.spacingS,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      offerCardModel.amount.toString(),
                      textType: CustomTextType.bigHeading,
                    ),
                    CustomText(
                      offerCardModel.boostType.subtitle(
                        context,
                        offerCardModel.amount,
                      ),
                      textType: CustomTextType.regularHeading,
                    ),
                  ],
                ),
                highlightCard
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingM,
                          horizontal: AppSpacing.spacingL,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.darkGreen,
                          borderRadius: AppBorders.regularBorderRadius,
                        ),
                        child: CustomText(
                          context.translate.rewardActiveCard,
                          textType: CustomTextType.smallTag,
                          isWhite: true,
                        ),
                      )
                    : BlocBuilder<PointsCubit, int>(
                        builder: (context, currentPoints) {
                          return CustomOfferButton(
                            originalCost: offerCardModel.originalCostPoints,
                            actualCost: offerCardModel.getActualCost(),
                            onTap: () {
                              getIt<AccountBoostCubit>().activate(
                                activeKey: offerCardModel.key,
                                type: offerCardModel.boostType,
                                amount: offerCardModel.amount,
                                pointsCubit: getIt<PointsCubit>(),
                                points: offerCardModel.getActualCost(),
                              );
                            },
                            isDisabled:
                                hideCard ||
                                currentPoints < offerCardModel.getActualCost(),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
