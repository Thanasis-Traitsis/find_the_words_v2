import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_game_dialog.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_dialog_header.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_list_item.dart';
import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGameDialog(
      headerWidget: const HelpDialogHeader(),
      contentWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelpListItem.free(
            icon: CustomIcons.shuffle,
            helpTitle: context.translate.helpDialogShuffleTitle,
            helpDescription: context.translate.helpDialogShuffleDescription,
          ),
          HelpListItem(
            points: 10,
            icon: CustomIcons.magicWand,
            helpTitle: context.translate.helpDialogRandomLetterTitle,
            helpDescription:
                context.translate.helpDialogRandomLetterDescription,
          ),
          HelpListItem(
            points: 25,
            icon: CustomIcons.target,
            helpTitle: context.translate.helpDialogSpecificLetterTitle,
            helpDescription:
                context.translate.helpDialogSpecificLetterDescription,
          ),
        ],
      ),
    );
  }
}
