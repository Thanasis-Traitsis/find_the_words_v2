import 'package:find_the_words/features/stage/data/models/current_stage.dart';

abstract class BackupStagesService {
  Future<CurrentStage> getBackupStage(int level);
}