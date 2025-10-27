part of 'stage_bloc.dart';

sealed class StageEvent extends Equatable {
  const StageEvent();

  @override
  List<Object> get props => [];
}

class NextStageButtonPressed extends StageEvent {
  final ProfileStatusModel profileStatus;

  const NextStageButtonPressed(this.profileStatus);
}

class SubmitFormatedWord extends StageEvent {
  final String formatedWord;

  const SubmitFormatedWord(this.formatedWord);
}

class CrosswordLetterReveal extends StageEvent {
  final int? position;

  const CrosswordLetterReveal(this.position);
}
