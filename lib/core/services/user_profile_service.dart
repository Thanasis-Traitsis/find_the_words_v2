import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/stage/data/datasources/stage_local_datasource.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';

class UserProfileService {
  final UserRepository _userRepo;
  final AuthCubit _authCubit;
  final CloudSyncService _syncService;
  final StageLocalDataSource _localDataSource;

  UserProfileService(
    this._userRepo,
    this._authCubit,
    this._syncService,
    this._localDataSource,
  );

  Future<void> addFoundWord(String? word) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;
    final currentProgress = currentUser.currentProgress;

    if (word == null) {
      await _saveUpdatedProgress(currentProgress, currentUser);
    } else {
      if (currentUser.currentProgress.wordsModel.words.containsKey(word)) return;

      final dictionaryService = getIt<DictionaryService>();

      final updatedWords = Map<String, dynamic>.from(
        currentProgress.wordsModel.words,
      )..[word] = dictionaryService.cachedDictionary[word]['words'];

      final updatedProgress = currentProgress.copyWith(
        words: WordsModel(words: updatedWords),
      );

      await _saveUpdatedProgress(updatedProgress, currentUser);
      // await addTestWords();
    }
  }

  // Future<void> addTestWords({int count = 1000}) async {
  //   final authState = _authCubit.state;
  //   if (authState is! AuthAuthenticated) return;

  //   final currentUser = authState.user;
  //   final currentProgress = currentUser.currentProgress;
  //   final dictionaryService = getIt<DictionaryService>();

  //   debugPrint('📝 Adding $count test words...');

  //   // Get all available words from dictionary
  //   final allDictionaryWords = dictionaryService.cachedDictionary.keys.toList();

  //   if (allDictionaryWords.isEmpty) {
  //     debugPrint('❌ Dictionary is empty!');
  //     return;
  //   }

  //   // Shuffle and take up to count words
  //   allDictionaryWords.shuffle();
  //   final wordsToAdd = allDictionaryWords.take(count).toList();

  //   // Create updated words map
  //   final updatedWords = Map<String, dynamic>.from(
  //     currentProgress.wordsModel.words,
  //   );

  //   for (final word in wordsToAdd) {
  //     updatedWords[word] = dictionaryService.cachedDictionary[word]['words'];
  //   }

  //   debugPrint('✅ Added ${wordsToAdd.length} words');

  //   final updatedProgress = currentProgress.copyWith(
  //     words: WordsModel(words: updatedWords),
  //   );

  //   await _saveUpdatedProgress(updatedProgress, currentUser);

  //   debugPrint('💾 Saved to storage');
  // }

  Future<void> updateAfterStage(int xpEarned, double newProgress) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;
    final currentProgress = currentUser.currentProgress;

    final updatedProgress = currentProgress.copyWith(
      stage: currentProgress.stage + 1,
      progress: newProgress >= 100 ? 0 : newProgress,
      level: newProgress >= 100
          ? currentProgress.level + 1
          : currentProgress.level,
      clearCurrentStage: true,
    );

    await _saveUpdatedProgress(updatedProgress, currentUser);
  }

  Future<void> onLanguageChanged(AppLanguage newLanguage) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;

    if (!currentUser.progressByLanguage.containsKey(newLanguage)) {
      final updatedProgressMap = Map<AppLanguage, ProfileStatusModel>.from(
        currentUser.progressByLanguage,
      )..[newLanguage] = ProfileStatusModel.initial(newLanguage);

      final updatedUser = currentUser.copyWith(
        progressByLanguage: updatedProgressMap,
      );

      await _userRepo.updateUser(updatedUser);
      _authCubit.updateUser(updatedUser);
    }
  }

  Future<void> _saveUpdatedProgress(
    ProfileStatusModel updatedProgress,
    UserEntity currentUser,
  ) async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    final updatedProgressMap = Map<AppLanguage, ProfileStatusModel>.from(
      currentUser.progressByLanguage,
    )..[currentLang] = updatedProgress;

    final updatedUser = currentUser.copyWith(
      progressByLanguage: updatedProgressMap,
    );

    // Save to Hive
    await _userRepo.updateUser(updatedUser);

    // Refresh from storage (gets CurrentStage from Hive)
    final refreshedUser = await _userRepo.refreshUserFromStorage();

    // Update AuthCubit
    _authCubit.updateUser(refreshedUser);

    // Trigger cloud sync
    if (!refreshedUser.isGuest) {
      _syncService.scheduleSync(refreshedUser);
    }
  }

  Future<void> updateFreezeStatus({
    required AppLanguage language,
    required bool activeFreeze,
    int? totalFreezes,
  }) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;
    final profileStatus = currentUser.progressByLanguage[language];

    if (profileStatus == null) {
      return;
    }

    final currentStage = profileStatus.currentStage;
    if (currentStage == null) {
      return;
    }

    // Update CurrentStage with new activeFreeze
    final updatedCurrentStage = currentStage.copyWith(
      activeFreeze: activeFreeze,
    );

    // Update ProfileStatusModel with updated CurrentStage
    final updatedProfileStatus = profileStatus.copyWith(
      currentStage: updatedCurrentStage,
    );

    // Update progressByLanguage map
    final updatedProgressByLanguage = Map<AppLanguage, ProfileStatusModel>.from(
      currentUser.progressByLanguage,
    );
    updatedProgressByLanguage[language] = updatedProfileStatus;

    // Update user with new progress and optionally new totalFreezes
    final updatedUser = currentUser.copyWith(
      progressByLanguage: updatedProgressByLanguage,
      totalFreezes: totalFreezes,
      lastSyncedAt: DateTime.now(),
    );

    await _localDataSource.saveStage(updatedCurrentStage, language);
    await _userRepo.updateUser(updatedUser);
    _authCubit.updateUser(updatedUser);

    if (!updatedUser.isGuest) {
      _syncService.scheduleSync(updatedUser);
    }
  }

  Future<void> updateUserTotalFreezes(int totalFreezes) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final updatedUser = authState.user.copyWith(
      totalFreezes: totalFreezes,
      lastSyncedAt: DateTime.now(),
    );

    // Save locally
    await _userRepo.updateUser(updatedUser);

    // Update AuthCubit state
    _authCubit.updateUser(updatedUser);

    // Sync to Firebase if not guest
    if (!updatedUser.isGuest) {
      _syncService.scheduleSync(updatedUser);
    }
  }

  Future<void> saveStage(CurrentStage stage) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;
    final currentProgress = currentUser.currentProgress;

    final updatedProgress = currentProgress.copyWith(currentStage: stage);

    await _saveUpdatedProgress(updatedProgress, currentUser);
  }
}
