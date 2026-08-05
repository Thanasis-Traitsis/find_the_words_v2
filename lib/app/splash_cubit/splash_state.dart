sealed class SplashState {}

class SplashLoading extends SplashState {}
class SplashForceUpdate extends SplashState {}
class SplashFailed extends SplashState {
  final String message;
  SplashFailed(this.message);
}
class SplashReady extends SplashState {}