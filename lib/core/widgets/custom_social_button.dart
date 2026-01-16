import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final CustomIcons social;

  const CustomSocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    required this.social,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingXL,
            vertical: AppSpacing.spacingL,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppBorders.regularBorderRadius),
        ),
      ),
      child: Opacity(
        opacity: isDisabled ? 0.7 : 1.0,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.iconM,
                height: AppSizes.iconM,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/${social.fileName}.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: CustomText(
                  text,
                  textType: CustomTextType.smallHeading,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
