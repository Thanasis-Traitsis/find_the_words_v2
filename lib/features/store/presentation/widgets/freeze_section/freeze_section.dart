import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/store/presentation/widgets/custom_offer_button.dart';
import 'package:find_the_words/features/store/presentation/widgets/freeze_section/freeze_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FreezeSection extends StatelessWidget {
  const FreezeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final discountService = getIt<StoreDiscountService>();
    final int freezeCost = 30;

    return ListenableBuilder(
      listenable: discountService,
      builder: (context, asyncSnapshot) {
        return StoreSection(
          sectionHeader: const FreezeSectionHeader(),
          sectionContent: Container(
            alignment: Alignment.centerRight,
            child: BlocBuilder<PointsCubit, int>(
              builder: (context, statePoints) {
                final int actualCost = discountService.getDiscountedPrice(
                  freezeCost,
                );

                return CustomOfferButton(
                  originalCost: freezeCost,
                  actualCost: actualCost,
                  onTap: () {
                    getIt<FreezeCubit>().incrementTotalFreezes(1);
                    getIt<PointsCubit>().deductPoints(actualCost);
                  },
                  isHorizontal: true,
                  isDisabled:
                      statePoints <
                      discountService.getDiscountedPrice(freezeCost),
                      notificationTitle: context.translate.purchaseSnackbarTitle,
                      notificationMessage: context.translate.purchaseFreezeSnackbarMessage
                );
              },
            ),
          ),
        );
      },
    );
  }
}
