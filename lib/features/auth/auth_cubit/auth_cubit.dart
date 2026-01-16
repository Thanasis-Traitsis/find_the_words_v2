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
    print(userFirebaseDoc);
    return userFirebaseDoc;
  }

  Future<void> _syncUserData(UserEntity localUser) async {
    // Sync local data with Firebase
    // This should only run when online
  }

  Future<void> googleSignIn() async {
    try {
      // Attempt Google Sign-In
      final firebase_auth.UserCredential? userCredential = await AuthService
          .instance
          .signInWithGoogle();

      if (userCredential == null) {
        // User canceled - return to previous state
        debugPrint('Google Sign-In canceled');
        return;
      }

      final firebase_auth.User firebaseUser = userCredential.user!;

      final UserEntity localUser = await getUser();

      debugPrint('🔄 Starting sync for ${firebaseUser.email}');
      debugPrint('📱 Local guest user ID: ${localUser.id}');
      debugPrint('☁️ Firebase user ID: ${firebaseUser.uid}');

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

      emit(AuthAuthenticated(user: syncedUser));
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In exception: ${e.code} - ${e.description}');
      emit(
        AuthFailure(
          message: 'Google Sign-In failed: ${e.description ?? 'Unknown error'}',
        ),
      );
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
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

    UserEntity mergedUser;

    if (localScore > cloudScore) {
      debugPrint('📱 Local data is ahead - using local progress');
      mergedUser = UserEntity.authenticated(
        id: firebaseUser.uid, // ✅ Use Firebase UID
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        points: localUser.points,
        progressByLanguage: localUser.progressByLanguage,
        currentStage: localUser.currentStage,
        lastSyncedAt: DateTime.now(),
      );

      await _userRepo.updateFirebaseUser(mergedUser);
    } else if (cloudScore > localScore) {
      debugPrint('☁️ Cloud data is ahead - using cloud (returning player)');
      mergedUser = cloudUser.copyWith(
        username: cloudUser.username ?? firebaseUser.displayName,
        email: cloudUser.email ?? firebaseUser.email,
        lastSyncedAt: DateTime.now(),
      );
    } else {
      // ✅ Same level - merge carefully
      debugPrint('⚖️ Same level - merging both');
      mergedUser = _mergeProgressMaps(localUser, cloudUser, firebaseUser);
      await _userRepo.updateFirebaseUser(mergedUser);
    }

    return mergedUser;
  }

  UserEntity _mergeProgressMaps(
    UserEntity localUser,
    UserEntity cloudUser,
    firebase_auth.User firebaseUser,
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
    );
  }

  Future<UserEntity> _migrateGuestToAuthenticatedUser(
    UserEntity guestUser,
    firebase_auth.User firebaseUser,
  ) async {
    debugPrint('Migrating guest user ${guestUser.id} to authenticated user');

    // Save new token (Firebase UID)
    final String newToken = firebaseUser.uid;
    await AuthService.instance.saveToken(newToken);

    // // Update local user with Google info
    // final UserEntity updatedUser = await _userRepo.updateUserWithGoogleInfo(
    //   guestUser.id,
    //   firebaseUserId: firebaseUser.uid,
    //   name: firebaseUser.displayName,
    //   email: firebaseUser.email,
    //   photoUrl: firebaseUser.photoURL,
    // );

    // // Migrate guest data to Firebase under the new authenticated user
    // await _userRepo.migrateGuestDataToFirebase(
    //   guestUserId: guestUser.id,
    //   authenticatedUserId: firebaseUser.uid,
    // );

    // // Create/update user document in Firebase
    // await _userRepo.createOrUpdateFirebaseUser(updatedUser);

    // debugPrint('Migration complete: ${updatedUser.email}');
    return guestUser;
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
