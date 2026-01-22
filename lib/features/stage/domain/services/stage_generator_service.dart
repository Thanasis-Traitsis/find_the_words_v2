import 'package:find_the_words/core/constants/backup_stages_el.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/services/board_setup_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_validation_service.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StageGeneratorService {
  static const int maxRowLength = 12;
  static const int maxBoardSize = maxRowLength * maxRowLength;

  final WordSelectionService _wordSelectionService;
  final BoardSetupService _boardSetupService;
  final SharedPreferences _prefs;

  StageGeneratorService({
    required WordSelectionService wordSelectionService,
    required BoardSetupService boardSetupService,
    required SharedPreferences prefs,
  }) : _wordSelectionService = wordSelectionService,
       _boardSetupService = boardSetupService,
       _prefs = prefs;

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
        return _loadBackupStage(level);
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
      return _loadBackupStage(level);
    }

    return validStage;
  }

  Future<CurrentStage> _attemptStageGeneration({
    required MapEntry<String, dynamic> selectedWord,
    required StageCriteria criteria,
  }) async {
    final bannedWords = await _getBannedWords();
    final sortedWords = _prepareSortedWords(selectedWord.value, bannedWords);
    final board = _initializeEmptyBoard();
    StageValidationService.instance.clearFailedWords();

    return await _boardSetupService.placeWordsOnBoard(
      board: board,
      words: List<String>.from(sortedWords),
      stageKey: selectedWord.key,
      criteria: criteria,
    );
  }

  List<String> _initializeEmptyBoard() {
    return List.generate(maxBoardSize, (_) => '');
  }

  List<String> _prepareSortedWords(
    List<dynamic> words,
    List<String> bannedWords,
  ) {
    return words
        .whereType<String>()
        .where((word) => !bannedWords.contains(word))
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));
  }

  Future<List<String>> _getBannedWords() async {
    return _prefs.getStringList(AppKeys.bannedWords) ?? [];
  }

  bool _isValidStage(CurrentStage stage) {
    return !stage.placementTracker.isEmpty;
  }

  Future<CurrentStage> _loadBackupStage(int level) async {
    // TODO: Add the EN language as well
    final backupEL = BackupStagesEL(_wordSelectionService);
    final currentBackup = await backupEL.getBackupStage(level);

    return currentBackup;
  }
}
