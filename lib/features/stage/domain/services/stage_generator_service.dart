import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/services/board_setup_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_validation_service.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';
import 'package:flutter/material.dart';

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

    const int maxAttempts = 10;
    CurrentStage? validStage;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final selectedWord = await _wordSelectionService.selectUnusedWord(
        stageFile,
        criteria,
      );

      if (selectedWord == null) {
        debugPrint('No valid words found, using backup stage');
        return _loadBackupStage(level, criteria);
      }

      debugPrint('Attempt $attempt: Trying stage "${selectedWord.key}"');

      final stage = await _attemptStageGeneration(
        selectedWord: selectedWord,
        criteria: criteria,
      );

      if (_isValidStage(stage)) {
        validStage = stage;
        break;
      }

      debugPrint('Stage generation failed, marking as banned');
      await _wordSelectionService.addToBannedStages(selectedWord.key);
    }

    // If all attempts failed, use backup
    if (validStage == null) {
      debugPrint('All $maxAttempts attempts failed, loading backup stage');
      return _loadBackupStage(level, criteria);
    }

    return validStage;
  }

  Future<CurrentStage> _attemptStageGeneration({
    required MapEntry<String, dynamic> selectedWord,
    required StageCriteria criteria,
  }) async {
    final sortedWords = _prepareSortedWords(selectedWord.value);
    final board = _initializeEmptyBoard();
    StageValidationService.instance.clearFailedWords();

    print(sortedWords);
    print(selectedWord.key);

    return await _boardSetupService.placeWordsOnBoard(
      board: board,
      // words: ["ΒΙΤΣΑ", "ΣΑΙΤ", "ΣΙΤΑ", "ΤΑΣΙ", "ΤΣΑΙ", "ΙΣΑ", "ΣΙΑ", "ΣΤΑ", "ΤΙΣ", "ΤΣΑ", "ΑΤΙ", "ΒΑΙ", "ΒΑΤ", "ΒΙΑ"],
      // words: ["ΓΡΙΑ", "ΓΑΡ", "ΓΙΑ", "ΓΡΙ"],
      words: List<String>.from(sortedWords),
      stageKey: selectedWord.key,
      // stageKey: "ΑΓΙΡ",
      // stageKey: "ΑΒΙΣΤ",
      criteria: criteria,
    );
  }

  List<String> _initializeEmptyBoard() {
    return List.generate(maxBoardSize, (_) => '');
  }

  List<String> _prepareSortedWords(List<dynamic> words) {
    return List<String>.from(words)
      ..sort((a, b) => b.length.compareTo(a.length));
  }

  bool _isValidStage(CurrentStage stage) {
    return !stage.placementTracker.isEmpty;
  }

  Future<CurrentStage> _loadBackupStage(
    int level,
    StageCriteria criteria,
  ) async {
    // final backupStages = await _loadBackupStages();
    final backupStages = [];
    final suitableStage = backupStages.firstWhere(
      (stage) => stage.minLevel <= level && stage.maxLevel >= level,
      orElse: () => backupStages.first,
    );

    return suitableStage.toCurrentStage();
  }
}
