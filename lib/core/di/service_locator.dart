import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

// Everything AppLoader/SplashCubit need before AppBootstrapper.initialize()
// runs — annotated with @Environment(Env.minimal) at the class (or, for
// SharedPreferences/StorageService, the @module method) itself, so the
// bucket a dependency belongs to is visible on the dependency, not decided
// by which hand-written function a human filed it into.
@InjectableInit(preferRelativeImports: true)
Future<void> registerSplashCriticalDependencies() =>
    getIt.init(environmentFilter: NoEnvOrContainsAll({Env.minimal}));

// Everything else — registered once AppBootstrapper.initialize() runs, i.e.
// after the splash-critical dependencies above are already resolved.
//
// GetItHelper caches the EnvironmentFilter passed to the *first* getIt.init()
// call (under a fixed instance name) and silently reuses it on every later
// call, ignoring whatever filter is passed then — see injectable's
// GetItHelper constructor. Since registerSplashCriticalDependencies() above
// already called init() once with the minimal filter, that stale filter
// would otherwise still be in effect here, causing this call to try
// re-registering every minimal-env dependency (already registered) instead
// of applying the full filter. Clearing the cached filter first forces
// GetItHelper to pick up the new one.
Future<void> registerRemainingDependencies() async {
  if (getIt.isRegistered<EnvironmentFilter>(
    instanceName: kEnvironmentsFilterName,
  )) {
    getIt.unregister<EnvironmentFilter>(instanceName: kEnvironmentsFilterName);
  }
  if (getIt.isRegistered<Set<String>>(instanceName: kEnvironmentsName)) {
    getIt.unregister<Set<String>>(instanceName: kEnvironmentsName);
  }

  await getIt.init(environmentFilter: NoEnvOrContainsAll({Env.full}));
}
