import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String header;
  final String description;
  final String cancelTxt;
  final String submitTxt;
  final Function onSubmitPress;

  const ConfirmationDialog({
    super.key,
    required this.header,
    required this.description,
    required this.cancelTxt,
    required this.submitTxt,
    required this.onSubmitPress,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.spacingL,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                header,
                textType: CustomTextType.regularHeading,
              ),
              CustomText(
                description,
                textType: CustomTextType.regularBody,
              ),
              Row(
                spacing: AppSpacing.spacingM,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: CustomOutlineButton(
                      text: cancelTxt,
                      onPressed: () {
                        NavigationService.instance.pop(false);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomPrimaryButton.regular(
                      text: submitTxt,
                      onTap: () {
                        onSubmitPress();
                        NavigationService.instance.pop(true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
