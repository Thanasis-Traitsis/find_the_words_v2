import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StageIconButton extends StatelessWidget {
  final String icon;
  final String? text;

  const StageIconButton({super.key, required this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: context.colors.stageBlue.withValues(alpha: 0.8),
        borderRadius: AppBorders.regularBorderRadius,
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.iconButtonPadding),
          decoration: BoxDecoration(
            borderRadius: AppBorders.regularBorderRadius,
            border: Border.all(
              width: AppBorders.mediumBorderWidth,
              color: context.colors.black,
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingM,
            children: [
              CustomSvgIcon(
                icon: icon,
                color: context.colors.black,
                height: 18,
              ),
              if (text != null)
                CustomText(text!, textType: CustomTextType.regularBody),
            ],
          ),
        ),
      ),
    );
  }
}
