import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

abstract class UserRepository {
  Future<UserEntity> createUser(String id);

  Future<UserEntity> getCurrentUser();

  Future<void> updateUser(UserEntity user);

  Future<UserEntity> refreshUserFromStorage();

  /// Returns null only when no cloud document exists yet for [id] — safe to
  /// create one. A fetch failure (network, permissions, etc.) throws rather
  /// than returning null, so callers can't mistake "couldn't check" for
  /// "doesn't exist" and end up overwriting real cloud data.
  Future<DocumentSnapshot?> getFirebaseUser(String id);

  Future<void> createFirebaseUser(UserEntity user);

  Future<void> updateFirebaseUser(UserEntity user);

  Future<void> updateBannedWords();

  Future<void> updateCurrentStageFromMerge(UserEntity user);
}
