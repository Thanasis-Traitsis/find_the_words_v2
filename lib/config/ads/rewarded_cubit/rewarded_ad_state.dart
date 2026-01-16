part of 'rewarded_ad_cubit.dart';

abstract class RewardedAdState {
  const RewardedAdState();
}

class RewardedAdInitial extends RewardedAdState {}

class RewardedAdLoading extends RewardedAdState {
  final int retryAttempt;
  const RewardedAdLoading({this.retryAttempt = 0});
}

class RewardedAdLoaded extends RewardedAdState {
  final DateTime loadedAt;
  const RewardedAdLoaded({required this.loadedAt});
  
  bool get isExpired {
    return DateTime.now().difference(loadedAt) > const Duration(hours: 1);
  }
}

class RewardedAdFailed extends RewardedAdState {
  final String error;
  final int retryAttempt;
  const RewardedAdFailed({
    required this.error,
    this.retryAttempt = 0,
  });
}

class RewardedAdShowing extends RewardedAdState {}

extension RewardedAdStateX on RewardedAdState {
  bool get isAdReady {
    return this is RewardedAdLoaded && !(this as RewardedAdLoaded).isExpired;
  }
}