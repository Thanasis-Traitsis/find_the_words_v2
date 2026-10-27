import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/utils/string_extensions.dart';
import 'package:find_the_words/features/stage/data/models/criteria_failure.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';
import 'package:find_the_words/features/stage/domain/helpers/neighbor_marker.dart';
import 'package:find_the_words/features/stage/domain/helpers/placement_strategy.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_validation_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.full)
class BoardSetupService {
  static const String leftKey = "LEFT";
  static const String topKey = "TOP";
  static const String rightKey = "RIGHT";
  static const String bottomKey = "BOTTOM";
  static const String startingPointKey = "STARTING_POINT";

  Future<CurrentStage> placeWordsOnBoard({
    required List<String> board,
    required List<String> words,
    required String stageKey,
    required StageCriteria criteria,
  }) async {
    final placementTracker = WordPlacementTracker();
    final originalStartPosition = _calculateCenterStartPosition(
      stageKey.length,
    );

    // Try different strategies until one works
    final strategies = [
      () => _tryBasicPlacement(
        board,
        words,
        originalStartPosition,
        placementTracker,
        criteria,
      ),
      () => _tryWithLeftovers(
        board,
        words,
        originalStartPosition,
        placementTracker,
        criteria,
      ),
      () => _tryMovingCrossword(
        board,
        words,
        originalStartPosition,
        placementTracker,
        criteria,
      ),
      () => _tryAlternativeIntersections(
        board,
        words,
        originalStartPosition,
        placementTracker,
        criteria,
      ),
    ];

    for (final strategy in strategies) {
      final success = await strategy();
      if (success) {
        int rowLength = StageGeneratorService.maxRowLength;
        final emptySpaces = _checkEmptyRowsCols(board);

        int top = emptySpaces[topKey] ?? 0;
        int right = emptySpaces[rightKey] ?? 0;
        int bottom = emptySpaces[bottomKey] ?? 0;
        int left = emptySpaces[leftKey] ?? 0;

        _moveCrosswordTopLeft(placementTracker, left, top);

        int horizontal = left + right;
        int vertical = top + bottom;

        while (horizontal > 0 && vertical > 0) {
          horizontal--;
          vertical--;
          rowLength--;
        }

        int centerNum = 0;
        if (horizontal > 1) {
          centerNum = horizontal ~/ 2;
        } else if (vertical > 1) {
          centerNum = (vertical ~/ 2) * rowLength;
        }

        for (int i = 0; i < placementTracker.allPositions.length; i++) {
          for (int j = 0; j < placementTracker.allPositions[i].length; j++) {
            placementTracker.allPositions[i][j] -=
                (placementTracker.allPositions[i][j] ~/
                    StageGeneratorService.maxRowLength) *
                (StageGeneratorService.maxRowLength - rowLength);

            placementTracker.allPositions[i][j] += centerNum;
          }
        }

        List<String> _createNewBoard(int size) {
          return List.generate(size, (_) => '');
        }

        final newBoardSize = rowLength * rowLength;
        board = _createNewBoard(newBoardSize);
        board = placementTracker.placePositions(board);

        break;
      }

      // Reset for next attempt
      _resetBoard(board);
      placementTracker.clear();
      StageValidationService.instance.clearFailedWords();
    }

    return CurrentStage(
      allWords: words,
      board: board,
      letters: stageKey.stringMixer(),
      placementTracker: placementTracker,
    );
  }

  int _calculateCenterStartPosition(int wordLength) {
    const center =
        StageGeneratorService.maxBoardSize ~/ 2 -
        (StageGeneratorService.maxRowLength ~/ 2);
    return center - (wordLength ~/ 2);
  }

  bool _isValidStage(WordPlacementTracker tracker, StageCriteria criteria) {
    final validation = validateStageCriteria(
      tracker: tracker,
      criteria: criteria,
    );
    return validation.isValid;
  }

  // Strategy 1: Basic placement
  Future<bool> _tryBasicPlacement(
    List<String> board,
    List<String> words,
    int startPosition,
    WordPlacementTracker tracker,
    StageCriteria criteria,
  ) async {
    _placeAllWords(
      board: board,
      words: words,
      startPosition: startPosition,
      tracker: tracker,
      maxWords: criteria.maxStageWords,
      minWordLength: criteria.smallestWordLength,
    );

    return _isValidStage(tracker, criteria);
  }

  // Strategy 2: Try placing leftover words
  Future<bool> _tryWithLeftovers(
    List<String> board,
    List<String> words,
    int startPosition,
    WordPlacementTracker tracker,
    StageCriteria criteria,
  ) async {
    _placeAllWords(
      board: board,
      words: words,
      startPosition: startPosition,
      tracker: tracker,
      maxWords: criteria.maxStageWords,
      minWordLength: criteria.smallestWordLength,
    );

    final validation = validateStageCriteria(
      tracker: tracker,
      criteria: criteria,
    );
    if (validation.isValid) return true;

    // Try adding leftover words
    final leftoverWords = await StageValidationService.instance
        .getWordsWithoutPosition();
    if (leftoverWords.isEmpty) return false;

    _placeLeftOvers(board: board, words: leftoverWords, tracker: tracker);

    return _isValidStage(tracker, criteria);
  }

