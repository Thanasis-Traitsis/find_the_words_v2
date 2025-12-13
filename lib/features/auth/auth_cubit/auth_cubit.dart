import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepo;

  AuthCubit(this._userRepo) : super(AuthLoading()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    await Future.delayed(Duration(seconds: 2));
    final bool hasToken = await AuthService.instance.userHasToken();

    if (hasToken) {
      try {
        final UserEntity user = await getUser();

        final bool hasInternet = await getIt<ConnectivityService>()
            .hasInternet();
        if (hasInternet) {
          try {
            final firebaseUser = await _checkFirebaseAuth(user.id);

            if (firebaseUser != null) {
              await _syncUserData(user);
            }
          } catch (e) {
            debugPrint('Firebase sync failed: $e');
          }
        } else {
          debugPrint('No internet - continuing in offline mode');
        }

        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    } else {
      final String newToken = TokenUtils.generateGuestToken();
      await AuthService.instance.saveToken(newToken);

      final UserEntity user = await _userRepo.createUser(newToken);

      emit(AuthAuthenticated(user: user));
    }
  }

  Future<UserEntity> getUser() async {
    final UserEntity user = await _userRepo.getCurrentUser();
    return user;
  }

  Future<DocumentSnapshot?> _checkFirebaseAuth(String userId) async {
    final userFirebaseDoc = await _userRepo.getFirebaseUser(userId);
    return userFirebaseDoc;
  }

  Future<void> _syncUserData(UserEntity localUser) async {
    // Sync local data with Firebase
    // This should only run when online
  }

  Future<void> addFoundWord(String word) async {
    if (state is! AuthAuthenticated) return;

    final currentUser = (state as AuthAuthenticated).user;

    if (currentUser.currentProgress.wordsModel.words.containsKey(word)) return;

    final dictionaryService = getIt<DictionaryService>();
    final currentProgress = currentUser.currentProgress;

    final updatedWords = Map<String, dynamic>.from(
      currentProgress.wordsModel.words,
    )..[word] = dictionaryService.cachedDictionary[word]['words'];

    final updatedProgress = currentProgress.copyWith(
      words: WordsModel(words: updatedWords),
    );

    await _saveUpdatedProgress(updatedProgress, currentUser as UserModel);
  }

  Future<void> updateAfterStage(int xpEarned, double newProgress) async {
    if (state is! AuthAuthenticated) return;

    final currentUser = (state as AuthAuthenticated).user;
    final currentProgress = currentUser.currentProgress;

    final updatedProgress = currentProgress.copyWith(
      stage: currentProgress.stage + 1,
      progress: newProgress >= 100 ? 0 : newProgress,
      level: newProgress >= 100
          ? currentProgress.level + 1
          : currentProgress.level,
    );

    await _saveUpdatedProgress(updatedProgress, currentUser as UserModel);
  }

  Future<void> _saveUpdatedProgress(
    ProfileStatusModel updatedProgress,
    UserModel currentUser,
  ) async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    final updatedProgressMap = Map<AppLanguage, ProfileStatusModel>.from(
      currentUser.progressByLanguage,
    )..[currentLang] = updatedProgress;

    final updatedUser = currentUser.copyWith(
      progressByLanguage: updatedProgressMap,
    );

    await getIt<StorageService>().saveUser(updatedUser);
    emit(AuthAuthenticated(user: updatedUser));
  }

  void onLanguageChanged(AppLanguage newLanguage) {
    if (state is! AuthAuthenticated) return;

    final currentUser = (state as AuthAuthenticated).user;

    if (!currentUser.progressByLanguage.containsKey(newLanguage)) {
      final updatedProgressMap = Map<AppLanguage, ProfileStatusModel>.from(
        currentUser.progressByLanguage,
      )..[newLanguage] = ProfileStatusModel.initial(newLanguage);

      final updatedUser = UserModel(
        id: currentUser.id,
        username: currentUser.username,
        points: currentUser.points,
        progressByLanguage: updatedProgressMap,
        currentStage: null,
      );

      getIt<StorageService>().saveUser(updatedUser);
      emit(AuthAuthenticated(user: updatedUser));
    } else {
      final updatedUser = UserModel(
        id: currentUser.id,
        username: currentUser.username,
        points: currentUser.points,
        progressByLanguage: Map<AppLanguage, ProfileStatusModel>.from(
          currentUser.progressByLanguage,
        ),
        currentStage: currentUser.currentStage,
      );

      emit(AuthAuthenticated(user: updatedUser));
    }
  }
}
