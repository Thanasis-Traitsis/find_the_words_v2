import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> createUser(String id);

  Future<UserEntity> getCurrentUser();

  Future<DocumentSnapshot?> getFirebaseUser(String id);

  Future<void> createFirebaseUser(UserEntity user);

  Future<void> updateFirebaseUser(UserEntity user);
}
