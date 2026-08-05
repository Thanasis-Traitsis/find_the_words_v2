import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppBootstrapper {
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: AppKeys.testDeviceIds),
    );

    await Future.wait([
      setupServiceLocator(),
      AuthService.instance.initializeGoogleSignIn(),
      _loadInitialData(),
    ]);

    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> _loadInitialData() async {
    final themeCubit = getIt<ThemeCubit>();
    final langCubit = getIt<LanguageCubit>();

    await Future.wait([themeCubit.loadTheme(), langCubit.loadSelectedLang()]);

    final dictionaryService = getIt<DictionaryService>();
    await dictionaryService.loadDictionaryJson();
  }
}
