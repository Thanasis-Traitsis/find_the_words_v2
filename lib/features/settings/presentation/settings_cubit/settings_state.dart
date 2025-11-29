part of 'settings_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsReportBadWord extends SettingsState {
  final List<String> previousStageWords;
  SettingsReportBadWord(this.previousStageWords);
}

class SettingsLoading extends SettingsState {}

class SettingsStageReset extends SettingsState {}

class SettingsEmailOpened extends SettingsState {}

class SettingsEmailFailed extends SettingsState {
  final String message;
  SettingsEmailFailed(this.message);
}