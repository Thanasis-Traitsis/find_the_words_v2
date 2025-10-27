import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/data/models/stage_difficulty.dart';
import 'package:flutter/material.dart';

class StageDataListItem extends StatelessWidget {
  final String title;
  final String? value;
  final StageDifficulty? difficulty;
  final bool isPoints;

  const StageDataListItem({
    super.key,
    required this.title,
    required this.value,
    this.isPoints = false,
  }) : difficulty = null;

  const StageDataListItem.withDifficulty({
    super.key,
    required this.title,
    required this.difficulty,
  }) : value = null,
       isPoints = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingS),
      child: Row(
        spacing: AppSpacing.spacingL,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title, textType: CustomTextType.regularBody),
          value != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacingS,
                  ),
                  child: CustomText(
                    isPoints ? "+ $value" : value!,
                    textType: CustomTextType.smallHeading,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingM,
                    vertical: AppSpacing.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: difficulty!.getBackgroundColor(context),
                    borderRadius: AppBorders.bigBorderRadius,
                    border: Border.all(
                      width: AppBorders.smallBorderWidth,
                      color: context.colors.black,
                    ),
                  ),
                  child: CustomText(
                    difficulty!.getValue(context),
                    textStyle: TextStyle(
                      color: difficulty!.getTextColor(context),
                      fontSize: CustomTextType.smallTag.fontSize,
                      fontWeight: CustomTextType.smallTag.fontWeight,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
