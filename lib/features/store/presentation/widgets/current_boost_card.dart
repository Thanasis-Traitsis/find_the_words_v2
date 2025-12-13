import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/active_boost_tag.dart';
import 'package:find_the_words/core/widgets/boost_multiplier_tag.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:find_the_words/features/store/presentation/helper/current_boost_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentBoostCard extends StatelessWidget {
  const CurrentBoostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBoostCubit, AccountBoostEntity?>(
      builder: (context, boost) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: (boost == null || !boost.isActive || boost.isExpired)
              ? const SizedBox.shrink()
              : boost.type == AccountBoostType.minutes
              ? StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return _buildTag(context, boost);
                  },
                )
              : _buildTag(context, boost),
        );
      },
    );
  }

  Widget _buildTag(BuildContext context, AccountBoostEntity boost) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.spacingM,
            horizontal: AppSpacing.spacingL,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.lightGreen,
            borderRadius: AppBorders.bigBorderRadius,
            border: Border.all(
              width: AppBorders.mediumBorderWidth,
              color: context.colors.black,
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
                    const ActiveBoostTag(),
                    CustomText(
                      context.translate.currentBoostXpMultiplierHeader,
                      textType: CustomTextType.smallHeading,
                    ),
                    Row(
                      spacing: AppSpacing.spacingM,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          CurrentBoostHelper.getFormattedBoost(boost),
                          textType: CustomTextType.bigHeading,
                          isItalic: true,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: AppSpacing.spacingXS,
                              ),
                              child: CustomText(
                                CurrentBoostHelper.getFormattedSubtitle(
                                  boost,
                                  context,
                                ),
                                textType: CustomTextType.regularBody,
                              ),
                            ),
                            CustomText(
                              context.translate
                                  .currentBoostXpMultiplierSubtitle2(
                                    boost.totalAmount,
                                  ),
                              textType: CustomTextType.regularBody,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BoostMultiplierTag(multiplier: boost.multiplier)
            ],
          ),
        ),
        Positioned(
          bottom: -AppSpacing.spacingL,
          right: AppSpacing.spacingL,
          child: CustomSvgIcon(
            icon: CustomIcons.stage,
            color: context.colors.darkGreen.withValues(alpha: 0.05),
            height: AppSizes.currentBoosIcon,
          ),
        ),
      ],
    );
  }
}
