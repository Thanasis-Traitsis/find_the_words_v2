part of 'auth_cubit.dart';

enum AuthEffect {
  signInSuccess,
  signOutSuccess,
  signInFailure,
  signOutFailure,
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final bool signInOutLoading;
  final AuthEffect? effect;

  const AuthAuthenticated({
    required this.user,
    this.signInOutLoading = false,
    this.effect,
  });

  AuthAuthenticated copyWith({
    UserEntity? user,
    bool? signInOutLoading,
    AuthEffect? effect,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      signInOutLoading: signInOutLoading ?? this.signInOutLoading,
      effect: effect,
    );
  }

  AuthAuthenticated clearEffect() {
    return copyWith(effect: null);
  }

  @override
  List<Object> get props => [user, signInOutLoading, ?effect];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
