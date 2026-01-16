import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  User? get currentFirebaseUser => _firebaseAuth.currentUser;
  bool get isSignedIn => _firebaseAuth.currentUser != null;
}
