import 'dart:async';

import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsCubit extends Cubit<int> {
  final AuthCubit _authCubit;
  final StorageService _storageService;
  StreamSubscription<AuthState>? _authSubscription;

  PointsCubit({
    required AuthCubit authCubit,
    required StorageService storageService,
  }) : _authCubit = authCubit,
       _storageService = storageService,
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

    final currentUser = authState.user;
    await _updatePoints(currentUser.points + amount, currentUser as UserModel);
  }

  Future<bool> deductPoints(int amount, {String? reason}) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return false;

    final currentUser = authState.user;
    if (currentUser.points < amount) {
      return false;
    }

    await _updatePoints(currentUser.points - amount, currentUser as UserModel);
    return true;
  }

  Future<void> _updatePoints(int newPoints, UserModel currentUser) async {
    final updatedUser = currentUser.copyWith(points: newPoints);
    await _storageService.saveUser(updatedUser);
    
    _authCubit.emit(AuthAuthenticated(user: updatedUser));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
