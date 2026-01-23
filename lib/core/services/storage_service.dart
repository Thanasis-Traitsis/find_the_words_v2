import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _userBoxKey = "user_box";
  static const String _userKey = "current_user";
  static const String _stageBoxKey = "stage_box";
  static const String _stageKeyPrefix = "current_stage"; 

  late Box<UserModel> _userBox;
  late Box<CurrentStage> _stageBox;
  bool _isInitialized = false;

  String _getStageKey(AppLanguage language) {
    return "${_stageKeyPrefix}_${language.code}";
  }

  Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();

    // AuthService.instance.deleteToken();
    // await Hive.deleteBoxFromDisk(_userBoxKey);
    // await Hive.deleteBoxFromDisk(_stageBoxKey);

    // Register all adapters once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProfileStatusModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AppLanguageAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(WordsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CurrentStageAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(WordPlacementTrackerAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(WordPlacementAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(AccountBoostTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(AccountBoostModelAdapter());
    }

    _userBox = await Hive.openBox<UserModel>(_userBoxKey);
    _stageBox = await Hive.openBox<CurrentStage>(_stageBoxKey);
    _isInitialized = true;
  }

  /// Save or update the current user
  Future<void> saveUser(UserModel user) async {
    await _userBox.put(_userKey, user);
  }

  /// Load the current user (if any)
  UserModel? getUser() {
    return _userBox.get(_userKey);
  }

  /// Delete user data
  Future<void> deleteUser() async {
    if (!_isInitialized) await init();
    await _userBox.delete(_userKey);
  }

  /// Save or update the current stage
  Future<void> saveCurrentStage(
    CurrentStage stage,
    AppLanguage language,
  ) async {
    if (!_isInitialized) await init();
    await _stageBox.put(_getStageKey(language), stage);
  }

  /// Load the current stage (if any)
  CurrentStage? getCurrentStage(AppLanguage language) {
    return _stageBox.get(_getStageKey(language));
  }

  /// Delete current stage data (call when stage is completed)
  Future<void> deleteCurrentStage(AppLanguage language) async {
    if (!_isInitialized) await init();
    await _stageBox.delete(_getStageKey(language));
  }

  /// Check if there's a saved stage
  bool hasSavedStage(AppLanguage language) {
    return _stageBox.containsKey(_getStageKey(language));
  }

  /// Delete all saved stages (both languages)
  Future<void> deleteAllStages() async {
    if (!_isInitialized) await init();
    await _stageBox.delete(_getStageKey(AppLanguage.greek));
    await _stageBox.delete(_getStageKey(AppLanguage.english));
  }
}
