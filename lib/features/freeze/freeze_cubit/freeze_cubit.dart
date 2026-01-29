import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'freeze_state.dart';

class FreezeCubit extends Cubit<FreezeState> {
  final UserProfileService _userProfileService;
  static const String _lastFreeAdTimestampKey = AppKeys.lastFreeAdTimestampKey;

  FreezeCubit(this._userProfileService) : super(const FreezeState());

  /// Initialize from UserModel - reads CurrentStage from both languages
  Future<void> initializeFreeze() async {
    try {
      final authState = getIt<AuthCubit>().state;
      final prefs = getIt<SharedPreferences>();

      final String? timestampString = prefs.getString(_lastFreeAdTimestampKey);
      if (authState is! AuthAuthenticated) return;

      final user = authState.user;

      // Build activeFreezeByLanguage map from CurrentStages
      final Map<String, bool> activeFreezeByLanguage = {};

      for (final language in AppLanguage.values) {
        final profileStatus = user.progressByLanguage[language];
        final currentStage = profileStatus?.currentStage;
        activeFreezeByLanguage[language.code] =
            currentStage?.activeFreeze ?? false;
      }

      DateTime? lastFreeAdTimestamp;
      if (timestampString != null) {
        lastFreeAdTimestamp = DateTime.parse(timestampString);
      }

      emit(
        FreezeState(
          totalFreezes: user.totalFreezes,
          activeFreezeByLanguage: activeFreezeByLanguage,
          lastFreeAdTimestamp: lastFreeAdTimestamp,
        ),
      );
    } catch (e) {
      debugPrint("${AppStrings.devFreezeLoadError}: $e");
    }
  }

  Future<void> activateFreeze() async {
    if (state.totalFreezes <= 0) {
      return;
    }

    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    if (state.isLanguageFrozen(currentLang)) {
      return;
    }

    try {
      final newTotalFreezes = state.totalFreezes - 1;

      // Update local state
      final updatedMap = Map<String, bool>.from(state.activeFreezeByLanguage);
      updatedMap[currentLang.code] = true;

      emit(
        state.copyWith(
          totalFreezes: newTotalFreezes,
          activeFreezeByLanguage: updatedMap,
        ),
      );

      // Update UserModel: CurrentStage.activeFreeze = true and decrease totalFreezes
      await _userProfileService.updateFreezeStatus(
        language: currentLang,
        activeFreeze: true,
        totalFreezes: newTotalFreezes,
      );

      debugPrint(
        'Freeze activated for $currentLang: ${state.totalFreezes} freezes remaining',
      );
    } catch (e) {
      debugPrint('Error activating freeze: $e');
      // Revert state on error
      final revertedMap = Map<String, bool>.from(state.activeFreezeByLanguage);
      revertedMap[currentLang.code] = false;

      emit(
        state.copyWith(
          totalFreezes: state.totalFreezes + 1,
          activeFreezeByLanguage: revertedMap,
        ),
      );
      rethrow;
    }
  }

  Future<void> deactivateFreeze() async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    if (!state.isLanguageFrozen(currentLang)) {
      debugPrint('No active freeze for $currentLang');
      return;
    }

    try {
      final updatedMap = Map<String, bool>.from(state.activeFreezeByLanguage);
      updatedMap[currentLang.code] = false;

      emit(state.copyWith(activeFreezeByLanguage: updatedMap));

      await _userProfileService.updateFreezeStatus(
        language: currentLang,
        activeFreeze: false,
      );

      debugPrint('Freeze deactivated for $currentLang');
    } catch (e) {
      debugPrint('Error deactivating freeze: $e');
      rethrow;
    }
  }

  Future<void> incrementTotalFreezes(int amount) async {
    if (amount <= 0) return;

    try {
      final newTotal = state.totalFreezes + amount;

      // Update local state
      emit(state.copyWith(totalFreezes: newTotal));

      // Update UserModel
      await _userProfileService.updateUserTotalFreezes(newTotal);

      debugPrint('Freezes incremented by $amount. Total: $newTotal');
    } catch (e) {
      debugPrint('Error incrementing freezes: $e');
      // Revert on error
      emit(state.copyWith(totalFreezes: state.totalFreezes - amount));
      rethrow;
    }
  }

  Future<void> recordFreeAdWatched() async {
    try {
      final timestamp = DateTime.now();

      // Update local state
      emit(state.copyWith(lastFreeAdTimestamp: timestamp));

      debugPrint('Free ad timestamp recorded');
    } catch (e) {
      debugPrint('Error recording free ad: $e');
      rethrow;
    }
  }

  Future<void> reset() async {
    emit(const FreezeState.initial());
  }
}
