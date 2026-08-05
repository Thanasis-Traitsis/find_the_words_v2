import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/confirmation_dialog.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      header: context.translate.logoutDialogHeader,
      description: context.translate.logoutDialogDescription,
      cancelTxt: context.translate.logoutDialogButtonCancel,
      submitTxt: context.translate.logoutDialogButtonSubmit,
      onSubmitPress: () => getIt<AuthCubit>().signOut(),
    );
  }
}
