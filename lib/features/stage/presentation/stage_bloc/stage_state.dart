part of 'stage_bloc.dart';

sealed class StageState extends Equatable {
  const StageState();

  @override
  List<Object> get props => [];
}

final class StageInitial extends StageState {}

final class StageError extends StageState {
  final String errorMessage;

  const StageError({required this.errorMessage});
}

final class StageLoading extends StageState {}

abstract class StageActive extends StageState {
  final CurrentStage stage;
  final DateTime timestamp;

  StageActive(this.stage) : timestamp = DateTime.now();

  @override
  List<Object> get props => [stage, timestamp];
}

final class StageReady extends StageActive {
  StageReady(super.stage);
}

final class StageInProgress extends StageActive {
  final List<int> newPositions;

  StageInProgress(super.stage, {required this.newPositions});

  @override
  List<Object> get props => [stage, timestamp, newPositions];
}

final class WordInvalid extends StageActive {
  WordInvalid(super.stage);
}

final class WordAlreadyFound extends StageActive {
  WordAlreadyFound(super.stage);
}

final class ExtraWordFound extends StageActive {
  ExtraWordFound(super.stage);
}

final class StageCompleted extends StageActive {
  StageCompleted(super.stage);
}

final class StageInGameError extends StageActive {
  final ErrorScenarios error;

  StageInGameError(super.stage, {required this.error});

  @override
  List<Object> get props => [stage, error, timestamp];
}
