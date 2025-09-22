import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/services/board_setup_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_validation_service.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';

class StageGeneratorService {
  static const int maxRowLength = 12;
  static const int maxBoardSize = maxRowLength * maxRowLength;

  final WordSelectionService _wordSelectionService;
  final BoardSetupService _boardSetupService;

  StageGeneratorService({
    required WordSelectionService wordSelectionService,
    required BoardSetupService boardSetupService,
  }) : _wordSelectionService = wordSelectionService,
       _boardSetupService = boardSetupService;

  Future<CurrentStage> generateStage({
    required String filePath,
    required int level,
    required double progress,
  }) async {
    final stageFile = await FileUtils.loadCompressedJson(filePath);
    final criteria = StageCriteria.fromLevelAndProgress(
      level: level,
      progress: progress,
    );
    final selectedWord = await _wordSelectionService.selectUnusedWord(
      stageFile,
      criteria,
    );

    final sortedWords = _prepareSortedWords(selectedWord.value);
    final board = _initializeEmptyBoard();
    StageValidationService.instance.clearFailedWords();

    // print(sortedWords);

    final CurrentStage stage = await _boardSetupService.placeWordsOnBoard(
      board: board,
      words: List<String>.from(sortedWords),
      stageKey: selectedWord.key,
      criteria: criteria,
    );

    return stage;
  }

  List<String> _initializeEmptyBoard() {
    return List.generate(maxBoardSize, (_) => '');
  }

  List<String> _prepareSortedWords(List<dynamic> words) {
    return List<String>.from(words)
      ..sort((a, b) => b.length.compareTo(a.length));
  }
}
