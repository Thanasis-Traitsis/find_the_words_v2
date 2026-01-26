import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/usecases/crossword_usecase.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';

enum WordSubmissionResult { found, replaced, extra, notFound, alreadyFound }

class WordSubmissionData {
  final WordSubmissionResult result;
  final CurrentStage updatedStage;
  final List<int>? positions;

  WordSubmissionData({
    required this.result,
    required this.updatedStage,
    this.positions,
  });
}

class SubmitWordUsecase {
  final CrosswordUsecase _crosswordUsecase;
  final StageRepository _repository;

  SubmitWordUsecase({
    required CrosswordUsecase crosswordUsecase,
    required StageRepository repository,
  }) : _crosswordUsecase = crosswordUsecase,
       _repository = repository;

  Future<WordSubmissionData?> call({
    required String submittedWord,
    required CurrentStage currentStage,
  }) async {
    final formattedWord = submittedWord.toUpperCase();
    final boardTracker = currentStage.placementTracker;

    // Case 1: Word doesn't exist
    if (!currentStage.allWords.contains(formattedWord)) {
      return WordSubmissionData(
        result: WordSubmissionResult.notFound,
        updatedStage: currentStage,
      );
    }

    // Case 2: Word has already been found
    if (boardTracker.isWordFound(formattedWord)) {
      return WordSubmissionData(
        result: WordSubmissionResult.alreadyFound,
        updatedStage: currentStage,
      );
    }

    // Case 3: Word is part of the crossword
    if (_wordInsideBoard(boardTracker, formattedWord)) {
      return await _handleDirectMatch(
        formattedWord,
        boardTracker,
        currentStage,
      );
    }

    // Case 4: Word is valid and we can try to place it in the crossword
    if (_wordIsValid(currentStage, boardTracker, formattedWord)) {
      return await _handleReplacement(
        formattedWord,
        boardTracker,
        currentStage,
      );
    }

    return null;
  }

  Future<WordSubmissionData> _handleDirectMatch(
    String word,
    WordPlacementTracker tracker,
    CurrentStage currentStage,
  ) async {
    tracker.markWordAsFound(word);

    final List<int>? wordPositions = tracker.getPositionsForWord(word);

    if (wordPositions == null) {
      return WordSubmissionData(
        result: WordSubmissionResult.notFound,
        updatedStage: currentStage,
      );
    }

    tracker.addRevealedPositions(wordPositions);
    final newWordPlacement = tracker.getPlacementFromWord(word);

    final updatedStage = _crosswordUsecase.updateCurrentStage(
      oldTracker: tracker,
      oldStage: currentStage,
      placement: newWordPlacement,
    );

    await _repository.saveStageProgress(stage: updatedStage, foundWord: word);

    return WordSubmissionData(
      result: WordSubmissionResult.found,
      updatedStage: updatedStage,
      positions: wordPositions,
    );
  }

  Future<WordSubmissionData?> _handleReplacement(
    String word,
    WordPlacementTracker tracker,
    CurrentStage currentStage,
  ) async {
    for (var placement in tracker.placements) {
      if (placement.word.length == word.length) {
        if (_crosswordUsecase.canReplacePlacement(tracker, placement, word)) {
          tracker.markWordAsFound(word);

          final updatedStage = _crosswordUsecase.replacePlacement(
            currentStage: currentStage,
            tracker: tracker,
            placement: placement,
            submittedWord: word,
          );

          await _repository.saveStageProgress(
            stage: updatedStage,
            foundWord: word,
          );

          return WordSubmissionData(
            result: WordSubmissionResult.replaced,
            updatedStage: updatedStage,
            positions: placement.positions,
          );
        }
      }
    }

    // Case 3: If no replacement found, mark as extra word
    // First check if we already have found this word
    final authState = getIt<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return WordSubmissionData(
        result: WordSubmissionResult.alreadyFound,
        updatedStage: currentStage,
      );
    }

    final wordsModel = authState.user.currentProgress.wordsModel;
    final foundWords = wordsModel.words.keys;
    if (foundWords.contains(word)) {
      return WordSubmissionData(
        result: WordSubmissionResult.alreadyFound,
        updatedStage: currentStage,
      );
    }

    tracker.markWordAsExtra(word);

    final updatedStage = CurrentStage(
      allWords: currentStage.allWords,
      letters: currentStage.letters,
      board: currentStage.board,
      placementTracker: tracker,
    );

    await _repository.saveStageProgress(stage: updatedStage, foundWord: word);

    return WordSubmissionData(
      result: WordSubmissionResult.extra,
      updatedStage: updatedStage,
    );
  }

  bool _wordInsideBoard(WordPlacementTracker placementTracker, String word) {
    return placementTracker.containsWord(word) &&
        !placementTracker.isWordFound(word);
  }

  bool _wordIsValid(
    CurrentStage currentStage,
    WordPlacementTracker placementTracker,
    String word,
  ) {
    return currentStage.allWords.contains(word) &&
        !placementTracker.isWordFound(word);
  }
}
