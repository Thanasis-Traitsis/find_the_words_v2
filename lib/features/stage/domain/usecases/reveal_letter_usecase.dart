import 'dart:math';

import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/usecases/crossword_usecase.dart';

class CompletedWordFromReveal {
  final String word;
  final List<int> positions;

  CompletedWordFromReveal({required this.word, required this.positions});
}

class RevealLetterResult {
  final int revealedPosition;
  final CurrentStage stageAfterReveal;
  final List<CompletedWordFromReveal> autoCompletedWords;

  RevealLetterResult({
    required this.revealedPosition,
    required this.stageAfterReveal,
    required this.autoCompletedWords,
  });
}

class RevealLetterUsecase {
  final StageRepository _repository;
  final CrosswordUsecase _crosswordUsecase;

  RevealLetterUsecase({
    required StageRepository repository,
    required CrosswordUsecase crosswordUsecase,
  }) : _repository = repository,
       _crosswordUsecase = crosswordUsecase;

  Future<RevealLetterResult> call({
    required CurrentStage currentStage,
    int? position,
  }) async {
    final tracker = currentStage.placementTracker;
    final unrevealedPositions = tracker.remainingPositions;

    final selectedPosition =
        position ??
        unrevealedPositions.elementAt(
          Random().nextInt(unrevealedPositions.length),
        );

    tracker.addRevealedPositions([selectedPosition]);

    CurrentStage updatedStage = _handlePositionReveal(
      selectedPosition,
      tracker,
      currentStage,
    );

    await _repository.saveStageProgress(stage: updatedStage);

    final autoCompletedWords = <CompletedWordFromReveal>[];
    final affectedPlacements = tracker.placements
        .where((placement) => placement.positions.contains(selectedPosition))
        .toList();

    for (var placement in affectedPlacements) {
      final allRevealed = placement.positions.every(
        (position) => tracker.revealedPositions.contains(position),
      );

      if (allRevealed && !tracker.isWordFound(placement.word)) {
        tracker.markWordAsFound(placement.word);

        updatedStage = _crosswordUsecase.updateCurrentStage(
          oldTracker: tracker,
          oldStage: updatedStage,
          placement: placement,
        );

        await _repository.saveStageProgress(
          stage: updatedStage,
          foundWord: placement.word,
        );

        autoCompletedWords.add(
          CompletedWordFromReveal(
            word: placement.word,
            positions: placement.positions,
          ),
        );
      }
    }

    return RevealLetterResult(
      revealedPosition: selectedPosition,
      stageAfterReveal: updatedStage,
      autoCompletedWords: autoCompletedWords,
    );
  }

  CurrentStage _handlePositionReveal(
    int position,
    WordPlacementTracker tracker,
    CurrentStage stage,
  ) {
    try {
      final foundInPlacement = tracker.getPlacementFromUniquePosition(position);

      return _crosswordUsecase.updateCurrentStage(
        oldTracker: tracker,
        placement: foundInPlacement,
        oldStage: stage,
      );
    } on StateError {
      return CurrentStage(
        allWords: stage.allWords,
        letters: stage.letters,
        board: stage.board,
        placementTracker: tracker,
      );
    }
  }
}
