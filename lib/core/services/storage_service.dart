import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/models/progress_collection.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _userBoxKey = "user_box";
  static const String _progressBoxKey = "progress_box";

  static const String _userKey = "current_user";
  static const String _progressKey = "current_progress";

  late Box<UserModel> _userBox;
  late Box<ProgressCollection> _progressBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();

    // AuthService.instance.deleteToken();
    // await Hive.deleteBoxFromDisk(_userBoxKey);
    // await Hive.deleteBoxFromDisk(_progressBoxKey);

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
      Hive.registerAdapter(ProgressCollectionAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WordsModelAdapter());
    }

    _userBox = await Hive.openBox<UserModel>(_userBoxKey);
    _progressBox = await Hive.openBox(_progressBoxKey);
    _isInitialized = true;
  }

  // User
  Future<void> saveUser(UserModel user) async {
    await _userBox.put(_userKey, user);
  }

  UserModel? getUser() {
    return _userBox.get(_userKey);
  }

  Future<void> deleteUser() async {
    if (!_isInitialized) await init();
    await _userBox.delete(_userKey);
  }

  // ProgressStatus
  Future<void> saveProgressForLanguage(
    AppLanguage language,
    ProfileStatusModel progress,
  ) async {
    final allProgress = getAllProgress();
    allProgress[language] = progress;

    final Map<String, ProfileStatusModel> dataToSave = Map.fromEntries(
      allProgress.entries.map((e) => MapEntry(e.key.code, e.value)),
    );

    final collection = ProgressCollection(progressMap: dataToSave);
    await _progressBox.put(_progressKey, collection);
  }

  Map<AppLanguage, ProfileStatusModel> getAllProgress() {
    final collection = _progressBox.get(_progressKey);

    if (collection == null) {
      return {};
    }

    return Map.fromEntries(
      collection.progressMap.entries.map(
        (e) => MapEntry(AppLanguage.fromCode(e.key), e.value),
      ),
    );
  }

  ProfileStatusModel createInitialProgress(AppLanguage language) {
    return ProfileStatusModel(
      language: language,
      level: 1,
      progress: 0.0,
      stage: 1,
      wordsModel: WordsModel(words: {}),
    );
  }

  ProfileStatusModel getProgressForLanguage(AppLanguage language) {
    final allProgress = getAllProgress();
    return allProgress[language] ??
        ProfileStatusModel(
          language: language,
          level: 1,
          progress: 0.0,
          stage: 1,
          wordsModel: WordsModel(words: {}),
        );
  }
}
