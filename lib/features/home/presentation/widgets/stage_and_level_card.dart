import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/double_extensions.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/active_boost_tag.dart';
import 'package:find_the_words/core/widgets/custom_border_container.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/home/presentation/widgets/level_progress_bar.dart';
import 'package:find_the_words/features/home/presentation/widgets/level_up_tag.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:flutter/material.dart';

class StageAndLevelCard extends StatelessWidget {
  final ProfileStatusModel profileStatus;
  final bool withStage;
  final StageResults? stageResults;

  const StageAndLevelCard({
    super.key,
    required this.profileStatus,
    this.withStage = true,
    this.stageResults,
  });

  @override
  Widget build(BuildContext context) {
    final int level = stageResults != null
        ? stageResults!.level
        : profileStatus.level;

    final double progress = stageResults != null
        ? stageResults!.newProgress
        : profileStatus.progress;

    return CustomBorderContainer(
      backgroundColor: context.colors.lightGreen,
      borderColor: context.colors.darkGreen,
      withTopSpacing: stageResults == null,
      child: IntrinsicHeight(
        child: Row(
          spacing: AppSpacing.spacingM,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (withStage)
              Row(
                spacing: AppSpacing.spacingM,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    spacing: AppSpacing.spacingS,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        profileStatus.stage.toString(),
                        textType: CustomTextType.bigHeading,
                      ),
                      CustomText(
                        context.translate.stage,
                        textType: CustomTextType.smallBody,
                      ),
                    ],
                  ),
                  Container(color: context.colors.darkGreen, width: 1),
                ],
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (stageResults != null)
                    Row(
                      spacing: AppSpacing.spacingM,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (stageResults!.level != profileStatus.level)
                          const LevelUpTag(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.spacingM,
                            horizontal: AppSpacing.spacingL,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.darkGreen,
                            borderRadius: AppBorders.hugeBorderRadius,
                          ),
                          child: CustomText(
                            '+ ${stageResults!.xpEarned} XP',
                            textType: CustomTextType.smallTag,
                            isWhite: true,
                          ),
                        ),
                      ],
                    ),
                  if (stageResults == null)
                    const ActiveBoostTag(withData: true),
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.spacingL),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: AppSpacing.spacingS,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                context.translate.levelWithNumber(level),
                                textType: CustomTextType.smallHeading,
                              ),
                              CustomText(
                                context.translate.stageAndLevelCardDescription,
                                textType: CustomTextType.smallBody,
                              ),
                            ],
                          ),
                        ),
                        CustomText(
                          '${progress.toProgressString()}%',
                          textType: CustomTextType.regularHeading,
                          isItalic: true,
                        ),
                      ],
                    ),
                  ),
                  LevelProgressBar(
                    progress: profileStatus.progress,
                    stageResults: stageResults,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
