import 'package:find_the_words/features/stage/data/models/current_stage.dart';

abstract class StageRepository {
  Future<CurrentStage?> loadSavedStage();

  Future<void> saveStageProgress({
    required CurrentStage stage,
    required String foundWord,
  });

  Future<CurrentStage> generateStage({
    required int level,
    required int stageNumber,
    required double progress,
  });

  Future<void> resetStage(int stageNumber);

  Future<void> clearStage();

  bool hasSavedStage();

  void saveStageWordsAfterCompletion({
    required List<String> foundWords,
    required List<String> extraWords,
  });
}
