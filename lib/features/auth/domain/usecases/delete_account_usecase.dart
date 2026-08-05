import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

/// Deletes the given user's account. If [reauthenticateFirst] is true,
/// reauthenticates with whichever provider (Google or Apple) the user
/// actually signed in with before attempting the delete — Firebase
/// requires a recent sign-in for destructive account operations.
@injectable
@Environment(Env.minimal)
class DeleteAccountUsecase {
  Future<void> call({
    required UserEntity user,
    bool reauthenticateFirst = false,
  }) async {
    if (reauthenticateFirst) {
      await _reauthenticate();
    }

    await AuthService.instance.deleteAccount(
      userId: user.id,
      isGuest: user.isGuest,
    );
  }

  Future<void> _reauthenticate() async {
    final signedInWithApple =
        AuthService.instance.currentFirebaseUser?.providerData.any(
          (info) => info.providerId == 'apple.com',
        ) ??
        false;

    if (signedInWithApple) {
      await AuthService.instance.reauthenticateWithApple();
    } else {
      await AuthService.instance.reauthenticateWithGoogle();
    }
  }
}
