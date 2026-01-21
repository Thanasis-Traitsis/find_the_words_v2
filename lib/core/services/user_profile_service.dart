import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';

class UserProfileService {
  final UserRepository _userRepo;
  final AuthCubit _authCubit;
  final CloudSyncService _syncService;

  UserProfileService(this._userRepo, this._authCubit, this._syncService);

  Future<void> addFoundWord(String word) async {
    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;

    if (currentUser.currentProgress.wordsModel.words.containsKey(word)) return;

    final dictionaryService = getIt<DictionaryService>();
    final currentProgress = currentUser.currentProgress;

    final updatedWords = Map<String, dynamic>.from(
      currentProgress.wordsModel.words,
    )..[word] = dictionaryService.cachedDictionary[word]['words'];

    final updatedProgress = currentProgress.copyWith(
      words: WordsModel(words: updatedWords),
    );

    await _saveUpdatedProgress(updatedProgress, currentUser);
  }

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
}
