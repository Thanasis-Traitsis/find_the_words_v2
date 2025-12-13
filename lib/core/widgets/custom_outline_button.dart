import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final CustomIcons? icon;

  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingXL,
            vertical: AppSpacing.spacingM,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppBorders.regularBorderRadius),
        ),
      ),
      child: Opacity(
        opacity: isDisabled ? 0.7 : 1.0,
        child: Row(
          spacing: AppSpacing.spacingM,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CustomText(
                text,
                textType: CustomTextType.regularBody,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (icon != null)
              CustomSvgIcon(
                icon: icon!,
                color: context.colors.text,
                height: AppSizes.iconXS,
              ),
          ],
        ),
      ),
    );
  }
}
