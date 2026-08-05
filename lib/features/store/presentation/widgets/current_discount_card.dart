import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/store/presentation/helper/current_boost_helper.dart';
import 'package:flutter/material.dart';

class CurrentDiscountCard extends StatelessWidget {
  const CurrentDiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final discountService = getIt<StoreDiscountService>();

    return ListenableBuilder(
      listenable: discountService,
      builder: (context, asyncSnapshot) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !discountService.hasActiveDiscount
              ? const SizedBox.shrink()
              : StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return _buildTag(context, discountService);
                  },
                ),
        );
      },
    );
  }

  Widget _buildTag(BuildContext context, StoreDiscountService discountService) {
    final int discountPercentage = discountService.discountPercentage;
    final remainingTime = discountService.getRemainingTime();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppSpacing.spacingXL),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.spacingM,
            horizontal: AppSpacing.spacingL,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.lightBlue,
            borderRadius: AppBorders.bigBorderRadius,
            border: Border.all(
              width: AppBorders.mediumBorderWidth,
              color: context.colors.darkBlue,
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: AppSpacing.spacingM,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      context.translate.currentDiscountHeader,
                      textType: CustomTextType.smallHeading,
                    ),
                    CustomText(
                      context.translate.currentDiscountDescription(discountPercentage),
                      textType: CustomTextType.regularBody,
                    ),
                    CustomText(
                      CurrentBoostHelper.formatDurationWithHours(remainingTime),
                      textType: CustomTextType.bigHeading,
                      isItalic: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacingM),
                decoration: BoxDecoration(
                  borderRadius: AppBorders.regularBorderRadius,
                  border: Border.all(
                    width: AppBorders.smallBorderWidth,
                    color: context.colors.darkBlue,
                  ),
                ),
                child: CustomText(
                  "$discountPercentage%",
                  textType: CustomTextType.smallHeading,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -AppSpacing.spacingL,
          right: AppSpacing.spacingL,
          child: CustomSvgIcon(
            icon: CustomIcons.discount,
            color: context.colors.darkGreen.withValues(alpha: 0.05),
            height: AppSizes.currentBoosIcon,
          ),
        ),
      ],
    );
  }
}
