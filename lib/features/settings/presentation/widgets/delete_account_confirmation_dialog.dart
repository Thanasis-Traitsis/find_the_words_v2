import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/confirmation_dialog.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/settings/presentation/widgets/reauthenticate_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  final BuildContext settingsContext;

  const DeleteAccountConfirmationDialog({
    super.key,
    required this.settingsContext,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      header: context.translate.deleteAccountDialogHeader,
      description: context.translate.deleteAccountDialogDescription,
      cancelTxt: context.translate.deleteAccountDialogButtonCancel,
      submitTxt: context.translate.deleteAccountDialogButtonSubmit,
      onSubmitPress: () async {
        try {
          await getIt<AuthCubit>().deleteAccount();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login' && settingsContext.mounted) {
            await showDialog(
              context: settingsContext,
              builder: (context) => const ReauthenticateDialog(),
            );
          }
        }
      },
    );
  }
}
