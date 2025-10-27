import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:hive/hive.dart';

part 'profile_status_model.g.dart';

@HiveType(typeId: 1)
class ProfileStatusModel {
  @HiveField(0)
  @override
  final AppLanguage language;

  @HiveField(1)
  @override
  final int level;

  @HiveField(2)
  @override
  final double progress;

  @HiveField(3)
  @override
  final int stage;

  @HiveField(4)
  @override
  final WordsModel wordsModel;

  ProfileStatusModel({
    required this.language,
    required this.level,
    required double progress,
    required this.stage,
    required this.wordsModel,
  }) : progress = progress.clamp(0, 100);

  factory ProfileStatusModel.initial(AppLanguage language) {
    return ProfileStatusModel(
      language: language,
      level: 1,
      progress: 0,
      stage: 1,
      wordsModel: WordsModel(words: {}),
    );
  }

  ProfileStatusModel copyWith({
    AppLanguage? language,
    int? level,
    double? progress,
    int? stage,
    WordsModel? words,
  }) {
    return ProfileStatusModel(
      language: language ?? this.language,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      stage: stage ?? this.stage,
      wordsModel: words ?? wordsModel,
    );
  }
}
