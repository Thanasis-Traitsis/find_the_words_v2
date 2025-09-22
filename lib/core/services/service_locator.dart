import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/repositories/user_repository_impl.dart';
import 'package:find_the_words/features/stage/domain/services/board_setup_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

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

  final wordService = WordSelectionService(prefs);
  final boardService = BoardSetupService();
  final stageGenService = StageGeneratorService(
    wordSelectionService: wordService,
    boardSetupService: boardService,
  );

  getIt.registerLazySingleton<StageBloc>(
    () => StageBloc(stageGeneratorService: stageGenService),
  );

  await getIt.allReady();
}
