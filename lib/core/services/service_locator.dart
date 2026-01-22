import 'package:find_the_words/config/ads/rewarded_cubit/rewarded_ad_cubit.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/cloud_sync_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/previous_stage_words_service.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/auth/data/repositories/user_repository_impl.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/settings/domain/usecases/open_email_usecase.dart';
import 'package:find_the_words/features/settings/presentation/settings_cubit/settings_cubit.dart';
import 'package:find_the_words/features/stage/data/datasources/stage_local_datasource.dart';
import 'package:find_the_words/features/stage/data/repositories/stage_repository_impl.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/services/board_setup_service.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';
import 'package:find_the_words/features/stage/domain/usecases/check_intersection_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/crossword_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/load_stage_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/reveal_letter_usecase.dart';
import 'package:find_the_words/features/stage/domain/usecases/submit_word_usecase.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _registerCoreServices();
  await _registerRepositories();
  await _registerUsecases();
  await _registerBlocs();

  await getIt.allReady();
}

Future<void> _registerCoreServices() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingletonAsync<StorageService>(() async {
    final storage = StorageService();
    await storage.init();
    return storage;
  });

  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<PreviousStageWordsService>(
    () => PreviousStageWordsService(),
  );

  getIt.registerSingletonAsync<StoreDiscountService>(
    () async => StoreDiscountService.create(),
  );

  getIt.registerSingletonAsync<DictionaryService>(() async {
    final service = DictionaryService();
    return service;
  });
}

Future<void> _registerRepositories() async {
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<StorageService>()),
  );

  getIt.registerLazySingleton<StageRepository>(() {
    final wordService = WordSelectionService(getIt<SharedPreferences>());
    final boardService = BoardSetupService();
    final generatorService = StageGeneratorService(
      wordSelectionService: wordService,
      boardSetupService: boardService,
      prefs: getIt<SharedPreferences>(),
    );

    return StageRepositoryImpl(
      localDataSource: StageLocalDataSource(),
      generatorService: generatorService,
      previousStageWordsService: getIt<PreviousStageWordsService>(),
    );
  });
}

Future<void> _registerUsecases() async {
  getIt.registerLazySingleton<CrosswordUsecase>(() => CrosswordUsecase());

  getIt.registerLazySingleton<LoadStageUsecase>(
    () => LoadStageUsecase(repository: getIt<StageRepository>()),
  );

  getIt.registerLazySingleton<SubmitWordUsecase>(
    () => SubmitWordUsecase(
      crosswordUsecase: getIt<CrosswordUsecase>(),
      repository: getIt<StageRepository>(),
    ),
  );

  getIt.registerLazySingleton<CheckIntersectionsUsecase>(
    () => CheckIntersectionsUsecase(
      repository: getIt<StageRepository>(),
      crosswordUsecase: getIt<CrosswordUsecase>(),
    ),
  );

  getIt.registerLazySingleton<RevealLetterUsecase>(
    () => RevealLetterUsecase(
      repository: getIt<StageRepository>(),
      crosswordUsecase: getIt<CrosswordUsecase>(),
    ),
  );
}

Future<void> _registerBlocs() async {
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  getIt.registerSingletonAsync<AuthCubit>(
    () async => AuthCubit(getIt<UserRepository>()),
    dependsOn: [StorageService],
  );

  getIt.registerSingletonAsync<PointsCubit>(
    () async => PointsCubit(
      authCubit: getIt<AuthCubit>(),
      storageService: getIt<StorageService>(),
    ),
    dependsOn: [AuthCubit, StorageService],
  );

  getIt.registerSingletonAsync<RewardedAdCubit>(
    () async => RewardedAdCubit()..initialize(),
  );

  getIt.registerSingletonAsync<FreezeCubit>(
    () async => FreezeCubit()..initializeFreeze(),
  );

  getIt.registerSingletonAsync<AccountBoostCubit>(
    () async => AccountBoostCubit(
      authCubit: getIt<AuthCubit>(),
      storageService: getIt<StorageService>(),
    ),
    dependsOn: [AuthCubit, StorageService],
  );

  getIt.registerLazySingleton<TotalWordsBloc>(() => TotalWordsBloc());

  getIt.registerSingletonAsync<SettingsCubit>(
    () async => SettingsCubit(
      openEmailUseCase: OpenEmailUseCase(),
      previousStageWordsService: getIt<PreviousStageWordsService>(),
      stageRepo: getIt<StageRepository>(),
    ),
    dependsOn: [AuthCubit, StorageService],
  );

  getIt.registerLazySingleton<StageBloc>(
    () => StageBloc(
      loadStageUsecase: getIt<LoadStageUsecase>(),
      submitWordUsecase: getIt<SubmitWordUsecase>(),
      checkIntersectionsUsecase: getIt<CheckIntersectionsUsecase>(),
      revealLetterUsecase: getIt<RevealLetterUsecase>(),
      stageRepo: getIt<StageRepository>(),
    ),
  );

  // User & Cloud Service
  getIt.registerLazySingleton<UserProfileService>(
    () => UserProfileService(
      getIt<UserRepository>(),
      getIt<AuthCubit>(),
      getIt<CloudSyncService>(),
    ),
  );

  getIt.registerLazySingleton<CloudSyncService>(
    () => CloudSyncService(getIt<UserRepository>()),
  );
}
