import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class UserEntity {
  final String id;
  final String? username;
  final int points;
  final ProfileStatusModel profileStatus;
  final CurrentStage? currentStage;

  UserEntity.guest({
    required this.id,
    required this.points,
    required this.profileStatus,
    this.currentStage,
  }) : username = null;

  UserEntity.authenticated({
    required this.id,
    required this.username,
    required this.points,
    required this.profileStatus,
    this.currentStage,
  });
}
