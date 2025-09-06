import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_border_container.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/home/presentation/widgets/card_icon_container.dart';
import 'package:flutter/material.dart';

class TotalWordsCard extends StatelessWidget {
  final int wordsListLength;

  const TotalWordsCard({super.key, required this.wordsListLength});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CustomBorderContainer(
        backgroundColor: context.colors.lightBlue,
        borderColor: context.colors.darkBlue,
        child: IntrinsicHeight(
          child: Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardIconContainer(
                backgroundColor: context.colors.primary,
                icon: 'list',
              ),
              Expanded(
                child: Column(
                  spacing: AppSpacing.spacingS,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      wordsListLength.toString(),
                      textType: CustomTextType.regularHeading,
                    ),
                    CustomText(
                      context.translate.totalWordsCardDescription,
                      textType: CustomTextType.regularBody,
                    ),
                  ],
                ),
              ),
              CustomSvgIcon(
                icon: 'arrow_right',
                color: context.colors.darkBlue,
                height: AppSizes.suffixContainerIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
