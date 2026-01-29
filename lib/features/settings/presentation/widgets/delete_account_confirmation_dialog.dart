import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/confirmation_dialog.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      header: context.translate.deleteAccountDialogHeader,
      description: context.translate.deleteAccountDialogDescription,
      cancelTxt: context.translate.deleteAccountDialogButtonCancel,
      submitTxt: context.translate.deleteAccountDialogButtonSubmit,
      onSubmitPress: () {
        getIt<AuthCubit>().deleteAccount();
      },
    );
  }
}
