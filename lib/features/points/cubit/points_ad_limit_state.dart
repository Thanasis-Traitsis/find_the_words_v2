part of 'points_ad_limit_cubit.dart';

class PointsAdLimitState extends Equatable {
  final int watchCount;
  final DateTime? windowStart;

  const PointsAdLimitState({this.watchCount = 0, this.windowStart});

  bool get _windowExpired {
    if (windowStart == null) return true;
    return DateTime.now().difference(windowStart!).inHours >=
        AppValues.pointsAdWindowHours;
  }

  bool get canWatch =>
      _windowExpired || watchCount < AppValues.maxPointsAdWatchesPerDay;

  Duration? get timeUntilReset {
    if (windowStart == null || _windowExpired) return null;

    final nextReset = windowStart!.add(
      const Duration(hours: AppValues.pointsAdWindowHours),
    );
    final difference = nextReset.difference(DateTime.now());

    return difference.isNegative ? null : difference;
  }

  PointsAdLimitState copyWith({int? watchCount, DateTime? windowStart}) {
    return PointsAdLimitState(
      watchCount: watchCount ?? this.watchCount,
      windowStart: windowStart ?? this.windowStart,
    );
  }

  @override
  List<Object?> get props => [watchCount, windowStart];
}
