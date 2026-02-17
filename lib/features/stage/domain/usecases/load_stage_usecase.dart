import 'package:find_the_words/config/language/app_language.dart';
import 'dart:developer' as developer;

import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';

class LoadStageUsecase {
  final StageRepository _repository;

  LoadStageUsecase({required StageRepository repository})
    : _repository = repository;

  Future<CurrentStage> call(ProfileStatusModel profileStatus) async {
    if (_repository.hasSavedStage()) {
      final savedStage = await _repository.loadSavedStage();
      if (savedStage != null) return savedStage;
    }

    final stage = await _repository.generateStage(
      level: profileStatus.level,
      stageNumber: profileStatus.stage,
      progress: profileStatus.progress,
    );

    return stage;
  }

  // void _logStageForBackup(CurrentStage stage, List<int> commonPositions) {
  //   developer.log("-------------------------------------");
  //   developer.log("static CurrentStage _backupLevel10OptionY() {");
  //   developer.log("  final tracker = WordPlacementTracker();");
  //   developer.log("");

  //   // developer.log all placements
  //   stage.placementTracker.placements.forEach((placement) {
  //     developer.log(
  //       "  tracker.addPlacement('${placement.word}', ${placement.positions});",
  //     );
  //   });

  //   developer.log("");
  //   developer.log("  tracker.commonPositions.addAll($commonPositions);");
  //   developer.log("");
  //   developer.log(
  //     "  final board = List.generate(${stage.board.length}, (_) => '');",
  //   );
  //   developer.log("  tracker.placePositions(board);");
  //   developer.log("");

  //   // Format allWords with quotes
  //   final formattedWords = stage.allWords.map((word) => "'$word'").join(', ');
  //   developer.log("  final allWords = [$formattedWords];");

  //   // Format letters with quotes
  //   final formattedLetters = stage.letters
  //       .map((letter) => "'$letter'")
  //       .join(', ');
  //   developer.log("  final letters = [$formattedLetters];");

  //   developer.log("");
  //   developer.log("  final backupStage = CurrentStage(");
  //   developer.log("    allWords: allWords,");
  //   developer.log("    letters: letters,");
  //   developer.log("    board: board,");
  //   developer.log("    placementTracker: tracker,");
  //   developer.log("  );");
  //   developer.log("");
  //   developer.log("  return backupStage;");
  //   developer.log("}");
  //   developer.log("-------------------------------------");
  // }
}
