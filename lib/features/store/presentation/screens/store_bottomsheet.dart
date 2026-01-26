import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/string_extensions.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/core/widgets/points_container.dart';
import 'package:find_the_words/features/store/presentation/widgets/current_boost_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/current_discount_card.dart';
import 'package:find_the_words/features/store/presentation/widgets/freeze_section/freeze_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/offers_section/offer_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section.dart';
import 'package:find_the_words/features/store/presentation/widgets/rewards_section/rewards_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreBottomsheet extends StatelessWidget {
  const StoreBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      prefixIcon: CustomIcons.store,
      headerTitle: context.translate.storeBottomsheetTitle,
      suffixWidget: const PointsContainer(withVoidCallback: false),
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
          BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivityState) {
              final hasInternet = connectivityState is ConnectivityOnline;
              if (hasInternet) return const RewardsSection();

              return StoreSection(
                sectionHeader: const RewardsSectionHeader(),
                sectionContent: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacingL),
                  decoration: BoxDecoration(
                    color: context.colors.text.withValues(alpha: 0.1),
                    borderRadius: AppBorders.regularBorderRadius,
                    border: Border.all(
                      width: AppBorders.smallBorderWidth,
                      color: context.colors.black,
                    ),
                  ),
                  child: Row(
                    spacing: AppSpacing.spacingM,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSvgIcon(
                        icon: CustomIcons.noWifi,
                        color: context.colors.text,
                        height: AppSizes.iconM,
                      ),
                      Expanded(
                        child: Column(
                          spacing: AppSpacing.spacingS,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              context.translate.noWifiNotificationTitle
                                  .toUpperCaseGreek(),
                              textType: CustomTextType.smallHeading,
                            ),
                            CustomText(
                              context.translate.noWifiRewardsSectionDescription,
                              textType: CustomTextType.regularBody,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
