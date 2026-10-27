import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/store/presentation/widgets/confirm_purchase_dialog.dart';
import 'package:flutter/material.dart';

class CustomOfferButton extends StatelessWidget {
  final int originalCost;
  final int actualCost;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool isHorizontal;
  final String? notificationTitle;
  final String? notificationMessage;

  const CustomOfferButton({
    super.key,
    required this.originalCost,
    required this.actualCost,
    required this.onTap,
    this.isDisabled = false,
    this.isHorizontal = false,
    this.notificationTitle,
    this.notificationMessage,
  });

  @override
  Widget build(BuildContext context) {
    final discountService = getIt<StoreDiscountService>();

    return ListenableBuilder(
      listenable: discountService,
      builder: (context, asyncSnapshot) {
        return Flex(
          direction: isHorizontal ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: isHorizontal
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (discountService.hasActiveDiscount)
              Container(
                margin: isHorizontal
                    ? const EdgeInsets.only(
                        right: AppSpacing.spacingM,
                        top: AppSpacing.spacingS,
                      )
                    : null,
                child: CustomText(
                  context.translate.priceBeforeDiscount(originalCost),
                  textStyle: TextStyle(
                    fontSize: isHorizontal
                        ? CustomTextType.regularBody.fontSize
                        : CustomTextType.smallTag.fontSize,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            CustomPrimaryButton.regular(
              text: actualCost.toString(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmPurchaseDialog(
                      onTap: onTap,
                      costPoints: actualCost,
                      notificationTitle: notificationTitle,
                      notificationMessage: notificationMessage,
                    );
                  },
                );
              },
              suffixIcon: CustomIcons.star,
              isDisabled: isDisabled,
            ),
          ],
        );
      },
    );
  }
}