  // Strategy 3: Move the crossword position
  Future<bool> _tryMovingCrossword(
    List<String> board,
    List<String> words,
    int originalPosition,
    WordPlacementTracker tracker,
    StageCriteria criteria,
  ) async {
    _placeAllWords(
      board: board,
      words: words,
      startPosition: originalPosition,
      tracker: tracker,
      maxWords: criteria.maxStageWords,
      minWordLength: criteria.smallestWordLength,
    );

    // NOW analyze where the empty spaces are
    final emptySpaces = _checkEmptyRowsCols(board);
    final bestDirection = _getBestDirection(emptySpaces);

    if (bestDirection == null) return false;

    // Reset and try with adjusted position
    _resetBoard(board);
    tracker.clear();

    final newPosition = _calculateNewPosition(
      originalPosition,
      bestDirection,
      emptySpaces,
    );

    _placeAllWords(
      board: board,
      words: words,
      startPosition: newPosition,
      tracker: tracker,
      maxWords: criteria.maxStageWords,
      minWordLength: criteria.smallestWordLength,
    );

    return _isValidStage(tracker, criteria);
  }

  // Strategy 4: Move the position of second word
  Future<bool> _tryAlternativeIntersections(
    List<String> board,
    List<String> words,
    int startPosition,
    WordPlacementTracker tracker,
    StageCriteria criteria,
  ) async {
    // Place first word
    _placeInitialWord(board, words[0], startPosition, tracker);

    for (int attempt = 1; attempt < words[0].length; attempt++) {
      for (int i = 1; i < words.length; i++) {
        if (words[i].length > criteria.smallestWordLength) {
          _placeCrossingWord(
            board,
            words[i],
            tracker,
            alternativePosition: attempt,
          );
        }

        if (tracker.wordCount == criteria.maxStageWords) break;
      }

      if (_isValidStage(tracker, criteria)) {
        return true;
      }

      // Reset for next attempt
      if (attempt < words[0].length - 1) {
        _resetBoard(board);
        tracker.clear();
        _placeInitialWord(board, words[0], startPosition, tracker);
      }
    }

    return false;
  }

  void _placeAllWords({
    required List<String> board,
    required List<String> words,
    required int startPosition,
    required WordPlacementTracker tracker,
    required int maxWords,
    required int minWordLength,
  }) {
    for (final word in words) {
      if (tracker.wordCount == maxWords) break;
      if (word.length < minWordLength) break;

      final success = tracker.isEmpty
          ? _placeInitialWord(board, word, startPosition, tracker)
          : _placeCrossingWord(board, word, tracker);

      if (!success) {
        StageValidationService.instance.wordUnableToFit(word);
        debugPrint('Failed to place word: $word');
      }
    }
  }

  void _placeLeftOvers({
    required List<String> board,
    required List<String> words,
    required WordPlacementTracker tracker,
  }) {
    for (final word in words) {
      final success = _placeCrossingWord(board, word, tracker);

      StageValidationService.instance.removeWordFromFailedList(word);

      if (!success) {
        debugPrint('Failed to place word AGAIN: $word');
      }
    }
  }

  bool _placeInitialWord(
    List<String> board,
    String word,
    int startPosition,
    WordPlacementTracker tracker,
  ) {
    final positions = _placeHorizontalWord(board, word, startPosition);

    tracker.addPlacement(word, positions);
    _markNeighborCells(board, positions, isHorizontal: true);

    return true;
  }

  bool _placeCrossingWord(
    List<String> board,
    String word,
    WordPlacementTracker tracker, {
    int alternativePosition = 0,
  }) {
    for (int i = tracker.wordCount - 1; i >= 0; i--) {
      final placement = tracker.getPlacement(i);
      final intersections = alternativePosition != 0
          ? _findAlternativeIntersections(
              newWord: word,
              existingWord: placement.word,
              existingPositions: placement.positions,
              firstWordPosition: alternativePosition,
            )
          : _findIntersections(
              newWord: word,
              existingWord: placement.word,
              existingPositions: placement.positions,
            );

      if (intersections.isEmpty) continue;

      final newPositions = _tryPlaceAtIntersections(
        board: board,
        word: word,
        intersections: intersections,
        existingIsHorizontal: placement.isHorizontal,
      );

      if (newPositions.isNotEmpty) {
        tracker.addPlacement(word, newPositions);
        _markNeighborCells(
          board,
          newPositions,
          isHorizontal: !placement.isHorizontal,
        );
        return true;
      }
    }

    return false;
  }

