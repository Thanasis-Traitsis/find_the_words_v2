import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/screen_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_icon_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomBottomsheet extends StatelessWidget {
  final String headerTitle;
  final Widget bottomsheetContent;
  final Widget? bottomFixedWidget;

  const CustomBottomsheet({
    super.key,
    required this.headerTitle,
    required this.bottomsheetContent,
    this.bottomFixedWidget,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.spacingL),
                    child: Row(
                      spacing: AppSpacing.spacingM,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          headerTitle,
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
