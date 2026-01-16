import 'dart:async';

import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreDiscountService extends ChangeNotifier {
  int _discountPercentage = 0;
  DateTime? _discountExpiry;
  Timer? _expirationTimer;
  Timer? _tickTimer;

  StoreDiscountService._();

  static Future<StoreDiscountService> create() async {
    final service = StoreDiscountService._();
    await service.initialize();
    return service;
  }

  int get discountPercentage => _discountPercentage;
  bool get hasActiveDiscount => _discountPercentage > 0 && !_isExpired();

  Future<void> initialize() async {
    final prefs = getIt<SharedPreferences>();
    _discountPercentage = prefs.getInt(AppKeys.discountPercentageKey) ?? 0;

    final expiryMillis = prefs.getInt(AppKeys.discountExpiryKey);
    if (expiryMillis != null) {
      _discountExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMillis);
    }

    // Check if expired
    if (_isExpired()) {
      await clearDiscount();
    } else if (_discountExpiry != null) {
      _scheduleExpiration();
      _startTickTimer();
    }

    notifyListeners();
  }

  Future<void> activateDiscount({
    required int percentage,
    Duration duration = const Duration(hours: AppValues.discountRewardHours),
  }) async {
    _discountPercentage = percentage.clamp(0, 100);
    _discountExpiry = DateTime.now().add(duration);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppKeys.discountPercentageKey, _discountPercentage);
    await prefs.setInt(
      AppKeys.discountExpiryKey,
      _discountExpiry!.millisecondsSinceEpoch,
    );

    debugPrint(
      '🎁 Discount activated: $_discountPercentage% for ${duration.inHours}h',
    );

    _scheduleExpiration();
    _startTickTimer();

    notifyListeners();
  }

  void _scheduleExpiration() {
    _expirationTimer?.cancel();

    if (_discountExpiry == null) return;

    final timeUntilExpiry = _discountExpiry!.difference(DateTime.now());

    if (timeUntilExpiry.isNegative) {
      clearDiscount();
      return;
    }

    _expirationTimer = Timer(timeUntilExpiry, () {
      debugPrint('⏰ Discount expired - auto-clearing');
      clearDiscount();
    });
  }

  void _startTickTimer() {
    _tickTimer?.cancel();

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isExpired()) {
        timer.cancel();
        clearDiscount();
      } else {
        notifyListeners();
      }
    });
  }

  int getDiscountedPrice(int originalPrice) {
    if (!hasActiveDiscount) return originalPrice;
    final discount = (originalPrice * _discountPercentage / 100).round();
    return originalPrice - discount;
  }

  int getDiscountAmount(int originalPrice) {
    if (!hasActiveDiscount) return 0;
    return (originalPrice * _discountPercentage / 100).round();
  }

  bool _isExpired() {
    if (_discountExpiry == null) return true;
    return DateTime.now().isAfter(_discountExpiry!);
  }

  Duration? getRemainingTime() {
    if (_discountExpiry == null || _isExpired()) return null;
    return _discountExpiry!.difference(DateTime.now());
  }

  Future<void> clearDiscount() async {
    _discountPercentage = 0;
    _discountExpiry = null;

    _expirationTimer?.cancel();
    _tickTimer?.cancel();

    final prefs = getIt<SharedPreferences>();
    await prefs.remove(AppKeys.discountPercentageKey);
    await prefs.remove(AppKeys.discountExpiryKey);

    debugPrint('🗑️ Discount cleared');
    notifyListeners();
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    _tickTimer?.cancel();
    super.dispose();
  }
}
