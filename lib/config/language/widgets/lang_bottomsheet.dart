import 'package:find_the_words/config/language/widgets/info_container.dart';
import 'package:find_the_words/config/language/widgets/select_language_list.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/screen_extensions.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_icon_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LangBottomsheet extends StatelessWidget {
  const LangBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.85),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.spacingL),
                child: Row(
                  spacing: AppSpacing.spacingM,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      context.translate.languageBottomsheetTitle,
                      textType: CustomTextType.regularHeading,
                    ),
                    CustomIconButton(
                      onTap: () {
                        NavigationService.instance.pop();
                      },
                      icon: 'close',
                    ),
                  ],
                ),
              ),
              const InfoContainer(),
              Container(
                width: double.infinity,
                height: AppBorders.smallBorderWidth,
                color: context.colors.black.withValues(alpha: 0.6),
              ),
              const SelectLanguageList(),
            ],
          ),
        ),
      ),
    );
  }
}
