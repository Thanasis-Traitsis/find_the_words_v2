part of 'stage_bloc.dart';

sealed class StageState extends Equatable {
  const StageState();

  @override
  List<Object> get props => [];
}

final class StageInitial extends StageState {}

final class StageLoading extends StageState {}

final class StageCreated extends StageState {}

final class StageCompleted extends StageState {}

final class StageNotCreated extends StageState {}
