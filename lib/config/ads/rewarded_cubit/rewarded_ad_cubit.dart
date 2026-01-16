import 'dart:async';

import 'package:find_the_words/config/ads/domain/rewarded_ad_usecase.dart';
import 'package:find_the_words/core/utils/snackbar_helper.dart';
import 'package:find_the_words/features/store/data/models/reward_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rewarded_ad_state.dart';

class RewardedAdCubit extends Cubit<RewardedAdState> {
  RewardedAd? _rewardedAd;
  Timer? _retryTimer;
  Timer? _expirationTimer;
  
  // Store the reward config and context when reward is earned
  RewardConfig? _pendingReward;
  BuildContext? _pendingContext;

  static const int _maxRetries = 3;
  static const Duration _adExpirationTime = Duration(hours: 1);

  RewardedAdCubit() : super(RewardedAdInitial());

  bool get isAdReady => state.isAdReady;

  Future<void> initialize() async {
    await loadAd();
  }

  Future<void> loadAd({int retryAttempt = 0}) async {
    if (state is RewardedAdLoading) {
      return;
    }

    if (isAdReady) {
      return;
    }

    emit(RewardedAdLoading(retryAttempt: retryAttempt));

    await RewardedAd.load(
      adUnitId: AppKeys.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _setupFullScreenCallbacks(ad);

          final loadedAt = DateTime.now();
          emit(RewardedAdLoaded(loadedAt: loadedAt));

          _scheduleAdRefresh();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          emit(
            RewardedAdFailed(error: error.message, retryAttempt: retryAttempt),
          );

          if (retryAttempt < _maxRetries) {
            _scheduleRetry(retryAttempt);
          }
        },
      ),
    );
  }

  /// Schedule retry with exponential backoff
  void _scheduleRetry(int retryAttempt) {
    _retryTimer?.cancel();

    final delaySeconds = 5 * (3 * retryAttempt + 1);

    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      loadAd(retryAttempt: retryAttempt + 1);
    });
  }

  /// Schedule ad refresh after 1 hour
  void _scheduleAdRefresh() {
    _expirationTimer?.cancel();

    _expirationTimer = Timer(_adExpirationTime, () {
      if (state is RewardedAdLoaded) {
        _rewardedAd?.dispose();
        _rewardedAd = null;
        loadAd();
      }
    });
  }

  void _setupFullScreenCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        emit(RewardedAdShowing());
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedAd = null;
        _pendingReward = null;
        _pendingContext = null;
        emit(RewardedAdFailed(error: err.message));
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        
        if (_pendingReward != null && _pendingContext != null) {
          if (_pendingContext!.mounted) {
            SnackbarHelper.showSuccessSnackbar(
              _pendingContext!,
              title: _pendingReward!.notificationTitle,
              message: _pendingReward!.notificationMessage,
            );
          }
          
          _pendingReward = null;
          _pendingContext = null;
        }
        
        emit(RewardedAdInitial());
        loadAd();
      },
      onAdImpression: (ad) {
        debugPrint('📊 RewardedAdCubit: Ad impression recorded');
      },
      onAdClicked: (ad) {
        debugPrint('👆 RewardedAdCubit: Ad clicked');
      },
    );
  }

  Future<void> showAd(RewardConfig rewardConfig, BuildContext context) async {
    if (!isAdReady || _rewardedAd == null) {
      if (state is RewardedAdLoaded && (state as RewardedAdLoaded).isExpired) {
        debugPrint('🔄 RewardedAdCubit: Ad expired, reloading...');
        _rewardedAd?.dispose();
        _rewardedAd = null;
        await loadAd();
      }

      return;
    }

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
        debugPrint('🎉 RewardedAdCubit: User earned reward');

        final useCase = RewardUseCaseFactory.create(config: rewardConfig);
        await useCase.execute();

        // Store the reward info to show snackbar later
        _pendingReward = rewardConfig;
        _pendingContext = context;
      },
    );
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    _expirationTimer?.cancel();
    _rewardedAd?.dispose();
    _pendingReward = null;
    _pendingContext = null;
    return super.close();
  }
}
