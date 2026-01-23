import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
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

  @HiveField(5)
  @override
  final AccountBoostModel? activeBoost;

  @HiveField(6)
  final CurrentStage? currentStage;

  ProfileStatusModel({
    required this.language,
    required this.level,
    required double progress,
    required this.stage,
    required this.wordsModel,
    this.activeBoost,
    this.currentStage,
  }) : progress = progress.clamp(0, 100);

  factory ProfileStatusModel.initial(AppLanguage language) {
    return ProfileStatusModel(
      language: language,
      level: 1,
      progress: 0,
      stage: 1,
      wordsModel: WordsModel(words: {}),
      activeBoost: null,
      currentStage: null,
    );
  }

  factory ProfileStatusModel.fromMap(Map<String, dynamic> map) {
    return ProfileStatusModel(
      language: AppLanguage.fromCode(map['language'] as String),
      level: map['level'] as int? ?? 1,
      progress: (map['progress'] as num?)?.toDouble() ?? 0,
      stage: map['stage'] as int? ?? 1,
      wordsModel: WordsModel(
        words: Map<String, dynamic>.from(map['words'] as Map? ?? {}),
      ),
      activeBoost: map['activeBoost'] != null
          ? AccountBoostModel.fromMap(map['activeBoost'])
          : null,
      currentStage: map['currentStage'] != null
          ? CurrentStage.fromMap(map['currentStage'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language.code,
      'level': level,
      'progress': progress,
      'stage': stage,
      'words': wordsModel.words,
      'activeBoost': activeBoost?.toMap(),
      'currentStage': currentStage?.toMap(),
    };
  }

  bool get hasActiveBoost =>
      activeBoost != null && activeBoost!.isActive && !activeBoost!.isExpired;

  int get xpMultiplier => hasActiveBoost ? activeBoost!.multiplier : 1;

  int get totalStagesCompleted => stage - 1;

  int get totalWordsFound => wordsModel.words.length;

  ProfileStatusModel copyWith({
    AppLanguage? language,
    int? level,
    double? progress,
    int? stage,
    WordsModel? words,
    AccountBoostModel? activeBoost,
    CurrentStage? currentStage,
    bool clearBoost = false,
    bool clearCurrentStage = false,
  }) {
    return ProfileStatusModel(
      language: language ?? this.language,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      stage: stage ?? this.stage,
      wordsModel: words ?? wordsModel,
      activeBoost: clearBoost ? null : (activeBoost ?? this.activeBoost),
      currentStage: clearCurrentStage
          ? null
          : (currentStage ?? this.currentStage),
    );
  }
}
