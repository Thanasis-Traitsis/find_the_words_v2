part of 'stage_bloc.dart';

sealed class StageEvent extends Equatable {
  const StageEvent();

  @override
  List<Object> get props => [];
}

class NextStageButtonPressed extends StageEvent {
  final String filePath;

  const NextStageButtonPressed(this.filePath);
}
