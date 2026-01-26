part of 'freeze_cubit.dart';

class FreezeState extends Equatable {
  final int totalFreezes;
  final bool activeFreeze;
  final DateTime? lastFreeAdTimestamp;

  const FreezeState({
    this.totalFreezes = 0,
    this.activeFreeze = false,
    this.lastFreeAdTimestamp,
  });

  FreezeState copyWith({
    int? totalFreezes,
    bool? activeFreeze,
    DateTime? lastFreeAdTimestamp,
  }) => FreezeState(
    totalFreezes: totalFreezes ?? this.totalFreezes,
    activeFreeze: activeFreeze ?? this.activeFreeze,
    lastFreeAdTimestamp: lastFreeAdTimestamp ?? this.lastFreeAdTimestamp,
  );

  bool get canWatchFreeAd {
    if (lastFreeAdTimestamp == null) return true;

    final difference = DateTime.now().difference(lastFreeAdTimestamp!);
    return difference.inHours >= AppValues.freeFreezeRewardHours;
  }

  Duration? get timeUntilNextFreeAd {
    if (lastFreeAdTimestamp == null) return null;

    final nextAvailable = lastFreeAdTimestamp!.add(const Duration(hours: AppValues.freeFreezeRewardHours));
    final difference = nextAvailable.difference(DateTime.now());

    return difference.isNegative ? null : difference;
  }

  @override
  List<Object> get props => [totalFreezes, activeFreeze, ?lastFreeAdTimestamp];
}
