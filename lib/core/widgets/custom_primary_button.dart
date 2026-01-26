import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;
  final CustomTextType type;
  final CustomIcons? suffixIcon;
  final CustomIcons? prefixIcon;
  final double iconSize;
  final bool fullWidth;
  final double spacing;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool isLoading;

  const CustomPrimaryButton.small({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.type = CustomTextType.smallBody,
    this.suffixIcon,
    this.prefixIcon,
    this.iconSize = AppSizes.iconXXS,
    this.fullWidth = false,
    this.spacing = AppSpacing.spacingM,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.spacingM,
      vertical: AppSpacing.spacingXS,
    ),
    this.borderRadius = AppBorders.regularBorderRadiusConst,
    this.isLoading = false,
  });

  const CustomPrimaryButton.regular({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.type = CustomTextType.regularBody,
    this.suffixIcon,
    this.prefixIcon,
    this.iconSize = AppSizes.iconXS,
    this.fullWidth = false,
    this.spacing = AppSpacing.spacingM,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.spacingL,
      vertical: AppSpacing.spacingM,
    ),
    this.borderRadius = AppBorders.regularBorderRadiusConst,
    this.isLoading = false,
  });

  const CustomPrimaryButton.large({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.type = CustomTextType.bigBody,
    this.suffixIcon,
    this.prefixIcon,
    this.iconSize = AppSizes.iconS,
    this.fullWidth = false,
    this.spacing = AppSpacing.spacingL,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.spacingXL,
      vertical: AppSpacing.spacingL,
    ),
    this.borderRadius = AppBorders.bigBorderRadiusConst,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isDisabled ? null : onTap,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(padding),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDisabled ? 0.7 : 1.0,
        child: Stack(
          children: [
            Opacity(
              opacity: isLoading ? 0.0 : 1.0,
              child: Row(
                spacing: spacing,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (prefixIcon != null)
                    CustomSvgIcon(
                      icon: prefixIcon!,
                      color: context.colors.white,
                      height: iconSize,
                    ),
                  if (prefixIcon == null && suffixIcon != null && fullWidth)
                    Opacity(
                      opacity: 0.0,
                      child: CustomSvgIcon(
                        icon: suffixIcon!,
                        color: context.colors.white,
                        height: iconSize,
                      ),
                    ),
                  Flexible(
                    child: CustomText(
                      text,
                      textStyle: TextStyle(
                        fontSize: type.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      isWhite: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (suffixIcon == null && prefixIcon != null && fullWidth)
                    Opacity(
                      opacity: 0.0,
                      child: CustomSvgIcon(
                        icon: prefixIcon!,
                        color: context.colors.white,
                        height: iconSize,
                      ),
                    ),
                  if (suffixIcon != null)
                    CustomSvgIcon(
                      icon: suffixIcon!,
                      color: context.colors.white,
                      height: iconSize,
                    ),
                ],
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: isLoading ? 1.0 : 0.0,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator.adaptive(backgroundColor: context.colors.white,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
