import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/repositories/user_repository_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingletonAsync<StorageService>(() async {
    final storage = StorageService();
    await storage.init();
    return storage;
  });

  final userRepository = UserRepositoryImpl();

  getIt.registerSingletonAsync<AuthCubit>(() async {
    return AuthCubit(userRepository);
  }, dependsOn: [StorageService]);

  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  await getIt.allReady();
}
