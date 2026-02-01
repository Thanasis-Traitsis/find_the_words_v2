import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';

class CrosswordUsecase {
  CurrentStage updateCurrentStage({
    required WordPlacementTracker oldTracker,
    required WordPlacement placement,
    required CurrentStage oldStage,
    List<String>? updatedBoard,
    String? newWord,
  }) {
    final updatedPlacements = _markUsedPositions(
      placement: placement,
      tracker: oldTracker,
      submittedWord: newWord ?? placement.word,
    );

    final updatedTracker = WordPlacementTracker.copyWith(
      placements: updatedPlacements,
      foundWords: oldTracker.foundWords,
      revealedPositions: oldTracker.revealedPositions,
      commonPositions: oldTracker.commonPositions,
      extraWords: oldTracker.extraWords,
    );

    final updatedStage = CurrentStage(
      allWords: oldStage.allWords,
      letters: oldStage.letters,
      board: updatedBoard ?? oldStage.board,
      placementTracker: updatedTracker,
      activeFreeze: oldStage.activeFreeze
    );

    return updatedStage;
  }

  bool canReplacePlacement(
    WordPlacementTracker tracker,
    WordPlacement placement,
    String submittedWord,
  ) {
    if (placement.word.length != submittedWord.length) return false;

    if (placement.isUsed) return false;

    for (int i = 0; i < placement.positions.length; i++) {
      if (tracker.commonPositions.contains(placement.positions[i])) {
        if (placement.word[i] != submittedWord[i]) {
          return false;
        }
      }
    }

    return true;
  }

  CurrentStage replacePlacement({
    required CurrentStage currentStage,
    required WordPlacementTracker tracker,
    required WordPlacement placement,
    required String submittedWord,
  }) {
    tracker.addRevealedPositions(placement.positions);

    final updatedBoard = _updateCrosswordBoard(
      currentStage: currentStage,
      placement: placement,
      submittedWord: submittedWord,
    );

    final updatedStage = updateCurrentStage(
      oldTracker: tracker,
      placement: placement,
      oldStage: currentStage,
      updatedBoard: updatedBoard,
      newWord: submittedWord,
    );

    return updatedStage;
  }

  List<WordPlacement> _markUsedPositions({
    required WordPlacementTracker tracker,
    required WordPlacement placement,
    required String submittedWord,
  }) {
    WordPlacement newPlacement = WordPlacement(
      word: submittedWord,
      positions: placement.positions,
      isHorizontal: placement.isHorizontal,
      isUsed: true,
    );

    final updatedPlacements = List<WordPlacement>.from(tracker.placements);
    final index = updatedPlacements.indexOf(placement);
    updatedPlacements[index] = newPlacement;

    return updatedPlacements;
  }

  List<String> _updateCrosswordBoard({
    required CurrentStage currentStage,
    required WordPlacement placement,
    required String submittedWord,
  }) {
    final updatedBoard = List<String>.from(currentStage.board);
    for (int i = 0; i < placement.positions.length; i++) {
      updatedBoard[placement.positions[i]] = submittedWord[i];
    }

    return updatedBoard;
  }
}
