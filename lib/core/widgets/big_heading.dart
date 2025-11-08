import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/widgets/custom_icon_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BigHeading extends StatelessWidget {
  final String pageTitle;
  final VoidCallback? onBackButtonPressed;

  const BigHeading({
    super.key,
    required this.pageTitle,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIconButton(
            onTap:
                onBackButtonPressed ??
                () {
                  NavigationService.instance.pop();
                },
            icon: 'arrow_left',
          ),
          CustomText(pageTitle, textType: CustomTextType.bigHeading),
        ],
      ),
    );
  }
}
