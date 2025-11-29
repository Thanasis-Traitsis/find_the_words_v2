import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/settings/presentation/widgets/reset_stage_dialog.dart';
import 'package:flutter/material.dart';

class ResetStageBottomsheet extends StatelessWidget {
  const ResetStageBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      headerTitle: context.translate.settingsItemResetStage,
      bottomsheetContent: Column(
        spacing: AppSpacing.spacingL,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            context.translate.settingsResetStageBottomsheetDescription,
            textType: CustomTextType.regularBody,
          ),
          CustomPrimaryButton.large(
            fullWidth: true,
            text: context.translate.settingsResetStageBottomsheetRestartButton,
            onTap: () async {
              final resetConfirmed = await showDialog(
                context: context,
                builder: (context) => const ResetStageDialog(),
              );

              if (resetConfirmed) {
                NavigationService.instance.pop(true);
              }
            },
            suffixIcon: 'reset',
          ),
        ],
      ),
    );
  }
}
