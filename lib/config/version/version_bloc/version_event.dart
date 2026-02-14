part of 'version_bloc.dart';

abstract class VersionEvent extends Equatable {
  const VersionEvent();
  
  @override
  List<Object?> get props => [];
}

class CheckVersion extends VersionEvent {
  const CheckVersion();
}

class RefreshVersion extends VersionEvent {
  const RefreshVersion();
}

class DismissOptionalUpdate extends VersionEvent {
  const DismissOptionalUpdate();
}
