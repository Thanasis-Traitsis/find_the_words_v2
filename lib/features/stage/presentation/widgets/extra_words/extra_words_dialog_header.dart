import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_dialog_header.dart';
import 'package:flutter/material.dart';

class ExtraWordsDialogHeader extends StatelessWidget {
  const ExtraWordsDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StageDialogHeader(
      icon: 'box',
      headerTitle: context.translate.extraWordsDialogTitle,
      headerDescription: context.translate.extraWordsDialogSubtitle,
      borderColor: context.colors.primary,
      backgroundColor: context.colors.lightBlue,
      textColor: context.colors.darkBlue,
    );
  }
}
