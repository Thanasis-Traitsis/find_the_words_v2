part of 'stage_bloc.dart';

sealed class StageState extends Equatable {
  const StageState();

  @override
  List<Object> get props => [];
}

final class StageInitial extends StageState {}

final class StageLoading extends StageState {}

abstract class StageActive extends StageState {
  final CurrentStage stage;

  const StageActive(this.stage);

  @override
  List<Object> get props => [stage];
}

final class StageReady extends StageActive {
  const StageReady(super.stage);
}

final class StageInProgress extends StageActive {
  final List<int> newPositions;

  const StageInProgress(super.stage, {required this.newPositions});
}

final class WordInvalid extends StageActive {
  const WordInvalid(super.stage);
}

final class WordAlreadyFound extends StageActive {
  const WordAlreadyFound(super.stage);
}

final class ExtraWordFound extends StageActive {
  const ExtraWordFound(super.stage);
}

final class StageCompleted extends StageActive {
  const StageCompleted(super.stage);
}
