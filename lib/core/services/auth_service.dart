import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  static AuthService get instance => _instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _googleSignInInitialized = false;

  // Initialize Google Sign-In
  Future<void> initializeGoogleSignIn() async {
    if (_googleSignInInitialized) return;

    try {
      await GoogleSignIn.instance.initialize();
      _googleSignInInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  // Tokens methods
  Future<bool> userHasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppKeys.authTokenKey) != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppKeys.authTokenKey);
  }

  Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AppKeys.authTokenKey, token);
  }

  Future<bool> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(AppKeys.authTokenKey);
  }

  Future<void> deleteFirebaseUser(String userId) async {
    debugPrint('Deleting Firestore document for user: $userId');
    await FirebaseFirestore.instance
        .collection(AppKeys.usersFirebaseCollectionKey)
        .doc(userId)
        .delete();
    debugPrint('Firestore document deleted');
  }

  // Google Sign-In methods
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Ensure Google Sign-In is initialized
      if (!_googleSignInInitialized) {
        await initializeGoogleSignIn();
      }

      // Start the interactive sign-in flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Get the authentication object from the account
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      debugPrint('Google Sign-In successful: ${userCredential.user?.email}');
      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint('Google Sign-In canceled by user');
        return null;
      }
      debugPrint('Google Sign-In exception: ${e.code} - ${e.description}');
      rethrow;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        GoogleSignIn.instance.signOut(),
        _firebaseAuth.signOut(),
      ]);
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Apple Sign-In methods
  Future<UserCredential?> signInWithApple() async {
    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(oauthCredential);

      // Update display name if available and not already set
      if (userCredential.user != null && 
          userCredential.user!.displayName == null &&
          appleCredential.givenName != null) {
        final displayName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      debugPrint('Apple Sign-In successful: ${userCredential.user?.email}');
      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('Apple Sign-In canceled by user');
        return null;
      }
      debugPrint('Apple Sign-In exception: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error signing in with Apple: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await GoogleSignIn.instance.disconnect();
      await _firebaseAuth.signOut();
      debugPrint('Disconnect successful');
    } catch (e) {
      debugPrint('Error disconnecting: $e');
      rethrow;
    }
  }

  Future<void> clearLocalStorage() async {
    final prefs = getIt<SharedPreferences>();
    final storageService = getIt<StorageService>();

    const String langKey = AppKeys.languageCodeKey;
    final String? langCode = prefs.getString(langKey);

    await storageService.deleteUser();
    await prefs.clear();

    getIt<StoreDiscountService>().clearDiscount();
    getIt<AccountBoostCubit>().reset(); 
    getIt<FreezeCubit>().reset(); 
    await prefs.setString(langKey,langCode ?? AppLanguage.greek.code);
  }

  // Delete account - removes Firebase account (if signed in) and all local data
  Future<void> deleteAccount({
    required String userId,
    required bool isGuest,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      final hasFirebaseAccount = user != null && !user.isAnonymous;

      // Check if user has EVER authenticated with Firebase
      if (!hasFirebaseAccount || isGuest) {
        // Guest user - just clear local data
        debugPrint('Guest user: Clearing local data only');
        await clearLocalStorage();
        return;
      }

      // Authenticated user - delete Firebase account too
      // Step 1: Delete Firestore document
      await deleteFirebaseUser(userId);

      // Step 2: Delete Firebase Authentication account
      try {
        await user.delete();
        debugPrint('Firebase auth account deleted for: ${user.email}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          throw FirebaseAuthException(
            code: 'requires-recent-login',
            message: 'Please sign in again before deleting your account',
          );
        }
        rethrow;
      }

      // Step 3: Sign out from Google
      await GoogleSignIn.instance.signOut();

      // Step 4: Clear local storage
      await clearLocalStorage();

      debugPrint('✅ Complete account deletion successful');
    } catch (e) {
      debugPrint('❌ Error deleting account: $e');
      rethrow;
    }
  }

  Future<UserCredential?> reauthenticateWithApple() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Reauthenticate
      final userCredential = await user.reauthenticateWithCredential(
        oauthCredential,
      );
      debugPrint('Apple reauthentication successful');

      return userCredential;
    } catch (e) {
      debugPrint('Error reauthenticating with Apple: $e');
      rethrow;
    }
  }

  Future<UserCredential?> reauthenticateWithGoogle() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      if (!_googleSignInInitialized) {
        await initializeGoogleSignIn();
      }

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Reauthenticate
      final userCredential = await user.reauthenticateWithCredential(
        credential,
      );
      debugPrint('Reauthentication successful');

      return userCredential;
    } catch (e) {
      debugPrint('Error reauthenticating: $e');
      rethrow;
    }
  }

  User? get currentFirebaseUser => _firebaseAuth.currentUser;
  bool get isSignedIn => _firebaseAuth.currentUser != null;
}
