import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/snackbar_helper.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ConfirmPurchaseDialog extends StatelessWidget {
  final int costPoints;
  final VoidCallback onTap;
  final String? notificationTitle;
  final String? notificationMessage;

  const ConfirmPurchaseDialog({
    super.key,
    required this.onTap,
    required this.costPoints,
    this.notificationTitle,
    this.notificationMessage,
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
                context.translate.confirmPurchaseDialogTitle,
                textType: CustomTextType.regularHeading,
              ),
              CustomText(
                context.translate.confirmPurchaseDialogDescription(costPoints),
                textType: CustomTextType.regularBody,
              ),
              Row(
                spacing: AppSpacing.spacingM,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: CustomOutlineButton(
                      text: context.translate.confirmPurchaseDialogCancelButton,
                      onPressed: () {
                        NavigationService.instance.pop();
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomPrimaryButton.regular(
                      text:
                          context.translate.confirmPurchaseDialogConfirmButton,
                      onTap: () {
                        onTap();
                        NavigationService.instance.pop();

                        if (notificationTitle != null ||
                            notificationMessage != null) {
                          SnackbarHelper.showSuccessSnackbar(
                            context,
                            title: notificationTitle,
                            message: notificationMessage,
                          );
                        }
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
