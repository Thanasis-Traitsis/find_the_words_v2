import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';

class AccountBoostEntity {
  final String activeKey;
  final AccountBoostType type;
  final int multiplier;
  final int totalAmount;
  final int remainingAmount;
  final DateTime activatedAt;

  AccountBoostEntity({
    required this.activeKey,
    required this.type,
    required this.multiplier,
    required this.totalAmount,
    required this.remainingAmount,
    required this.activatedAt,
  });

  bool get isActive => remainingAmount > 0;

  double get progressPercentage {
    if (totalAmount == 0) return 0;
    return ((totalAmount - remainingAmount) / totalAmount * 100).clamp(0, 100);
  }

  bool get isExpired {
    if (type != AccountBoostType.minutes) return false;
    final expiryTime = activatedAt.add(Duration(minutes: totalAmount));
    return DateTime.now().isAfter(expiryTime);
  }

  Duration? get remainingDuration {
    if (type != AccountBoostType.minutes) return null;
    final expiryTime = activatedAt.add(Duration(minutes: totalAmount));
    final remaining = expiryTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  AccountBoostEntity decrementStage() {
    if (type != AccountBoostType.stages) return this;
    return AccountBoostEntity(
      activeKey: activeKey,
      type: type,
      multiplier: multiplier,
      totalAmount: totalAmount,
      remainingAmount: (remainingAmount - 1).clamp(0, totalAmount),
      activatedAt: activatedAt,
    );
  }

  factory AccountBoostEntity.activate({
    required String activeKey,
    required AccountBoostType type,
    required int multiplier,
    required int amount,
  }) {
    return AccountBoostEntity(
      activeKey: activeKey,
      type: type,
      multiplier: multiplier,
      totalAmount: amount,
      remainingAmount: amount,
      activatedAt: DateTime.now(),
    );
  }
}
