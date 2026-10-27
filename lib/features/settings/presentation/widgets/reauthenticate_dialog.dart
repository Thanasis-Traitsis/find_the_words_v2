import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/confirmation_dialog.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class ReauthenticateDialog extends StatelessWidget {
  const ReauthenticateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      header: context.translate.reauthenticateDialogHeader,
      description: context.translate.reauthenticateDialogDescription,
      cancelTxt: context.translate.reauthenticateDialogButtonCancel,
      submitTxt: context.translate.reauthenticateDialogButtonSubmit,
      onSubmitPress: () async {        
        await getIt<AuthCubit>().reauthenticateAndDeleteAccount();
      },
    );
  }
}