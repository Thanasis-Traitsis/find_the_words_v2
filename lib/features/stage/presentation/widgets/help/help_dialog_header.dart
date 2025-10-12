import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_dialog_header.dart';
import 'package:flutter/material.dart';

class HelpDialogHeader extends StatelessWidget {
  const HelpDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StageDialogHeader(
      icon: 'help',
      headerTitle: context.translate.helpDialogTitle,
      headerDescription: context.translate.helpDialogSubtitle,
      borderColor: context.colors.secondary,
      backgroundColor: context.colors.lightPink,
      textColor: context.colors.darkPink,
    );
  }
}
