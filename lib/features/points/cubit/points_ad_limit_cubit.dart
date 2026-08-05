import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'points_ad_limit_state.dart';

class PointsAdLimitCubit extends Cubit<PointsAdLimitState> {
  PointsAdLimitCubit() : super(const PointsAdLimitState());

  Future<void> initialize() async {
    final prefs = getIt<SharedPreferences>();

    final watchCount = prefs.getInt(AppKeys.pointsAdWatchCountKey) ?? 0;
    final windowStartMillis = prefs.getInt(AppKeys.pointsAdWindowStartKey);
    final windowStart = windowStartMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(windowStartMillis)
        : null;

    emit(PointsAdLimitState(watchCount: watchCount, windowStart: windowStart));
  }

  Future<void> recordWatch() async {
    final prefs = getIt<SharedPreferences>();
    final now = DateTime.now();

    final windowExpired = state.windowStart == null ||
        now.difference(state.windowStart!).inHours >=
            AppValues.pointsAdWindowHours;

    final newCount = windowExpired ? 1 : state.watchCount + 1;
    final newWindowStart = windowExpired ? now : state.windowStart!;

    await prefs.setInt(AppKeys.pointsAdWatchCountKey, newCount);
    await prefs.setInt(
      AppKeys.pointsAdWindowStartKey,
      newWindowStart.millisecondsSinceEpoch,
    );

    emit(
      PointsAdLimitState(watchCount: newCount, windowStart: newWindowStart),
    );
  }
}
