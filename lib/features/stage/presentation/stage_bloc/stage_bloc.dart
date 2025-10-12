import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:find_the_words/features/stage/presentation/usecases/crossword_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  final StageGeneratorService _stageGeneratorService;
  final CrosswordUsecase _crosswordUsecase = CrosswordUsecase();
  final AuthCubit _authCubit = getIt<AuthCubit>();
  final StorageService _storageService = getIt<StorageService>();

  StageBloc({required StageGeneratorService stageGeneratorService})
    : _stageGeneratorService = stageGeneratorService,
      super(StageInitial()) {
    on<NextStageButtonPressed>(_onNextStageButtonPressed);
    on<SubmitFormatedWord>(_onSubmitFormatedWord);
    on<RandomLetterReveal>(_onRandomLetterReveal);
  }

  void _onNextStageButtonPressed(
    NextStageButtonPressed event,
    Emitter<StageState> emit,
  ) async {
    emit(StageLoading());

    final stage = checkForSavedStage();

    if (stage != null) {
      emit(StageReady(stage));
      return;
    }

    final int userLevel = event.profileStatus.level;
    final int letterFileNum = userLevel + 2;

    final stageData = await _stageGeneratorService.generateStage(
      filePath: FileUtils.stageFile(letterFileNum),
      level: userLevel,
      progress: event.profileStatus.progress,
    );

    final updatedStage = _enrichStageWithCommonPositions(stageData);

    _storageService.saveCurrentStage(updatedStage);

    // TODO: Upload the current stage online

    emit(StageReady(updatedStage));
  }

  void _onSubmitFormatedWord(
    SubmitFormatedWord event,
    Emitter<StageState> emit,
  ) async {
    if (state is! StageActive) return;

    final currentState = state as StageActive;
    final submittedWord = event.formatedWord.toUpperCase();
    final tracker = currentState.stage.placementTracker;

    if (tracker.containsWord(submittedWord) &&
        !tracker.isWordFound(submittedWord)) {
      tracker.markWordAsFound(submittedWord);
      final List<int>? wordPositions = tracker.getPositionsForWord(
        submittedWord,
      );

      if (wordPositions != null) {
        tracker.addRevealedPositions(wordPositions);

        final updatedStage = _crosswordUsecase.updateCurrentStage(
          oldTracker: tracker,
          oldStage: currentState.stage,
          placement: tracker.getPlacementFromWord(submittedWord),
        );

        _authCubit.addFoundWord(submittedWord);

        updateStageState(
          tracker: tracker,
          newPositions: wordPositions,
          stage: updatedStage,
          emit: emit,
        );
      }
    } else if (currentState.stage.allWords.contains(submittedWord) &&
        !tracker.isWordFound(submittedWord)) {
      for (var placement in tracker.placements) {
        if (placement.word.length == submittedWord.length) {
          if (_crosswordUsecase.canReplacePlacement(
            tracker,
            placement,
            submittedWord,
          )) {
            tracker.markWordAsFound(submittedWord);
            final updatedStage = _crosswordUsecase.replacePlacement(
              currentStage: currentState.stage,
              tracker: tracker,
              placement: placement,
              submittedWord: submittedWord,
            );

            _authCubit.addFoundWord(submittedWord);

            updateStageState(
              tracker: tracker,
              newPositions: placement.positions,
              stage: updatedStage,
              emit: emit,
            );
            return;
          }
        }
      }

      tracker.markWordAsExtra(submittedWord);
      _authCubit.addFoundWord(submittedWord);
      final updatedStage = CurrentStage(
        allWords: currentState.stage.allWords,
        letters: currentState.stage.letters,
        board: currentState.stage.board,
        placementTracker: tracker,
      );
      _storageService.saveCurrentStage(updatedStage);
      emit(ExtraWordFound(updatedStage));
    }
  }

  void _onRandomLetterReveal(
    RandomLetterReveal event,
    Emitter<StageState> emit,
  ) async {
    if (state is! StageActive) return;

    final currentState = state as StageActive;
    final tracker = currentState.stage.placementTracker;

    // Collect all unrevealed positions
    final unrevealedPositions = <int>{};
    for (var positions in tracker.allPositions) {
      for (var position in positions) {
        if (!tracker.revealedPositions.contains(position)) {
          unrevealedPositions.add(position);
        }
      }
    }

    // Select random position
    final randomSpot = unrevealedPositions.elementAt(
      Random().nextInt(unrevealedPositions.length),
    );

    tracker.addRevealedPositions([randomSpot]);
    final updatedStage = CurrentStage(
      allWords: currentState.stage.allWords,
      letters: currentState.stage.letters,
      board: currentState.stage.board,
      placementTracker: tracker,
    );

    updateStageState(
      tracker: tracker,
      newPositions: [randomSpot],
      stage: updatedStage,
      emit: emit,
    );

    // Find which word placements contain this position
    final affectedPlacements = tracker.placements
        .where(
          (placement) =>
              !placement.isUsed && placement.positions.contains(randomSpot),
        )
        .toList();

    // Check if revealing this letter completes any words
    for (var placement in affectedPlacements) {
      final allRevealed = placement.positions.every(
        (position) => tracker.revealedPositions.contains(position),
      );

      if (allRevealed) {
        tracker.markWordAsFound(placement.word);

        final updatedStage = _crosswordUsecase.updateCurrentStage(
          oldTracker: tracker,
          oldStage: currentState.stage,
          placement: tracker.getPlacementFromWord(placement.word),
        );

        _authCubit.addFoundWord(placement.word);

        updateStageState(
          tracker: tracker,
          newPositions: placement.positions,
          stage: updatedStage,
          emit: emit,
        );
      }
    }

    // TODO: when you reveal a spot of a word, mark this word as "locked", so it cannot be replaced
  }

  void updateStageState({
    required WordPlacementTracker tracker,
    required List<int> newPositions,
    required CurrentStage stage,
    required Emitter<StageState> emit,
  }) {
    if (tracker.allWordsFound) {
      _storageService.deleteCurrentStage();
      emit(StageCompleted(stage));
    } else {
      _storageService.saveCurrentStage(stage);
      emit(StageInProgress(stage, newPositions: newPositions));
    }
  }

  CurrentStage? checkForSavedStage() {
    if (!_storageService.hasSavedStage()) return null;

    CurrentStage? stage = _storageService.getCurrentStage();

    return stage;
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
