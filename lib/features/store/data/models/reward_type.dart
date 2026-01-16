enum RewardType { earnPoints, storeDiscount, freeze }

class RewardConfig {
  final RewardType type;
  final int amount;
  final bool isActive;
  final String notificationTitle;
  final String notificationMessage;
  final Duration? notAvailableUntil; 

  const RewardConfig({
    required this.type,
    required this.amount,
    required this.isActive,
    required this.notificationTitle,
    required this.notificationMessage, 
    this.notAvailableUntil,
  });
}
