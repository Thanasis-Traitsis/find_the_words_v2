sealed class SplashState {
  const SplashState();
}

sealed class SplashPending extends SplashState {
  const SplashPending();
}

class SplashLoading extends SplashPending {
  const SplashLoading();
}

class SplashForceUpdate extends SplashPending {
  const SplashForceUpdate();
}

class SplashFailed extends SplashPending {
  final String message;
  const SplashFailed(this.message);
}

class SplashReady extends SplashState {
  const SplashReady();
}
