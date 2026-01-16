import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/previous_stage_words_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/stage/data/datasources/stage_local_datasource.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StageRepositoryImpl implements StageRepository {
  final StageLocalDataSource _localDataSource;
  final StageGeneratorService _generatorService;
  final PreviousStageWordsService _previousStageWordsService;

  StageRepositoryImpl({
    required StageLocalDataSource localDataSource,
    required StageGeneratorService generatorService,
    required PreviousStageWordsService previousStageWordsService,
  }) : _localDataSource = localDataSource,
       _generatorService = generatorService,
       _previousStageWordsService = previousStageWordsService;

  @override
  Future<CurrentStage?> loadSavedStage() async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    return _localDataSource.getCurrentStage(currentLang);
  }

  @override
  Future<void> saveStageProgress({
    required CurrentStage stage,
    String? foundWord,
  }) async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;

    await _localDataSource.saveStage(stage, currentLang);

    if (foundWord != null) {
      await getIt<AuthCubit>().addFoundWord(foundWord);
    }
  }

  @override
  Future<CurrentStage> generateStage({
    required int level,
    required int stageNumber,
    required double progress,
  }) async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    final int wordLength = level + 2;

    final stage = await _generatorService.generateStage(
      filePath: FileUtils.stageFile(wordLength, currentLang.code),
      level: level,
      progress: progress,
    );

    await _localDataSource.saveStage(stage, currentLang);

    return stage;
  }

  @override
  Future<void> clearStage() async {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    await _localDataSource.deleteStage(currentLang);
  }

  @override
  bool hasSavedStage() {
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    return _localDataSource.hasSavedStage(currentLang);
  }

  @override
  void saveStageWordsAfterCompletion({
    required List<String> foundWords,
    required List<String> extraWords,
  }) {
    final List<String> allWordsFound = [...foundWords, ...extraWords];

    _previousStageWordsService.savePrevStageWords(allWordsFound);
  }

  @override
  Future<void> resetStage(int stageNumber) async {
    final prefs = getIt<SharedPreferences>();

    await clearStage();

    final String timerKey = AppKeys.timerKey(stageNumber);
    await prefs.remove(timerKey);
  }
}
