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
import '../../config/language/cubit/language_cubit.dart' as _i1061;
import '../../config/theme/theme_cubit/theme_cubit.dart' as _i387;
import '../../config/version/version_bloc/version_bloc.dart' as _i778;
import '../../config/version/version_service.dart' as _i339;
import '../../features/auth/auth_cubit/auth_cubit.dart' as _i199;
import '../../features/auth/data/repositories/user_repository_impl.dart'
    as _i687;
import '../../features/auth/domain/repositories/user_repository.dart' as _i926;
import '../../features/stage/domain/services/dictionary_service.dart' as _i262;
import '../services/app_bootstrapper.dart' as _i187;
import '../services/storage_service.dart' as _i306;
import 'register_module.dart' as _i291;

const String _minimal = 'minimal';

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
    gh.lazySingleton<_i187.AppBootstrapper>(
      () => _i187.AppBootstrapper(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i1061.LanguageCubit>(
      () => _i1061.LanguageCubit(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i387.ThemeCubit>(
      () => _i387.ThemeCubit(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i262.DictionaryService>(
      () => _i262.DictionaryService(),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i926.UserRepository>(
      () => _i687.UserRepositoryImpl(gh<_i306.StorageService>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i339.VersionService>(
      () => _i339.VersionService(gh<_i460.SharedPreferences>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i199.AuthCubit>(
      () => _i199.AuthCubit(gh<_i926.UserRepository>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i778.VersionBloc>(
      () => _i778.VersionBloc(gh<_i339.VersionService>()),
      registerFor: {_minimal},
    );
    gh.lazySingleton<_i254.SplashCubit>(
      () => _i254.SplashCubit(
        bootstrapper: gh<_i187.AppBootstrapper>(),
        versionBloc: gh<_i778.VersionBloc>(),
      ),
      registerFor: {_minimal},
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
