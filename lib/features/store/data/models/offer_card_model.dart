import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:flutter/material.dart';

class OfferCardModel {
  final String key;
  final AccountBoostType boostType;
  final int costPoints;
  final int amount;

  OfferCardModel({
    String? key,
    required this.boostType,
    required this.costPoints,
    required this.amount,
  }) : key = key ?? '${boostType.name}_$amount';
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
