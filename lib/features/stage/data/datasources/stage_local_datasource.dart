import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';

class StageLocalDataSource {    
  CurrentStage? getCurrentStage() {
    return getIt<StorageService>().getCurrentStage();
  }
  
  Future<void> saveStage(CurrentStage stage) async {
    await getIt<StorageService>().saveCurrentStage(stage);
  }
  
  Future<void> deleteStage() async {
    await getIt<StorageService>().deleteCurrentStage();
  }
  
  bool hasSavedStage() {
    return getIt<StorageService>().hasSavedStage();
  }
}