import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/usecases/check_intersection_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/load_stage_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/reveal_letter_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/submit_word_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  final LoadStageUsecase _loadStageUsecase;
  final SubmitWordUsecase _submitWordUsecase;
  final CheckIntersectionsUsecase _checkIntersectionsUsecase;
  final RevealLetterUsecase _revealLetterUsecase;
  final StageRepository _stageRepo;

  StageBloc({
    required LoadStageUsecase loadStageUsecase,
    required SubmitWordUsecase submitWordUsecase,
    required CheckIntersectionsUsecase checkIntersectionsUsecase,
    required RevealLetterUsecase revealLetterUsecase,
    required StageRepository stageRepo,
  }) : _loadStageUsecase = loadStageUsecase,
       _submitWordUsecase = submitWordUsecase,
       _checkIntersectionsUsecase = checkIntersectionsUsecase,
       _revealLetterUsecase = revealLetterUsecase,
       _stageRepo = stageRepo,
       super(StageInitial()) {
    on<NextStageButtonPressed>(_onNextStageButtonPressed);
    on<SubmitFormatedWord>(_onSubmitFormatedWord);
    on<CrosswordLetterReveal>(_onCrosswordLetterReveal);
  }

  Future<void> _onNextStageButtonPressed(
    NextStageButtonPressed event,
    Emitter<StageState> emit,
  ) async {
    emit(StageLoading());

    try {
      final stage = await _loadStageUsecase(event.profileStatus);
      emit(StageReady(stage));
    } catch (e) {
      emit(StageError(errorMessage: e.toString()));
    }
  }

  Future<void> _onSubmitFormatedWord(
    SubmitFormatedWord event,
    Emitter<StageState> emit,
  ) async {
    if (state is! StageActive) return;

    final currentState = state as StageActive;
    final wordResult = await _submitWordUsecase(
      submittedWord: event.formatedWord,
      currentStage: currentState.stage,
    );

    if (wordResult == null) return;

    switch (wordResult.result) {
      case WordSubmissionResult.found:
      case WordSubmissionResult.replaced:
        await _handleFoundWord(
          data: wordResult,
          emit: emit,
          submittedWord: event.formatedWord.toUpperCase(),
        );
        break;

      case WordSubmissionResult.extra:
        emit(ExtraWordFound(wordResult.updatedStage));
        break;

      case WordSubmissionResult.notFound:
        break;
    }
  }

  Future<void> _onCrosswordLetterReveal(
    CrosswordLetterReveal event,
    Emitter<StageState> emit,
  ) async {
    if (state is! StageActive) return;

    final pointsCubit = getIt<PointsCubit>();
    final int revealCost = event.position != null ? 15 : 10;
    final currentState = state as StageActive;

    final success = await pointsCubit.deductPoints(
      revealCost,
      reason: 'Letter reveal',
    );

    if (!success) {
      emit(StageInGameError(currentState.stage, errorMessage: 'Not enough points to reveal letter'));
      return;
    }
    final result = await _revealLetterUsecase(
      currentStage: currentState.stage,
      position: event.position,
    );

    _emitStageState(
      stage: result.stageAfterReveal,
      newPositions: [result.revealedPosition],
      emit: emit,
    );

    for (int i = 0; i < result.autoCompletedWords.length; i++) {
      final completedWord = result.autoCompletedWords[i];

      _emitStageState(
        stage: result.stageAfterReveal,
        newPositions: completedWord.positions,
        emit: emit,
      );

      await Future.delayed(
        Duration(milliseconds: (completedWord.word.length * 100) + 200),
      );
    }
  }

  Future<void> _handleFoundWord({
    required WordSubmissionData data,
    required Emitter<StageState> emit,
    required String submittedWord,
  }) async {
    if (data.positions == null) return;

    _emitStageState(
      stage: data.updatedStage,
      newPositions: data.positions!,
      emit: emit,
    );

    await Future.delayed(
      Duration(milliseconds: (data.positions!.length * 100) + 200),
    );

    final intersectionResult = await _checkIntersectionsUsecase(
      wordPositions: data.positions!,
      submittedWord: submittedWord,
      currentStage: data.updatedStage,
    );

    for (int i = 0; i < intersectionResult.completedWords.length; i++) {
      final completedWord = intersectionResult.completedWords[i];

      _emitStageState(
        stage: intersectionResult.finalStage,
        newPositions: completedWord.positions,
        emit: emit,
      );

      if (i < intersectionResult.completedWords.length - 1) {
        await Future.delayed(
          Duration(milliseconds: (completedWord.word.length * 100) + 200),
        );
      }
    }
  }

  void _emitStageState({
    required CurrentStage stage,
    required List<int> newPositions,
    required Emitter<StageState> emit,
  }) {
    if (stage.placementTracker.allWordsFound) {
      _stageRepo.clearStage();
      emit(StageCompleted(stage));
    } else {
      emit(StageInProgress(stage, newPositions: newPositions));
    }
  }
}
