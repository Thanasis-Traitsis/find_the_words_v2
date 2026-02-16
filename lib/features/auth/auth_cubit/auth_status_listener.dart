import 'dart:async';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';

class AppStatusNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;
  final LanguageCubit _languageCubit;
  StreamSubscription? _authSubscription;
  StreamSubscription? _langSubscription;
  Type? _previousAuthStateType;
  bool? _previousIsFirstTime;

  AppStatusNotifier(this._authCubit, this._languageCubit) {
    _previousAuthStateType = _authCubit.state.runtimeType;
    _previousIsFirstTime = _languageCubit.state.isFirstTime;
    
    _authSubscription = _authCubit.stream.listen((state) {
      final currentStateType = state.runtimeType;
      
      if (currentStateType != _previousAuthStateType) {
        _previousAuthStateType = currentStateType;
        notifyListeners();
      }
    });

    _langSubscription = _languageCubit.stream.listen((state) {
      final currentIsFirstTime = state.isFirstTime;
      
      if (currentIsFirstTime != _previousIsFirstTime) {
        _previousIsFirstTime = currentIsFirstTime;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _langSubscription?.cancel();
    super.dispose();
  }
}