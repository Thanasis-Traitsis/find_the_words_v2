import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String? username;

  @HiveField(2)
  @override
  final int points;

  @HiveField(3)
  @override
  final Map<AppLanguage, ProfileStatusModel> progressByLanguage;

  @HiveField(4)
  @override
  final CurrentStage? currentStage;

  UserModel({
    required this.id,
    required this.username,
    required this.points,
    required this.progressByLanguage,
    this.currentStage,
  }) : super.authenticated(
         id: id,
         username: username,
         points: points,
         progressByLanguage: progressByLanguage,
         currentStage: currentStage,
       );

  UserModel.guest({
    required this.id,
    required this.points,
    required this.progressByLanguage,
    this.currentStage,
  }) : username = null,
       super.guest(
         id: id,
         points: points,
         progressByLanguage: progressByLanguage,
         currentStage: currentStage,
       );

  UserModel.authenticated({
    required this.id,
    required this.username,
    required this.points,
    required this.progressByLanguage,
    this.currentStage,
  }) : super.authenticated(
         id: id,
         username: username,
         points: points,
         progressByLanguage: progressByLanguage,
         currentStage: currentStage,
       );
}
