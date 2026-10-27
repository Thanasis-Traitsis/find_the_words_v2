// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../app/splash_cubit/splash_cubit.dart' as _i254;
import '../../config/ads/rewarded_cubit/rewarded_ad_cubit.dart' as _i127;
import '../../config/connectivity/connectivity_cubit/connectivity_cubit.dart'
    as _i205;
import '../../config/language/cubit/language_cubit.dart' as _i1061;
import '../../config/language/domain/usecases/change_language_usecase.dart'
    as _i417;
import '../../config/sound/cubit/sound_cubit.dart' as _i283;
import '../../config/theme/theme_cubit/theme_cubit.dart' as _i387;
import '../../config/version/version_cubit/version_cubit.dart' as _i373;
import '../../config/version/version_service.dart' as _i339;
import '../../features/auth/account_boost_cubit/account_boost_cubit.dart'
    as _i170;
import '../../features/auth/auth_cubit/auth_cubit.dart' as _i199;
import '../../features/auth/data/repositories/user_repository_impl.dart'
    as _i687;
import '../../features/auth/domain/repositories/user_repository.dart' as _i926;
import '../../features/auth/domain/usecases/build_authenticated_user_usecase.dart'
    as _i253;
import '../../features/auth/domain/usecases/create_guest_user_usecase.dart'
    as _i792;
import '../../features/auth/domain/usecases/delete_account_usecase.dart'
    as _i914;
import '../../features/auth/domain/usecases/merge_user_progress_usecase.dart'
    as _i542;
import '../../features/auth/domain/usecases/resolve_initial_auth_state_usecase.dart'
    as _i710;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/freeze/freeze_cubit/freeze_cubit.dart' as _i341;
import '../../features/points/cubit/points_ad_limit_cubit.dart' as _i183;
import '../../features/points/cubit/points_cubit.dart' as _i640;
import '../../features/settings/domain/usecases/open_email_usecase.dart'
    as _i1030;
import '../../features/settings/presentation/settings_cubit/settings_cubit.dart'
    as _i648;
import '../../features/stage/data/datasources/stage_local_datasource.dart'
    as _i222;
import '../../features/stage/data/repositories/stage_repository_impl.dart'
    as _i1067;
import '../../features/stage/domain/repositories/stage_repository.dart'
    as _i316;
import '../../features/stage/domain/services/board_setup_service.dart' as _i27;
import '../../features/stage/domain/services/dictionary_service.dart' as _i262;
import '../../features/stage/domain/services/stage_generator_service.dart'
    as _i990;
import '../../features/stage/domain/services/word_selection_service.dart'
    as _i887;
import '../../features/stage/domain/usecases/check_intersection_usecase.dart'
    as _i12;
import '../../features/stage/domain/usecases/crossword_usecase.dart' as _i811;
import '../../features/stage/domain/usecases/load_stage_usecase.dart' as _i427;
import '../../features/stage/domain/usecases/reveal_letter_usecase.dart'
    as _i437;
import '../../features/stage/domain/usecases/submit_word_usecase.dart' as _i188;
import '../../features/stage/presentation/stage_bloc/stage_bloc.dart' as _i772;
import '../../features/words/presentation/total_words_bloc/total_words_bloc.dart'
    as _i796;
import '../services/app_bootstrapper.dart' as _i187;
import '../services/cloud_sync_service.dart' as _i1007;
import '../services/connectivity_service.dart' as _i47;
import '../services/previous_stage_words_service.dart' as _i40;
import '../services/storage_service.dart' as _i306;
import '../services/store_discount_service.dart' as _i88;
import '../services/user_profile_service.dart' as _i442;
import 'register_module.dart' as _i291;

