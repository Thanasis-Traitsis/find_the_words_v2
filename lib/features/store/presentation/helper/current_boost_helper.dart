import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:flutter/widgets.dart';

class CurrentBoostHelper {
  static String getFormattedBoost(AccountBoostEntity boost) {
    if (boost.type == AccountBoostType.minutes) {
      return _formatDuration(boost.remainingDuration);
    } else {
      return "${boost.remainingAmount - 1}/${boost.totalAmount}";
    }
  }

  static String _formatDuration(Duration? duration) {
    if (duration == null) return "0:00";
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  static String getFormattedSubtitle(
    AccountBoostEntity boost,
    BuildContext context,
  ) {
    if (boost.type == AccountBoostType.minutes) {
      return context.translate.currentBoostXpMultiplierDurationSubtitle1;
    } else {
      return context.translate.currentBoostXpMultiplierStageSubtitle1(
        boost.remainingAmount,
      );
    }
  }
}
