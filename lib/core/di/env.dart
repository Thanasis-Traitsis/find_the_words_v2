/// Injectable environment names for the two-phase bootstrap:
/// [minimal] covers exactly what AppLoader/SplashCubit need before
/// AppBootstrapper.initialize() runs; [full] is everything else,
/// registered once the splash phase hands off to the ready app.
class Env {
  static const minimal = 'minimal';
  static const full = 'full';
}
