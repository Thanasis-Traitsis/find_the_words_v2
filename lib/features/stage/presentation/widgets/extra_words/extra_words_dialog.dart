import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_game_dialog.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/extra_words/extra_words_dialog_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtraWordsDialog extends StatelessWidget {
  const ExtraWordsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGameDialog(
      headerWidget: const ExtraWordsDialogHeader(),
      contentWidget: BlocBuilder<StageBloc, StageState>(
        builder: (context, state) {
          if (state is! StageActive) return const SizedBox.shrink();

          final extraWords = state.stage.placementTracker.extraWords;

          return Column(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (extraWords.isEmpty)
                CustomText(
                  context.translate.extraWordsDialogEmpty,
                  textType: CustomTextType.bigBody,
                ),
              ...extraWords.map(
                (word) => CustomText(
                  '• $word',
                  textType: CustomTextType.smallHeading,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
