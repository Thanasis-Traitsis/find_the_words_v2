import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/previous_stage_words_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/data/datasources/stage_local_datasource.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
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
    final userProfileService = getIt<UserProfileService>();

    await _localDataSource.saveStage(stage, currentLang);
    await userProfileService.addFoundWord(foundWord);
  }

  @override
  Future<CurrentStage> generateStage({
    required int level,
    required int stageNumber,
    required double progress,
  }) async {
    final userProfileService = getIt<UserProfileService>();
    final currentLang = getIt<LanguageCubit>().state.appLanguage;
    final int wordLength = level + 2;

    final stage = await _generatorService.generateStage(
      filePath: FileUtils.stageFile(wordLength, currentLang.code),
      level: level,
      progress: progress,
    );

    final enrichedStage = _enrichStageWithCommonPositions(stage);

    await _localDataSource.saveStage(enrichedStage, currentLang);
    await userProfileService.saveStage(enrichedStage);

    return enrichedStage;
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

CurrentStage _enrichStageWithCommonPositions(CurrentStage stage) {
  final commonPositions = _findCommonPositions(
    stage.placementTracker.allPositions,
  );

  final updatedTracker = WordPlacementTracker.copyWith(
    placements: stage.placementTracker.placements,
    foundWords: stage.placementTracker.foundWords,
    revealedPositions: stage.placementTracker.revealedPositions,
    commonPositions: commonPositions,
    extraWords: stage.placementTracker.extraWords,
  );

  // _logStageForBackup(stage, commonPositions);

  return CurrentStage(
    allWords: stage.allWords,
    letters: stage.letters,
    board: stage.board,
    placementTracker: updatedTracker,
  );
}

List<int> _findCommonPositions(List<List<int>> allPositions) {
  final positionCounts = _countPositionOccurrences(allPositions);
  return _extractRepeatedPositions(positionCounts);
}

Map<int, int> _countPositionOccurrences(List<List<int>> allPositions) {
  final counts = <int, int>{};

  for (final positions in allPositions) {
    for (final position in positions) {
      counts[position] = (counts[position] ?? 0) + 1;
    }
  }

  return counts;
}

List<int> _extractRepeatedPositions(Map<int, int> positionCounts) {
  return positionCounts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toList();
}
