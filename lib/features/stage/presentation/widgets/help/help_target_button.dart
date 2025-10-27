import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';

class HelpTargetButton extends StatelessWidget {
  final GlobalKey descriptionKey;
  final GlobalKey buttonKey;
  final bool isActive;
  final VoidCallback onTap;

  const HelpTargetButton({
    super.key,
    required this.descriptionKey,
    required this.buttonKey,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isActive)
          Positioned(
            key: descriptionKey,
            bottom: AppSpacing.targetHelpBottomSpacing,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM, horizontal: AppSpacing.spacingL),
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: AppBorders.regularBorderRadius,
              ),
              child: CustomText(
                context.translate.helpSpecificLetterActive,
                textType: CustomTextType.regularBody,
              ),
            ),
          ),
        StageIconButton(
          key: buttonKey,
          icon: isActive ? 'close' : 'target',
          onTap: onTap,
        ),
      ],
    );
  }
}
