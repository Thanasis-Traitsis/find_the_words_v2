import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:flutter/material.dart';

class GameInstructionsScreen extends StatelessWidget {
  const GameInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BigHeading(pageTitle: context.translate.gameInstructionsScreenName),
            ],
          ),
        ),
      ),
    );
  }
}
