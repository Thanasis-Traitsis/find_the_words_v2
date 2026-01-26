import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'freeze_state.dart';

class FreezeCubit extends Cubit<FreezeState> {
  static const String _totalFreezesKey = AppKeys.totalFreezesKey;
  static const String _activeFreezeKey = AppKeys.activeFreezeKey;
  static const String _lastFreeAdTimestampKey = AppKeys.lastFreeAdTimestampKey;

  FreezeCubit() : super(const FreezeState());

  void initializeFreeze() {
    try {
      final prefs = getIt<SharedPreferences>();
      final int? totalFreezes = prefs.getInt(_totalFreezesKey);
      final bool? activeFreeze = prefs.getBool(_activeFreezeKey);
      final String? timestampString = prefs.getString(_lastFreeAdTimestampKey);

      DateTime? lastFreeAdTimestamp;
      if (timestampString != null) {
        lastFreeAdTimestamp = DateTime.parse(timestampString);
      }

      _updateFreezeStatus(
        totalFreezes: totalFreezes,
        activeFreeze: activeFreeze,
        lastFreeAdTimestamp: lastFreeAdTimestamp,
      );
    } catch (e) {
      debugPrint("${AppStrings.devFreezeLoadError}: $e");
    }
  }

  void activateFreeze() {
    if (state.totalFreezes > 0 && !state.activeFreeze) {
      final int totalFreezes = state.totalFreezes;
      final newFreezeCount = decrementTotalFreezes(totalFreezes);

      _updateFreezeStatus(totalFreezes: newFreezeCount, activeFreeze: true);
    }
  }

  void deactivateFreeze() {
    _updateFreezeStatus(activeFreeze: false);
  }

  int decrementTotalFreezes(int totalFreezes) {
    final newFreezeCount = totalFreezes - 1;

    return newFreezeCount;
  }

  void incrementTotalFreezes(int newFreezes) {
    final int totalFreezes = state.totalFreezes;
    final newFreezeCount = totalFreezes + newFreezes;

    _updateFreezeStatus(totalFreezes: newFreezeCount);
  }

  void recordFreeAdWatched() {
    _updateFreezeStatus(lastFreeAdTimestamp: DateTime.now());
  }

  void _updateFreezeStatus({
    int? totalFreezes,
    bool? activeFreeze,
    DateTime? lastFreeAdTimestamp,
  }) {
    final prefs = getIt<SharedPreferences>();
    if (totalFreezes != null) {
      prefs.setInt(_totalFreezesKey, totalFreezes);
    }
    if (activeFreeze != null) {
      prefs.setBool(_activeFreezeKey, activeFreeze);
    }
    if (lastFreeAdTimestamp != null) {
      prefs.setString(
        _lastFreeAdTimestampKey,
        lastFreeAdTimestamp.toIso8601String(),
      );
    }

    emit(
      state.copyWith(
        totalFreezes: totalFreezes,
        activeFreeze: activeFreeze,
        lastFreeAdTimestamp: lastFreeAdTimestamp,
      ),
    );
  }
}
