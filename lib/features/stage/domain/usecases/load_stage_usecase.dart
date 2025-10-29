import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
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

    return _enrichStageWithCommonPositions(stage);
  }

  CurrentStage _enrichStageWithCommonPositions(CurrentStage stage) {
    final commonPositions = _findCommonPositions(
      stage.placementTracker.allPositions,
    );

    final updatedTracker = WordPlacementTracker.copyWith(
      placements: stage.placementTracker.placements,
      foundWords: stage.placementTracker.foundWords,
      revealedPositions: stage.placementTracker.revealedPositions,
      commonPositions: commonPositions,
      extraWords: stage.placementTracker.extraWords,
    );

    return CurrentStage(
      allWords: stage.allWords,
      letters: stage.letters,
      board: stage.board,
      placementTracker: updatedTracker,
    );
  }

  List<int> _findCommonPositions(List<List<int>> allPositions) {
    final positionCounts = _countPositionOccurrences(allPositions);
    return _extractRepeatedPositions(positionCounts);
  }

  Map<int, int> _countPositionOccurrences(List<List<int>> allPositions) {
    final counts = <int, int>{};

    for (final positions in allPositions) {
      for (final position in positions) {
        counts[position] = (counts[position] ?? 0) + 1;
      }
    }

    return counts;
  }

  List<int> _extractRepeatedPositions(Map<int, int> positionCounts) {
    return positionCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();
  }
}