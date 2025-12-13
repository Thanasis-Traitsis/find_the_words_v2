import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:flutter/material.dart';

class SelectLanguageItem extends StatelessWidget {
  final ProfileStatusModel langStatus;
  final AppLanguage lang;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectLanguageItem({
    super.key,
    required this.langStatus,
    required this.isSelected,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: AppBorders.smallBorderWidth,
                color: context.colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingL,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: isSelected ? 1 : 0,
                child: Container(
                  margin: const EdgeInsets.only(left: AppSpacing.spacingM),
                  child: CustomSvgIcon(
                    icon: CustomIcons.flag,
                    color: context.colors.black,
                    height: 20,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  spacing: AppSpacing.spacingM,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      '${lang.displayName} (${lang.code})',
                      textType: CustomTextType.smallHeading,
                    ),
                    Row(
                      spacing: AppSpacing.spacingM,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            '${context.translate.level}: ${langStatus.level}',
                            textType: CustomTextType.regularBody,
                          ),
                        ),
                        CustomText(
                          '${context.translate.stage}: ${langStatus.stage}',
                          textType: CustomTextType.regularBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
