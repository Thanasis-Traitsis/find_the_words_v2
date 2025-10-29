import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/stage/data/datasources/stage_local_datasource.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';

class StageRepositoryImpl implements StageRepository {
  final StageLocalDataSource _localDataSource;
  final StageGeneratorService _generatorService;
  
  StageRepositoryImpl({
    required StageLocalDataSource localDataSource,
    required StageGeneratorService generatorService,
  })  : _localDataSource = localDataSource,
        _generatorService = generatorService;
  
  @override
  Future<CurrentStage?> loadSavedStage() async {
    return _localDataSource.getCurrentStage();
  }
  
  @override
  Future<void> saveStageProgress({
    required CurrentStage stage,
    required String foundWord,
  }) async {
    await _localDataSource.saveStage(stage);
    
    await getIt<AuthCubit>().addFoundWord(foundWord);
  }
  
  @override
  Future<CurrentStage> generateStage({
    required int level,
    required int stageNumber,
    required double progress,
  }) async {
    final int wordLength = level + 2;

    final stage = await _generatorService.generateStage(
      filePath: FileUtils.stageFile(wordLength),
      level: level,
      progress: progress,
    );
    
    await _localDataSource.saveStage(stage);
    
    return stage;
  }
  
  @override
  Future<void> clearStage() async {
    await _localDataSource.deleteStage();
  }
  
  @override
  bool hasSavedStage() {
    return _localDataSource.hasSavedStage();
  }
}