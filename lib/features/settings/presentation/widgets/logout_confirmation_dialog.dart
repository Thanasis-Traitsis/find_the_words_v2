import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

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
                context.translate.logoutDialogHeader,
                textType: CustomTextType.regularHeading,
              ),
              CustomText(
                context.translate.logoutDialogDescription,
                textType: CustomTextType.regularBody,
              ),
              Row(
                spacing: AppSpacing.spacingM,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: CustomOutlineButton(
                      text: context.translate.logoutDialogButtonCancel,
                      onPressed: () {
                        NavigationService.instance.pop(false);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomPrimaryButton.regular(
                      text: context.translate.logoutDialogButtonSubmit,
                      onTap: () {
                        getIt<AuthCubit>().signOut();
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
