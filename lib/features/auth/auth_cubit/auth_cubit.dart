import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/data/repositories/user_repository_impl.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with ChangeNotifier {
  final UserRepositoryImpl _userRepo;

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

  @override
  void emit(AuthState state) {
    super.emit(state);
    notifyListeners();
  }
}
