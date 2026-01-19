part of 'connectivity_cubit.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  
  @override
  List<Object> get props => [];
}

class ConnectivityOnline extends ConnectivityState {}
class ConnectivityOffline extends ConnectivityState {}
class ConnectivityChecking extends ConnectivityState {}