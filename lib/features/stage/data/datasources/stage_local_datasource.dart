import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class StageLocalDataSource {
  CurrentStage? getCurrentStage(AppLanguage language) {
    return getIt<StorageService>().getCurrentStage(language);
  }

  Future<void> saveStage(CurrentStage stage, AppLanguage language) async {
    await getIt<StorageService>().saveCurrentStage(stage, language);
  }

  Future<void> deleteStage(AppLanguage language) async {
    await getIt<StorageService>().deleteCurrentStage(language);
  }

  bool hasSavedStage(AppLanguage language) {
    return getIt<StorageService>().hasSavedStage(language);
  }
}