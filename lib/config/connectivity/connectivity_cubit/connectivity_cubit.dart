import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'connectivity_state.dart';

@lazySingleton
@Environment(Env.full)
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;

  ConnectivityCubit(this._connectivityService) : super(ConnectivityChecking()) {
    _initialize();
  }

  void _initialize() async {
    final hasInternet = await _connectivityService.hasInternet();
    emit(hasInternet ? ConnectivityOnline() : ConnectivityOffline());

    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (hasInternet) {
        emit(hasInternet ? ConnectivityOnline() : ConnectivityOffline());
      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}