  Map<int, String> _findIntersections({
    required String newWord,
    required String existingWord,
    required List<int> existingPositions,
  }) {
    final intersections = <int, String>{};

    for (int i = 0; i < existingWord.length; i++) {
      final letter = existingWord[i];
      for (int j = 0; j < newWord.length; j++) {
        if (letter == newWord[j]) {
          intersections[existingPositions[i]] = letter;
        }
      }
    }

    return intersections;
  }

  Map<int, String> _findAlternativeIntersections({
    required String newWord,
    required String existingWord,
    required List<int> existingPositions,
    required int firstWordPosition,
  }) {
    final intersections = <int, String>{};

    for (int i = firstWordPosition; i < existingWord.length; i++) {
      final letter = existingWord[i];
      for (int j = 0; j < newWord.length; j++) {
        if (letter == newWord[j]) {
          intersections[existingPositions[i]] = letter;
        }
      }
    }

    return intersections;
  }

  List<int> _tryPlaceAtIntersections({
    required List<String> board,
    required String word,
    required Map<int, String> intersections,
    required bool existingIsHorizontal,
  }) {
    final placementStrategy = existingIsHorizontal
        ? VerticalPlacementStrategy()
        : HorizontalPlacementStrategy();

    return placementStrategy.tryPlace(
      board: board,
      word: word,
      intersections: intersections,
    );
  }

  List<int> _placeHorizontalWord(List<String> board, String word, int start) {
    final positions = <int>[];
    for (int i = 0; i < word.length; i++) {
      final position = start + i;
      board[position] = word[i];
      positions.add(position);
    }
    return positions;
  }

  void _markNeighborCells(
    List<String> board,
    List<int> positions, {
    required bool isHorizontal,
  }) {
    final marker = NeighborMarker(board: board);

    if (isHorizontal) {
      marker.markHorizontalWordNeighbors(positions);
    } else {
      marker.markVerticalWordNeighbors(positions);
    }
  }

  void _resetBoard(
    List<String> board, {
    int boardLength = StageGeneratorService.maxBoardSize,
  }) {
    for (int i = 0; i < boardLength; i++) {
      board[i] = '';
    }
  }

  Map<String, int> _checkEmptyRowsCols(List<String> board) {
    Map<String, int> result = {};

    for (
      int i = 0;
      i < board.length;
      i = i + StageGeneratorService.maxRowLength
    ) {
      int row = i;
      while (row < board.length &&
          !BoardHelper.positionWithLetter(board, row)) {
        row++;
        if (row - i == StageGeneratorService.maxRowLength) break;
      }

      if (row - i == StageGeneratorService.maxRowLength) {
        if (row < (StageGeneratorService.maxBoardSize / 2)) {
          result[topKey] = (result[topKey] ?? 0) + 1;
        } else {
          result[bottomKey] = (result[bottomKey] ?? 0) + 1;
        }
      }
    }

    for (int i = 0; i < StageGeneratorService.maxRowLength; i++) {
      int col = i;
      while (col < board.length &&
          !BoardHelper.positionWithLetter(board, col)) {
        col += StageGeneratorService.maxRowLength;
        if (col > StageGeneratorService.maxBoardSize) break;
      }

      if (col >= StageGeneratorService.maxBoardSize) {
        if (col - StageGeneratorService.maxBoardSize <
            (StageGeneratorService.maxRowLength / 2)) {
          result[leftKey] = (result[leftKey] ?? 0) + 1;
        } else {
          result[rightKey] = (result[rightKey] ?? 0) + 1;
        }
      }
    }

    return result;
  }

  String? _getBestDirection(Map<String, int> spaces) {
    if (spaces.isEmpty) return null;

    int maxSpace = 0;
    String? bestDirection;

    // Priority order: LEFT, RIGHT, TOP, BOTTOM
    for (final direction in [leftKey, rightKey, topKey, bottomKey]) {
      final space = spaces[direction] ?? 0;
      if (space > maxSpace) {
        maxSpace = space;
        bestDirection = direction;
      }
    }

    return bestDirection;
  }

  int _calculateNewPosition(
    int original,
    String direction,
    Map<String, int> spaces,
  ) {
    final offset = spaces[direction] ?? 0;

    return switch (direction) {
      leftKey => original - offset,
      rightKey => original + offset,
      topKey => original - (offset * StageGeneratorService.maxRowLength),
      bottomKey => original + (offset * StageGeneratorService.maxRowLength),
      _ => original,
    };
  }

  void _moveCrosswordTopLeft(
    WordPlacementTracker placementTracker,
    int left,
    int top,
  ) {
    if (left > 0) {
      for (int i = 0; i < placementTracker.allPositions.length; i++) {
        for (int j = 0; j < placementTracker.allPositions[i].length; j++) {
          placementTracker.allPositions[i][j] -= left;
        }
      }
    }

    if (top > 0) {
      for (int i = 0; i < placementTracker.allPositions.length; i++) {
        for (int j = 0; j < placementTracker.allPositions[i].length; j++) {
          placementTracker.allPositions[i][j] -=
              (StageGeneratorService.maxRowLength * top);
        }
      }
    }
  }
}
