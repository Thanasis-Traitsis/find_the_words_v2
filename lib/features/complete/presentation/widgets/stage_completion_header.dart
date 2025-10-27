import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageCompletionHeader extends StatelessWidget {
  final String stageNumber;
  const StageCompletionHeader({super.key, required this.stageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.spacingXL),
      child: Column(
        spacing: AppSpacing.spacingS,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                context.translate.completeStageTitle,
                textType: CustomTextType.bigHeading,
              ),
              CustomText(
                stageNumber,
                textType: CustomTextType.bigHeading,
              ),
            ],
          ),
          CustomText(
            context.translate.completeStageSubtitle,
            textType: CustomTextType.bigHeading,
          ),
        ],
      ),
    );
  }
}
