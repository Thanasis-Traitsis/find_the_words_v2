import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool withIcon;
  final bool isDisabled;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
    this.withIcon = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: isDisabled
              ? WidgetStateProperty.all(Colors.grey)
              : WidgetStateProperty.all(context.colors.primary),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingXL,
              vertical: AppSpacing.spacingL,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: AppBorders.bigBorderRadius),
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (withIcon)
              Opacity(
                opacity: 0,
                child: CustomSvgIcon(
                  icon: 'arrow_right',
                  color: context.colors.white,
                  height: AppSizes.iconS,
                ),
              ),
            withIcon
                ? Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingM,
                      ),
                      child: CustomText(
                        text,
                        textType: CustomTextType.smallHeading,
                        isWhite: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingM,
                    ),
                    child: CustomText(
                      text,
                      textType: CustomTextType.smallHeading,
                      isWhite: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
            if (withIcon)
              CustomSvgIcon(
                icon: 'arrow_right',
                color: context.colors.white,
                height: AppSizes.iconS,
              ),
          ],
        ),
      ),
    );
  }
}
