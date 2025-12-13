import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_border_container.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/home/presentation/widgets/card_icon_container.dart';
import 'package:flutter/material.dart';

class TotalWordsCard extends StatelessWidget {
  final WordsModel wordsModel;

  const TotalWordsCard({super.key, required this.wordsModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppPages.words.push(extra: wordsModel);
      },
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
                icon: CustomIcons.list,
              ),
              Expanded(
                child: Column(
                  spacing: AppSpacing.spacingS,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      wordsModel.words.length.toString(),
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
                icon: CustomIcons.arrowRight,
                color: context.colors.darkBlue,
                height: AppSizes.iconS,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
