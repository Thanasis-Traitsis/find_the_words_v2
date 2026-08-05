import 'dart:async';

import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.full)
class AccountBoostCubit extends Cubit<AccountBoostEntity?> {
  final AuthCubit _authCubit;
  final StorageService _storageService;
  StreamSubscription<AuthState>? _authSubscription;
  Timer? _timer;

  AccountBoostCubit({
    required AuthCubit authCubit,
    required StorageService storageService,
  }) : _authCubit = authCubit,
       _storageService = storageService,
       super(null) {
    _listenToAuthChanges();
  }

  int get currentMultiplier => state?.multiplier ?? 1;

  void _listenToAuthChanges() {
    _syncWithAuthState(_authCubit.state);

    _authSubscription = _authCubit.stream.listen((authState) {
      _syncWithAuthState(authState);
    });
  }

  void _syncWithAuthState(AuthState authState) {
    if (state is! AuthAuthenticated) {
      _cancelTimer();
      emit(null);
    }

    if (authState is AuthAuthenticated) {
      final currentLanguage = _getCurrentLanguage();
      final boost =
          authState.user.progressByLanguage[currentLanguage]?.activeBoost;

      if (boost != null && boost.isActive && !boost.isExpired) {
        emit(boost);

        if (boost.type == AccountBoostType.minutes) {
          _startTimer();
        }
      } else {
        _cancelTimer();
        emit(null);
      }
    }
  }

  // Activate a new boost
  Future<void> activate({
    required String activeKey,
    required AccountBoostType type,
    int multiplier = 2,
    required int amount,
    required PointsCubit pointsCubit,
    required int points,
  }) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final boost = AccountBoostModel.activate(
      activekey: activeKey,
      type: type,
      multiplier: multiplier,
      amount: amount,
    );

    await _updateBoost(boost, authState.user);
    await pointsCubit.deductPoints(points);

    if (type == AccountBoostType.minutes) {
      _startTimer();
    }
  }

  // Decrement stage for stage-based boosts
  Future<void> decrementStage() async {
    final boost = state;
    if (boost == null || boost.type != AccountBoostType.stages) return;

    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final updated = boost.decrementStage();

    if (updated.isActive) {
      await _updateBoost(AccountBoostModel.fromEntity(updated), authState.user);
    } else {
      await clear();
    }
  }

  // Clear boost
  Future<void> clear() async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    _cancelTimer();
    await _updateBoost(null, authState.user);
  }

  // Update boost in storage and auth state
  Future<void> _updateBoost(
    AccountBoostModel? boost,
    UserEntity currentUser,
  ) async {
    final currentLanguage = _getCurrentLanguage();
    final currentProfile = currentUser.progressByLanguage[currentLanguage];

    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      activeBoost: boost,
      clearBoost: boost == null,
    );

    final updatedProgressByLanguage = Map<AppLanguage, ProfileStatusModel>.from(
      currentUser.progressByLanguage,
    )..[currentLanguage] = updatedProfile;

    final updatedUser = currentUser.copyWith(
      progressByLanguage: updatedProgressByLanguage,
    );

    final userModel = UserModel.fromEntity(updatedUser);
    await _storageService.saveUser(userModel);
    _authCubit.emit(AuthAuthenticated(user: userModel));
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final boost = state;

      if (boost == null || boost.isExpired || !boost.isActive) {
        clear();
        timer.cancel();
      } else {
        emit(boost);
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  AppLanguage _getCurrentLanguage() {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    return currentLang;
  }

  void reset() {
    _listenToAuthChanges();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cancelTimer();
    return super.close();
  }
}
