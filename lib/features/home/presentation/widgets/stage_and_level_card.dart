import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_border_container.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/home/presentation/widgets/level_progress_bar.dart';
import 'package:flutter/material.dart';

class StageAndLevelCard extends StatelessWidget {
  final ProfileStatusModel profileStatus;
  final bool withStage;
  final int? xpEarned;

  const StageAndLevelCard({
    super.key,
    required this.profileStatus,
    this.withStage = true,
    this.xpEarned,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBorderContainer(
      backgroundColor: context.colors.lightGreen,
      borderColor: context.colors.darkGreen,
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
                children: [
                  if (xpEarned != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingM,
                          horizontal: AppSpacing.spacingL,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.darkGreen,
                          borderRadius: AppBorders.hugeBorderRadius,
                        ),
                        child: CustomText(
                          '+ $xpEarned XP',
                          textType: CustomTextType.smallTag,
                          isWhite: true,
                        ),
                      ),
                    ),
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
                                context.translate.levelWithNumber(
                                  profileStatus.level,
                                ),
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
                          '${profileStatus.progress}%',
                          textType: CustomTextType.regularHeading,
                          isItalic: true,
                        ),
                      ],
                    ),
                  ),
                  LevelProgressBar(progress: profileStatus.progress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
