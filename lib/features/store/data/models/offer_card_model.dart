import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:flutter/material.dart';

class OfferCardModel {
  final String key;
  final AccountBoostType boostType;
  final int originalCostPoints;
  final int amount;

  OfferCardModel({
    String? key,
    required this.boostType,
    required this.originalCostPoints,
    required this.amount,
  }) : key = key ?? '${boostType.name}_$amount';

  int getActualCost() {
    final discountService = getIt<StoreDiscountService>();
    return discountService.getDiscountedPrice(originalCostPoints);
  }

  int getDiscountAmount() {
    final discountService = getIt<StoreDiscountService>();
    return discountService.getDiscountAmount(originalCostPoints);
  }

  bool hasDiscount() {
    final discountService = getIt<StoreDiscountService>();
    return discountService.hasActiveDiscount;
  }
}

extension SubtitleOfferCard on AccountBoostType {
  String subtitle(BuildContext context, int amount) {
    switch (this) {
      case AccountBoostType.minutes:
        return context.translate.xpMultiplierFirstOfferCardText(amount);
      case AccountBoostType.stages:
        return context.translate.xpMultiplierSecondOfferCardText(amount);
    }
  }
}
