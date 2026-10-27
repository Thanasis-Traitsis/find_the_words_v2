import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

@injectable
@Environment(Env.minimal)
class SignInUsecase {
  final CloudSyncService _cloudSyncService;

  SignInUsecase(this._cloudSyncService);

  Future<UserEntity?> call({
    required Future<firebase_auth.UserCredential?> Function() signIn,
    required UserEntity currentUser,
  }) async {
    final userCredential = await signIn();
    if (userCredential == null) return null;

    return _cloudSyncService.syncWithCloud(
      firebaseUser: userCredential.user!,
      localUser: currentUser,
    );
  }
}
