import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/di/service_locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<void> registerSplashCriticalDependencies() =>
    getIt.init(environmentFilter: NoEnvOrContainsAll({Env.minimal}));

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
