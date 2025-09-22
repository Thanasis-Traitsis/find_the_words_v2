import 'dart:math';

import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordSelectionService {
  static const String _usedStageKey = AppKeys.usedStageKey;
  static const String _bannedStageKey = AppKeys.bannedStageKey;
  final SharedPreferences _prefs;

  WordSelectionService(this._prefs);

  Future<MapEntry<String, dynamic>> selectUnusedWord(
    Map<String, dynamic> stageFile,
    StageCriteria criteria,
  ) async {
    final usedStages = await _getUsedStages();
    final bannedStages = await _getBannedStages();

    // STEP 1
    var availableStages = _filterAvailableStages(
      stageFile,
      usedStages,
      bannedStages,
    );

    var selectedStage = await _trySelectValidStage(availableStages, criteria);

    if (selectedStage != null) {
      await _markStageAsUsed(selectedStage.key);
      return selectedStage;
    }

    // STEP 2
    final bannedStagesMap = _getBannedStagesFromFile(stageFile, bannedStages);

    if (bannedStagesMap.isNotEmpty) {
      await _clearBannedStages();

      selectedStage = _selectRandomStage(bannedStagesMap);
      await _markStageAsUsed(selectedStage!.key);
      return selectedStage;
    }

    // STEP 3
    selectedStage = _selectRandomStage(stageFile);
    await _markStageAsUsed(selectedStage!.key);
    await _clearBannedStages();
    return selectedStage;
  }

  Future<MapEntry<String, dynamic>?> _trySelectValidStage(
    Map<String, dynamic> availableStages,
    StageCriteria criteria,
  ) async {
    final stagesToTry = Map<String, dynamic>.from(availableStages);

    while (stagesToTry.isNotEmpty) {
      final stage = _selectRandomStage(stagesToTry);
      if (stage == null) break;

      if (_stageMatchesCriteria(stage, criteria)) {
        return stage;
      }

      await _addToBannedStages(stage.key);
      stagesToTry.remove(stage.key);
    }

    return null;
  }

  bool _stageMatchesCriteria(
    MapEntry<String, dynamic> stage,
    StageCriteria criteria,
  ) {
    final mainWordLength = stage.key.length;
    final words = List<String>.from(stage.value);

    print(criteria);

    if (mainWordLength != criteria.biggestWordLength) {
      return false;
    }

    final validWords = words
        .where((word) => word.length >= criteria.smallestWordLength)
        .toList();

    if (validWords.length < criteria.minStageWords) {
      return false;
    }

    if (criteria.minBigWords > 1) {
      final bigWordCount = validWords
          .where((word) => word.length == mainWordLength)
          .length;

      if (bigWordCount < criteria.minBigWords) {
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic> _filterAvailableStages(
    Map<String, dynamic> stageFile,
    List<String> usedStages,
    List<String> bannedStages,
  ) {
    return Map.fromEntries(
      stageFile.entries.where(
        (entry) =>
            !usedStages.contains(entry.key) &&
            !bannedStages.contains(entry.key),
      ),
    );
  }

  Map<String, dynamic> _getBannedStagesFromFile(
    Map<String, dynamic> stageFile,
    List<String> bannedStages,
  ) {
    return Map.fromEntries(
      stageFile.entries.where((entry) => bannedStages.contains(entry.key)),
    );
  }

  MapEntry<String, dynamic>? _selectRandomStage(Map<String, dynamic> stages) {
    if (stages.isEmpty) return null;

    final randomIndex = Random().nextInt(stages.length);
    return stages.entries.elementAt(randomIndex);
  }

  // Storage management methods
  Future<List<String>> _getUsedStages() async {
    return _prefs.getStringList(_usedStageKey) ?? [];
  }

  Future<List<String>> _getBannedStages() async {
    return _prefs.getStringList(_bannedStageKey) ?? [];
  }

  Future<void> _markStageAsUsed(String stageKey) async {
    final usedStages = await _getUsedStages();
    if (!usedStages.contains(stageKey)) {
      usedStages.add(stageKey);
      await _prefs.setStringList(_usedStageKey, usedStages);
    }
  }

  Future<void> _addToBannedStages(String stageKey) async {
    final bannedStages = await _getBannedStages();
    if (!bannedStages.contains(stageKey)) {
      bannedStages.add(stageKey);
      await _prefs.setStringList(_bannedStageKey, bannedStages);
    }
  }

  Future<void> _clearBannedStages() async {
    await _prefs.remove(_bannedStageKey);
  }
}
