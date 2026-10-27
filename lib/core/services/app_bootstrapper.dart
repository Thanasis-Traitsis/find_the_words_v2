import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/features/stage/domain/services/dictionary_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.minimal)
class AppBootstrapper {
  Future<void> initialize() async {
    await Future.wait([
      _initializeAds(),
      registerRemainingDependencies(),
      AuthService.instance.initializeGoogleSignIn(),
      _loadDictionary(),
    ]);

    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> _initializeAds() async {
    await MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: AppKeys.testDeviceIds),
    );
  }

  Future<void> _loadDictionary() async {
    final langCode = getIt<LanguageCubit>().state.appLanguage.code;
    await getIt<DictionaryService>().loadDictionaryJson(langCode: langCode);
  }
}
