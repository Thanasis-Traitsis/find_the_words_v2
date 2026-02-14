import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppKeys {
  static const String themeModeKey = 'app_theme_mode';
  static const String languageCodeKey = 'language_code';
  static const String soundKey = 'sound_enabled';
  static const String authTokenKey = 'auth_token';
  static const String totalFreezesKey = 'total_freezes_key';
  static const String activeFreezeKey = 'active_freeze_key';
  static const String lastFreeAdTimestampKey = 'last_free_ad_timestamp_key';
  static String previousStageWordsKey(String langCode) => 'prev_stage_$langCode';
  static String timerKey(int stage) => 'timer_key_$stage';

  static const String usedStageKey = 'used_stage';
  static const String bannedStageKey = 'banned_stage';
  static const String failedWords = 'failed_words';

  static const String bannedWords = 'banned_words';
  static const String greekBannedWordsId = 'greek_words';
  static const String englishBannedWordsId = 'english_words';

  static const String boardPlaceholder = '/';
  static const String boardBannedPlace = '//';

  static const String usersFirebaseCollectionKey = 'new_users';

  static const String discountPercentageKey = 'store_discount_percentage';
  static const String discountExpiryKey = 'store_discount_expiry';

  // Email account
  static const String emailAccount = 'infofindthewords@gmail.com';

  // AdMob Keys - Debug mode
  static const String _androidAdsDebugKey = "ca-app-pub-3940256099942544/5224354917";
  static const String _iosAdsDebugKey = "ca-app-pub-3940256099942544/1712485313";

  // AdMob Keys - Production mode (replace with your real ad unit IDs)
  static const String _androidAdsProdKey = "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY";
  static const String _iosAdsProdKey = "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY";

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android
          ? _androidAdsDebugKey
          : _iosAdsDebugKey;
    } else {
      return defaultTargetPlatform == TargetPlatform.android
          ? _androidAdsProdKey
          : _iosAdsProdKey;
    }
  }

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();
}
