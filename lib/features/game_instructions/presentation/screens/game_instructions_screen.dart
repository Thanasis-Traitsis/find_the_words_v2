import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/game_instructions/presentation/widgets/rules_section.dart';
import 'package:flutter/material.dart';

class GameInstructionsScreen extends StatelessWidget {
  const GameInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
          child: Column(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigHeading(
                pageTitle: context.translate.gameInstructionsScreenName,
              ),
              RulesSection(
                icon: CustomIcons.questionmark,
                title: context.translate.gameRulesTitle1,
                content: [context.translate.gameRulesContent1],
              ),
              RulesSection(
                icon: CustomIcons.rules,
                title: context.translate.gameRulesTitle2,
                content: [
                  context.translate.gameRulesContent2a,
                  context.translate.gameRulesContent2b,
                  context.translate.gameRulesContent2c,
                ],
                subContent: [
                  context.translate.gameRulesSubcontent2a,
                  context.translate.gameRulesSubcontent2b,
                  context.translate.gameRulesSubcontent2c,
                ],
              ),
              RulesSection(
                icon: CustomIcons.tips,
                title: context.translate.gameRulesTitle3,
                content: [
                  context.translate.gameRulesContent3a,
                  context.translate.gameRulesContent3b,
                  context.translate.gameRulesContent3c,
                ],
              ),
              RulesSection(
                icon: CustomIcons.stars,
                title: context.translate.gameRulesTitle4,
                content: [context.translate.gameRulesContent4],
              ),
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.spacingM),
                child: CustomText(
                  context.translate.gameRulesTitle5,
                  textType: CustomTextType.regularHeading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
