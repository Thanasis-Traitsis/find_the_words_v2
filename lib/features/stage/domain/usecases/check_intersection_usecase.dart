import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/usecases/crossword_usecase.dart';

class CompletedWord {
  final String word;
  final List<int> positions;

  CompletedWord({required this.word, required this.positions});
}

class IntersectionCheckResult {
  final List<CompletedWord> completedWords;
  final CurrentStage finalStage;

  IntersectionCheckResult({
    required this.completedWords,
    required this.finalStage,
  });
}

class CheckIntersectionsUsecase {
  final StageRepository _repository;
  final CrosswordUsecase _crosswordUsecase;

  CheckIntersectionsUsecase({
    required StageRepository repository,
    required CrosswordUsecase crosswordUsecase,
  }) : _repository = repository,
       _crosswordUsecase = crosswordUsecase;

  Future<IntersectionCheckResult> call({
    required List<int> wordPositions,
    required String submittedWord,
    required CurrentStage currentStage,
  }) async {
    final tracker = currentStage.placementTracker;
    final completedWords = <CompletedWord>[];

    final commonPositionsInWord = wordPositions
        .where((pos) => tracker.commonPositions.contains(pos))
        .toList();

    if (commonPositionsInWord.isEmpty) {
      return IntersectionCheckResult(
        completedWords: completedWords,
        finalStage: currentStage,
      );
    }

    CurrentStage latestStage = currentStage;

    // Check each common position for intersecting words
    for (int position in commonPositionsInWord) {
      final placements = tracker.getPlacementsFromPosition(position);

      for (var placement in placements) {
        if (placement.word == submittedWord ||
            tracker.isWordFound(placement.word)) {
          continue;
        }

        if (_isWordFullyRevealed(placement, tracker)) {
          tracker.markWordAsFound(placement.word);

          latestStage = _crosswordUsecase.updateCurrentStage(
            oldTracker: tracker,
            oldStage: latestStage,
            placement: placement,
          );

          await _repository.saveStageProgress(
            stage: latestStage,
            foundWord: placement.word,
          );

          completedWords.add(
            CompletedWord(word: placement.word, positions: placement.positions),
          );
        }
      }
    }

    return IntersectionCheckResult(
      completedWords: completedWords,
      finalStage: latestStage,
    );
  }

  bool _isWordFullyRevealed(
    WordPlacement placement,
    WordPlacementTracker tracker,
  ) {
    return placement.positions.every(
      (position) => tracker.revealedPositions.contains(position),
    );
  }
}
