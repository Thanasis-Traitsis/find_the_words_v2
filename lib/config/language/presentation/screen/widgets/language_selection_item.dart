import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/app_borders.dart';
import 'package:find_the_words/core/constants/app_sizes.dart';
import 'package:find_the_words/core/constants/app_spacing.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LanguageSelectionItem extends StatelessWidget {
  final bool isLast;
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageSelectionItem({
    super.key,
    required this.isLast,
    required this.language,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(
                    width: AppBorders.smallBorderWidth,
                    color: context.colors.black,
                  ),
          ),
        ),
        child: Row(
          spacing: AppSpacing.spacingL,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.iconS + 4,
              height: AppSizes.iconS,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/${language.flag}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: AppBorders.smallBorderRadius,
              ),
            ),
            Expanded(
              child: CustomText(
                "${language.displayName} (${language.code})",
                textType: CustomTextType.smallHeading,
              ),
            ),
            Opacity(
              opacity: isSelected ? 1 : 0,
              child: CustomSvgIcon(
                icon: CustomIcons.flag,
                color: context.colors.black,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
