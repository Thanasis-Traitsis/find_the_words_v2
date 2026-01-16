import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/screen_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_icon_button.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomBottomsheet extends StatelessWidget {
  final String headerTitle;
  final Widget bottomsheetContent;
  final Widget? bottomFixedWidget;
  final CustomIcons? prefixIcon;
  final Widget? suffixWidget;

  const CustomBottomsheet({
    super.key,
    required this.headerTitle,
    required this.bottomsheetContent,
    this.bottomFixedWidget,
    this.prefixIcon,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 8,
                    margin: const EdgeInsets.only(bottom: AppSpacing.spacingS),
                    decoration: BoxDecoration(
                      color: context.colors.text.withValues(alpha: 0.2),
                      borderRadius: AppBorders.bigBorderRadius,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.spacingL),
                    child: Row(
                      spacing: AppSpacing.spacingM,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            spacing: AppSpacing.spacingM,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (prefixIcon != null)
                                CustomSvgIcon(
                                  icon: prefixIcon!,
                                  color: context.colors.text,
                                  height: AppSizes.iconL,
                                ),
                              Expanded(
                                child: CustomText(
                                  headerTitle,
                                  textType: CustomTextType.regularHeading,
                                ),
                              ),
                            ],
                          ),
                        ),
                        suffixWidget != null
                            ? suffixWidget!
                            : CustomIconButton(
                                onTap: () {
                                  NavigationService.instance.pop();
                                },
                                icon: CustomIcons.close,
                              ),
                      ],
                    ),
                  ),
                  bottomsheetContent,
                ],
              ),
            ),
          ),
        ),
        if (bottomFixedWidget != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: AppSpacing.screenPadding,
            child: SafeArea(child: bottomFixedWidget!),
          ),
      ],
    );
  }
}
