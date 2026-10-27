import 'dart:async';

import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.full)
class PointsCubit extends Cubit<int> {
  final AuthCubit _authCubit;
  final UserProfileService _userProfileService;
  StreamSubscription<AuthState>? _authSubscription;

  PointsCubit({
    required AuthCubit authCubit,
    required UserProfileService userProfileService,
  }) : _authCubit = authCubit,
       _userProfileService = userProfileService,
       super(0) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _syncWithAuthState(_authCubit.state);

    _authSubscription = _authCubit.stream.listen((authState) {
      _syncWithAuthState(authState);
    });
  }

  void _syncWithAuthState(AuthState authState) {
    if (authState is AuthAuthenticated) {
      emit(authState.user.points);
    } else {
      emit(0);
    }
  }

  Future<void> addPoints(int amount, {String? reason}) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    await _userProfileService.updatePoints(authState.user.points + amount);
  }

  Future<bool> deductPoints(int amount, {String? reason}) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return false;

    if (authState.user.points < amount) return false;

    await _userProfileService.updatePoints(authState.user.points - amount);
    return true;
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
