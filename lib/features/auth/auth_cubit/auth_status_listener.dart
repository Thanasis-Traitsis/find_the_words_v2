import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';

class AuthStatusNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;
  StreamSubscription? _subscription;
  Type? _previousStateType;

  AuthStatusNotifier(this._authCubit) {
    _previousStateType = _authCubit.state.runtimeType;
    
    _subscription = _authCubit.stream.listen((state) {
      final currentStateType = state.runtimeType;
      
      if (currentStateType != _previousStateType) {
        _previousStateType = currentStateType;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}