const String _minimal = 'minimal';
const String _full = 'full';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i259.SignInUsecase>(
      () => _i259.SignInUsecase(gh<_i1007.CloudSyncService>()),
      registerFor: {_minimal},
    );
    await gh.lazySingletonAsync<_i88.StoreDiscountService>(
      () => registerModule.storeDiscountService,
      registerFor: {_full},
      preResolve: true,
    );
    gh.lazySingleton<_i40.PreviousStageWordsService>(
      () => _i40.PreviousStageWordsService(),
      registerFor: {_full},
    );
    gh.lazySingleton<_i127.RewardedAdCubit>(
      () => _i127.RewardedAdCubit(),
      registerFor: {_full},
    );
    gh.lazySingleton<_i283.SoundCubit>(
      () => _i283.SoundCubit(),
      registerFor: {_full},
    );
    gh.lazySingleton<_i796.TotalWordsBloc>(
      () => _i796.TotalWordsBloc(),
      registerFor: {_full},
    );
    await gh.lazySingletonAsync<_i183.PointsAdLimitCubit>(
      () {
        final i = _i183.PointsAdLimitCubit();
        return i.initialize().then((_) => i);
      },
      registerFor: {_full},
      preResolve: true,
    );
    gh.lazySingleton<_i222.StageLocalDataSource>(
      () => _i222.StageLocalDataSource(),
      registerFor: {_full},
    );
    gh.lazySingleton<_i27.BoardSetupService>(
      () => _i27.BoardSetupService(),
      registerFor: {_full},
    );
    gh.factory<_i1030.OpenEmailUseCase>(
      () => _i1030.OpenEmailUseCase(),
      registerFor: {_full},
    );
    gh.factory<_i811.CrosswordUsecase>(
      () => _i811.CrosswordUsecase(),
      registerFor: {_full},
    );
    gh.lazySingleton<_i887.WordSelectionService>(
      () => _i887.WordSelectionService(gh<_i460.SharedPreferences>()),
      registerFor: {_full},
    );
    gh.lazySingleton<_i1007.CloudSyncService>(
      () => _i1007.CloudSyncService(
        gh<_i926.UserRepository>(),
        gh<_i542.MergeUserProgressUsecase>(),
        gh<_i253.BuildAuthenticatedUserUsecase>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i205.ConnectivityCubit>(
      () => _i205.ConnectivityCubit(gh<_i47.ConnectivityService>()),
      registerFor: {_full},
    );
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      registerFor: {_minimal},
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i306.StorageService>(
      () => registerModule.storageService,
      registerFor: {_minimal},
      preResolve: true,
    );
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityService(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i187.AppBootstrapper>(
      () => _i187.AppBootstrapper(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i262.DictionaryService>(
      () => _i262.DictionaryService(),
      registerFor: {_minimal},
    );
    gh.factory<_i542.MergeUserProgressUsecase>(
      () => _i542.MergeUserProgressUsecase(),
      registerFor: {_minimal},
    );
    gh.factory<_i253.BuildAuthenticatedUserUsecase>(
      () => _i253.BuildAuthenticatedUserUsecase(),
      registerFor: {_minimal},
    );
    gh.factory<_i914.DeleteAccountUsecase>(
      () => _i914.DeleteAccountUsecase(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i990.StageGeneratorService>(
      () => _i990.StageGeneratorService(
        wordSelectionService: gh<_i887.WordSelectionService>(),
        boardSetupService: gh<_i27.BoardSetupService>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i442.UserProfileService>(
      () => _i442.UserProfileService(
        gh<_i926.UserRepository>(),
        gh<_i199.AuthCubit>(),
        gh<_i1007.CloudSyncService>(),
        gh<_i222.StageLocalDataSource>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i926.UserRepository>(
      () => _i687.UserRepositoryImpl(gh<_i306.StorageService>()),
      registerFor: {_minimal},
    );
    gh.factory<_i417.ChangeLanguageUsecase>(
      () => _i417.ChangeLanguageUsecase(
        gh<_i262.DictionaryService>(),
        gh<_i442.UserProfileService>(),
      ),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i170.AccountBoostCubit>(
      () => _i170.AccountBoostCubit(
        authCubit: gh<_i199.AuthCubit>(),
        userProfileService: gh<_i442.UserProfileService>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i640.PointsCubit>(
      () => _i640.PointsCubit(
        authCubit: gh<_i199.AuthCubit>(),
        userProfileService: gh<_i442.UserProfileService>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i1061.LanguageCubit>(
      () => _i1061.LanguageCubit(gh<_i460.SharedPreferences>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i339.VersionService>(
      () => _i339.VersionService(gh<_i460.SharedPreferences>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i387.ThemeCubit>(
      () => _i387.ThemeCubit(gh<_i460.SharedPreferences>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i316.StageRepository>(
      () => _i1067.StageRepositoryImpl(
        localDataSource: gh<_i222.StageLocalDataSource>(),
        generatorService: gh<_i990.StageGeneratorService>(),
        previousStageWordsService: gh<_i40.PreviousStageWordsService>(),
      ),
      registerFor: {_full},
    );
    gh.factory<_i792.CreateGuestUserUsecase>(
      () => _i792.CreateGuestUserUsecase(gh<_i926.UserRepository>()),
      registerFor: {_minimal},
    );
    await gh.lazySingletonAsync<_i341.FreezeCubit>(
      () {
        final i = _i341.FreezeCubit(gh<_i442.UserProfileService>());
        return i.initializeFreeze().then((_) => i);
      },
      registerFor: {_full},
      preResolve: true,
    );
    gh.factory<_i427.LoadStageUsecase>(
      () => _i427.LoadStageUsecase(repository: gh<_i316.StageRepository>()),
      registerFor: {_full},
    );
    gh.lazySingleton<_i648.SettingsCubit>(
      () => _i648.SettingsCubit(
        openEmailUseCase: gh<_i1030.OpenEmailUseCase>(),
        previousStageWordsService: gh<_i40.PreviousStageWordsService>(),
        stageRepo: gh<_i316.StageRepository>(),
      ),
      registerFor: {_full},
    );
    gh.factory<_i437.RevealLetterUsecase>(
      () => _i437.RevealLetterUsecase(
        repository: gh<_i316.StageRepository>(),
        crosswordUsecase: gh<_i811.CrosswordUsecase>(),
      ),
      registerFor: {_full},
    );
    gh.factory<_i12.CheckIntersectionsUsecase>(
      () => _i12.CheckIntersectionsUsecase(
        repository: gh<_i316.StageRepository>(),
        crosswordUsecase: gh<_i811.CrosswordUsecase>(),
      ),
      registerFor: {_full},
    );
    gh.factory<_i710.ResolveInitialAuthStateUsecase>(
      () => _i710.ResolveInitialAuthStateUsecase(
        gh<_i926.UserRepository>(),
        gh<_i47.ConnectivityService>(),
        gh<_i1007.CloudSyncService>(),
        gh<_i792.CreateGuestUserUsecase>(),
      ),
      registerFor: {_minimal},
    );
    gh.factory<_i188.SubmitWordUsecase>(
      () => _i188.SubmitWordUsecase(
        crosswordUsecase: gh<_i811.CrosswordUsecase>(),
        repository: gh<_i316.StageRepository>(),
      ),
      registerFor: {_full},
    );
    gh.lazySingleton<_i373.VersionCubit>(
      () => _i373.VersionCubit(gh<_i339.VersionService>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i199.AuthCubit>(
      () => _i199.AuthCubit(
        gh<_i926.UserRepository>(),
        gh<_i710.ResolveInitialAuthStateUsecase>(),
        gh<_i259.SignInUsecase>(),
        gh<_i914.DeleteAccountUsecase>(),
        gh<_i792.CreateGuestUserUsecase>(),
      ),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i254.SplashCubit>(
      () => _i254.SplashCubit(
        bootstrapper: gh<_i187.AppBootstrapper>(),
        versionCubit: gh<_i373.VersionCubit>(),
        themeCubit: gh<_i387.ThemeCubit>(),
        languageCubit: gh<_i1061.LanguageCubit>(),
      ),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i772.StageBloc>(
      () => _i772.StageBloc(
        loadStageUsecase: gh<_i427.LoadStageUsecase>(),
        submitWordUsecase: gh<_i188.SubmitWordUsecase>(),
        checkIntersectionsUsecase: gh<_i12.CheckIntersectionsUsecase>(),
        revealLetterUsecase: gh<_i437.RevealLetterUsecase>(),
        stageRepo: gh<_i316.StageRepository>(),
      ),
      registerFor: {_full},
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
