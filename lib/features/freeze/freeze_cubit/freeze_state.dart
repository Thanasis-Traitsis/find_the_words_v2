part of 'freeze_cubit.dart';

class FreezeState extends Equatable {
  final int totalFreezes;
  final Map<String, bool> activeFreezeByLanguage;
  final DateTime? lastFreeAdTimestamp;

  const FreezeState({
    this.totalFreezes = 0,
    this.activeFreezeByLanguage = const {},
    this.lastFreeAdTimestamp,
  });

  const FreezeState.initial()
    : totalFreezes = 0,
      activeFreezeByLanguage = const {},
      lastFreeAdTimestamp = null;

  FreezeState copyWith({
    int? totalFreezes,
    Map<String, bool>? activeFreezeByLanguage,
    DateTime? lastFreeAdTimestamp,
  }) => FreezeState(
    totalFreezes: totalFreezes ?? this.totalFreezes,
    activeFreezeByLanguage:
        activeFreezeByLanguage ?? this.activeFreezeByLanguage,
    lastFreeAdTimestamp: lastFreeAdTimestamp ?? this.lastFreeAdTimestamp,
  );

  bool isLanguageFrozen(AppLanguage language) {
    return activeFreezeByLanguage[language.code] ?? false;
  }

  bool get activeFreeze {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    return isLanguageFrozen(currentLang);
  }

  bool get canWatchFreeAd {
    if (lastFreeAdTimestamp == null) return true;

    final difference = DateTime.now().difference(lastFreeAdTimestamp!);
    return difference.inHours >= AppValues.freeFreezeRewardHours;
  }

  Duration? get timeUntilNextFreeAd {
    if (lastFreeAdTimestamp == null) return null;

    final nextAvailable = lastFreeAdTimestamp!.add(
      const Duration(hours: AppValues.freeFreezeRewardHours),
    );
    final difference = nextAvailable.difference(DateTime.now());

    return difference.isNegative ? null : difference;
  }

  @override
  List<Object?> get props => [
    totalFreezes,
    activeFreezeByLanguage,
    lastFreeAdTimestamp,
  ];
}
