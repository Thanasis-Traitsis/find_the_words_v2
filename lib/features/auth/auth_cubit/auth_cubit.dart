import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/data/models/firebase_user_model.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/auth/data/models/user_model.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepo;

  AuthCubit(this._userRepo) : super(AuthLoading()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    await Future.delayed(Duration(seconds: 2));

    // Step 1: Check Firebase authentication
    final firebase_auth.User? firebaseUser =
        AuthService.instance.currentFirebaseUser;

    if (firebaseUser != null) {
      await _handleAuthenticatedUser(firebaseUser);
      return;
    }

    // Step 2: Check local storage for guest user
    final bool hasToken = await AuthService.instance.userHasToken();

    if (hasToken) {
      try {
        final UserEntity user = await getUser();
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        await _createNewUser();
      }
      return;
    }

    // Step 3: Create new guest user
    await _createNewUser();
  }

  Future<void> signOut() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      await AuthService.instance.signOut();

      if (state is! AuthAuthenticated) return;

      final currentUser = (state as AuthAuthenticated).user;
      final guestUser = UserModel.guest(
        id: currentUser.id,
        points: currentUser.points,
        progressByLanguage: currentUser.progressByLanguage,
        currentStage: currentUser.currentStage,
        lastSyncedAt: currentUser.lastSyncedAt,
        joinedAt: currentUser.joinedAt,
      );

      await getIt<StorageService>().saveUser(guestUser);
      emit(
        AuthAuthenticated(user: guestUser, effect: AuthEffect.signOutSuccess),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signOutFailure,
        ),
      );
    }
  }

  Future<void> _handleAuthenticatedUser(firebase_auth.User firebaseUser) async {
    try {
      final bool hasInternet = await getIt<ConnectivityService>().hasInternet();

      // If not WiFi - Just return local user
      if (!hasInternet) {
        try {
          final localUser = await getUser();
          emit(AuthAuthenticated(user: localUser));
          return;
        } catch (e) {
          await _createUserFromFirebaseAuth(firebaseUser);
          return;
        }
      }

      UserEntity? localUser;
      try {
        localUser = await getUser();
      } catch (e) {
        debugPrint('No local user found');
      }

      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);

      // Firebase user exists but without any data
      if (cloudUserDoc == null || !cloudUserDoc.exists) {
        final newUser = UserEntity.authenticated(
          id: firebaseUser.uid,
          username: firebaseUser.displayName,
          email: firebaseUser.email,
          points: localUser?.points ?? AppValues.startingPoints,
          progressByLanguage:
              localUser?.progressByLanguage ??
              {
                AppLanguage.english: ProfileStatusModel.initial(
                  AppLanguage.english,
                ),
                AppLanguage.greek: ProfileStatusModel.initial(
                  AppLanguage.greek,
                ),
              },
          currentStage: localUser?.currentStage,
          lastSyncedAt: DateTime.now(),
          joinedAt: localUser?.joinedAt ?? DateTime.now(),
        );

        await _userRepo.createFirebaseUser(newUser);
        await _saveCloudUserAndToken(newUser, firebaseUser.uid);

        emit(AuthAuthenticated(user: newUser));
        return;
      }

      // Firebase user exists - sync local/cloud data
      UserEntity? syncedUser;
      final cloudData = cloudUserDoc.data() as Map<String, dynamic>;
      final firebaseModel = FirebaseUserModel.fromFirestore(cloudData);
      final cloudUser = firebaseModel.toEntity();
      if (localUser != null) {
        syncedUser = await _mergeUserData(localUser, cloudUser, firebaseUser);
      }

      // Save to local storage
      await _saveCloudUserAndToken(syncedUser ?? cloudUser, firebaseUser.uid);

      emit(AuthAuthenticated(user: cloudUser));
    } catch (e) {
      await _handleAuthenticatedUserFallback(firebaseUser);
    }
  }

  Future<void> _handleAuthenticatedUserFallback(
    firebase_auth.User firebaseUser,
  ) async {
    try {
      final localUser = await getUser();

      if (localUser.id == firebaseUser.uid) {
        emit(AuthAuthenticated(user: localUser));
        return;
      } else {
        await _createUserFromFirebaseAuth(firebaseUser);
        return;
      }
    } catch (e) {
      await _createUserFromFirebaseAuth(firebaseUser);
    }
  }

  Future<void> _createUserFromFirebaseAuth(
    firebase_auth.User firebaseUser,
  ) async {
    try {
      final newUser = UserEntity.authenticated(
        id: firebaseUser.uid,
        username: firebaseUser.displayName,
        email: firebaseUser.email,
        points: AppValues.startingPoints,
        progressByLanguage: {
          AppLanguage.english: ProfileStatusModel.initial(AppLanguage.english),
          AppLanguage.greek: ProfileStatusModel.initial(AppLanguage.greek),
        },
        lastSyncedAt: DateTime.now(),
        joinedAt: DateTime.now(),
      );

      await _saveCloudUserAndToken(newUser, firebaseUser.uid);
      await _userRepo.updateFirebaseUser(newUser);

      emit(AuthAuthenticated(user: newUser));
    } catch (e) {
      emit(
        AuthFailure(
          message:
              'Failed to initialize user. Please try again or contact support.',
        ),
      );
    }
  }

  Future<void> _saveCloudUserAndToken(UserEntity user, String id) async {
    final userModel = UserModel.fromEntity(user);
    await getIt<StorageService>().saveUser(userModel);
    await AuthService.instance.saveToken(id);
  }

  Future<void> _createNewUser() async {
    final String newToken = TokenUtils.generateGuestToken();
    await AuthService.instance.saveToken(newToken);

    final UserEntity user = await _userRepo.createUser(newToken);

    emit(AuthAuthenticated(user: user));
  }

  Future<UserEntity> getUser() async {
    final UserEntity user = await _userRepo.getCurrentUser();
    return user;
  }

  Future<void> googleSignIn() async {
    if (state is! AuthAuthenticated) return;
    final currentState = state as AuthAuthenticated;
    emit(currentState.copyWith(signInOutLoading: true));

    try {
      // Attempt Google Sign-In
      final firebase_auth.UserCredential? userCredential = await AuthService
          .instance
          .signInWithGoogle();

      if (userCredential == null) {
        // User canceled - return to previous state
        debugPrint('Google Sign-In canceled');
        emit(
          currentState.copyWith(
            signInOutLoading: false,
            effect: AuthEffect.signInFailure,
          ),
        );
        return;
      }

      final firebase_auth.User firebaseUser = userCredential.user!;
      final UserEntity localUser = await getUser();
      final cloudUserDoc = await _userRepo.getFirebaseUser(firebaseUser.uid);

      UserEntity syncedUser;

      if (cloudUserDoc == null || !cloudUserDoc.exists) {
        // ✅ NEW USER - Upload local guest data to cloud with Firebase UID
        debugPrint('☁️ No cloud data found - uploading local data');
        syncedUser = await _uploadLocalToCloud(localUser, firebaseUser);
      } else {
        // ✅ EXISTING USER - This person signed in before
        final cloudData = cloudUserDoc.data() as Map<String, dynamic>;
        final firebaseModel = FirebaseUserModel.fromFirestore(cloudData);
        final cloudUser = firebaseModel.toEntity(
          currentStage: localUser.currentStage,
        );

        debugPrint('☁️ Cloud user level: ${cloudUser.totalLevel}');
        syncedUser = await _mergeUserData(localUser, cloudUser, firebaseUser);
      }

      final UserModel updatedUser = UserModel.fromEntity(syncedUser);
      await getIt<StorageService>().saveUser(updatedUser);
      await AuthService.instance.saveToken(firebaseUser.uid);

      emit(
        AuthAuthenticated(user: syncedUser, effect: AuthEffect.signInSuccess),
      );
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In exception: ${e.code} - ${e.description}');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      emit(
        currentState.copyWith(
          signInOutLoading: false,
          effect: AuthEffect.signInFailure,
        ),
      );
    }
  }

  Future<UserEntity> _uploadLocalToCloud(
    UserEntity localUser,
    firebase_auth.User firebaseUser,
  ) async {
    final newUser = UserEntity.authenticated(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      email: firebaseUser.email,
      points: localUser.points,
      progressByLanguage: localUser.progressByLanguage,
      currentStage: localUser.currentStage,
      lastSyncedAt: DateTime.now(),
      joinedAt: localUser.joinedAt,
    );

    // Upload to Firestore with Firebase UID as document ID
    await _userRepo.createFirebaseUser(newUser);

    debugPrint(
      '📤 Uploaded local guest data to cloud with ID: ${firebaseUser.uid}',
    );
    return newUser;
  }

  Future<UserEntity> _mergeUserData(
    UserEntity localUser,
    UserEntity cloudUser,
    firebase_auth.User firebaseUser,
  ) async {
    final localScore = localUser.totalProgressScore;
    final cloudScore = cloudUser.totalProgressScore;

    debugPrint('🔀 Merging: Local=$localScore vs Cloud=$cloudScore');

    final earliestJoinedAt = localUser.joinedAt.isBefore(cloudUser.joinedAt)
        ? localUser.joinedAt
        : cloudUser.joinedAt;

    UserEntity mergedUser;

    if (localScore > cloudScore) {
      debugPrint('📱 Local data is ahead - using local progress');
      mergedUser = UserEntity.authenticated(
        id: firebaseUser.uid,
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        points: localUser.points,
        progressByLanguage: localUser.progressByLanguage,
        currentStage: localUser.currentStage,
        lastSyncedAt: DateTime.now(),
        joinedAt: earliestJoinedAt,
      );

      await _userRepo.updateFirebaseUser(mergedUser);
    } else if (cloudScore > localScore) {
      debugPrint('☁️ Cloud data is ahead - using cloud (returning player)');
      mergedUser = cloudUser.copyWith(
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        lastSyncedAt: DateTime.now(),
        joinedAt: earliestJoinedAt,
      );
    } else {
      // ✅ Same level - merge carefully
      debugPrint('⚖️ Same level - merging both');
      mergedUser = _mergeProgressMaps(
        localUser,
        cloudUser,
        firebaseUser,
        earliestJoinedAt,
      );
      await _userRepo.updateFirebaseUser(mergedUser);
    }

    return mergedUser;
  }

  UserEntity _mergeProgressMaps(
    UserEntity localUser,
    UserEntity cloudUser,
    firebase_auth.User firebaseUser,
    DateTime joinedAt,
  ) {
    final mergedProgress = <AppLanguage, ProfileStatusModel>{};

    // ✅ Merge each language separately with better comparison
    for (final language in AppLanguage.values) {
      final localProgress = localUser.progressByLanguage[language];
      final cloudProgress = cloudUser.progressByLanguage[language];

      if (localProgress == null && cloudProgress == null) {
        // Neither has this language
        continue;
      } else if (localProgress == null) {
        // Only cloud has this language
        mergedProgress[language] = cloudProgress!;
      } else if (cloudProgress == null) {
        // Only local has this language
        mergedProgress[language] = localProgress;
      } else {
        // ✅ Both have this language - compare level + progress
        final localScore = localProgress.level + (localProgress.progress / 100);
        final cloudScore = cloudProgress.level + (cloudProgress.progress / 100);

        if (localScore > cloudScore) {
          debugPrint(
            '   ${language.displayName}: Using local (L${localProgress.level} ${localProgress.progress}% vs L${cloudProgress.level} ${cloudProgress.progress}%)',
          );
          mergedProgress[language] = localProgress;
        } else if (cloudScore > localScore) {
          debugPrint(
            '   ${language.displayName}: Using cloud (L${cloudProgress.level} ${cloudProgress.progress}% vs L${localProgress.level} ${localProgress.progress}%)',
          );
          mergedProgress[language] = cloudProgress;
        } else {
          // ✅ Exactly equal - prefer local (or you could prefer cloud, or merge words)
          debugPrint('   ${language.displayName}: Equal - using local');
          mergedProgress[language] = localProgress;
        }
      }
    }

    return UserEntity.authenticated(
      id: firebaseUser.uid,
      username: cloudUser.username ?? firebaseUser.displayName,
      email: cloudUser.email ?? firebaseUser.email,
      points: localUser.points > cloudUser.points
          ? localUser.points
          : cloudUser.points,
      progressByLanguage: mergedProgress,
      lastSyncedAt: DateTime.now(),
      joinedAt: joinedAt,
    );
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

      final updatedUser = currentUser.copyWith(
        progressByLanguage: updatedProgressMap,
        currentStage: null,
      );

      getIt<StorageService>().saveUser(updatedUser as UserModel);
      emit(AuthAuthenticated(user: updatedUser));
    } else {
      final updatedUser = currentUser.copyWith(
        progressByLanguage: Map<AppLanguage, ProfileStatusModel>.from(
          currentUser.progressByLanguage,
        ),
        currentStage: currentUser.currentStage,
      );

      emit(AuthAuthenticated(user: updatedUser));
    }
  }
}
