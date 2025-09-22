import 'package:find_the_words/features/stage/data/models/criteria_failure.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';
import 'package:find_the_words/features/stage/domain/helpers/neighbor_marker.dart';
import 'package:find_the_words/features/stage/domain/helpers/placement_strategy.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:find_the_words/features/stage/domain/services/stage_validation_service.dart';
import 'package:flutter/material.dart';

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
    int startingPoint = 0;
    final placementTracker = WordPlacementTracker();
    final startPosition = _calculateCenterStartPosition(stageKey.length);

    int selectedStartingPosition = startPosition;

    _placeAllWords(
      board: board,
      words: words,
      startPosition: selectedStartingPosition,
      tracker: placementTracker,
      maxWords: criteria.maxStageWords,
      startingPoint: startingPoint,
    );

    while (true) {
      final validation = validateStageCriteria(
        tracker: placementTracker,
        criteria: criteria,
      );

      if (validation.isValid) break;

      if (validation.needsMoreWords) {
        List<String> leftoverWords = await StageValidationService.instance
            .getWordsWithoutPosition();

        if (leftoverWords.isNotEmpty) {
          _placeLeftOvers(
            board: board,
            words: leftoverWords,
            tracker: placementTracker,
            startingPoint: selectedStartingPosition,
          );
        } else {
          final Map<String, int> notEnoughMap = _handleNotEnoughWords(
            tracker: placementTracker,
            words: words,
            board: board,
            startingPlacement: startingPoint,
            hasBeenMoved: startPosition != selectedStartingPosition,
          );

          if (notEnoughMap[startingPointKey] == null &&
              notEnoughMap.isNotEmpty) {
            String side = findBestSide(notEnoughMap);

            if (side.isNotEmpty) {
              if (side == leftKey) {
                selectedStartingPosition =
                    selectedStartingPosition - notEnoughMap[leftKey]!;
              }
              if (side == rightKey) {
                selectedStartingPosition =
                    selectedStartingPosition + notEnoughMap[rightKey]!;
              }
              if (side == topKey) {
                selectedStartingPosition =
                    selectedStartingPosition -
                    (notEnoughMap[topKey]! *
                        StageGeneratorService.maxRowLength);
              }
              if (side == bottomKey) {
                selectedStartingPosition =
                    selectedStartingPosition +
                    (notEnoughMap[topKey]! *
                        StageGeneratorService.maxRowLength);
              }
            }
          } else {
            selectedStartingPosition = startPosition;
            startingPoint = notEnoughMap[startingPointKey] ?? 0;
          }

          _placeAllWords(
            board: board,
            words: words,
            startPosition: selectedStartingPosition,
            tracker: placementTracker,
            maxWords: criteria.maxStageWords,
            startingPoint: startingPoint,
          );

          if (startingPoint == criteria.biggestWordLength) {
            // edw that to termatizeis
          }
        }
      }
    }

    List<String> stageLetters = [];

    for (int i = 0; i < stageKey.length; i++) {
      stageLetters.add(stageKey[i]);
    }

    return CurrentStage(board: board, letters: stageLetters);
  }

  int _calculateCenterStartPosition(int wordLength) {
    const center =
        StageGeneratorService.maxBoardSize ~/ 2 -
        (StageGeneratorService.maxRowLength ~/ 2);
    return center - (wordLength ~/ 2);
  }

  void _placeAllWords({
    required List<String> board,
    required List<String> words,
    required int startPosition,
    required WordPlacementTracker tracker,
    required int maxWords,
    required int startingPoint,
  }) {
    for (final word in words) {
      if (tracker.wordCount == maxWords) break;

      final success = tracker.isEmpty
          ? _placeInitialWord(board, word, startPosition, tracker)
          : _placeCrossingWord(board, word, tracker, startingPoint);

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
    required int startingPoint,
  }) {
    for (final word in words) {
      final success = _placeCrossingWord(board, word, tracker, startingPoint);

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
    WordPlacementTracker tracker,
    int initialPosition,
  ) {
    for (int i = tracker.wordCount - 1; i >= 0; i--) {
      final placement = tracker.getPlacement(i);
      final intersections = _findIntersections(
        newWord: word,
        existingWord: placement.word,
        existingPositions: placement.positions,
        firstWordStartingPoint: initialPosition,
        isFirstWord: initialPosition > 0,
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
    required int firstWordStartingPoint,
    bool isFirstWord = false,
  }) {
    final int startingPoint = isFirstWord ? firstWordStartingPoint : 0;
    final intersections = <int, String>{};

    for (int i = startingPoint; i < existingWord.length; i++) {
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

  Map<String, int> _handleNotEnoughWords({
    required List<String> words,
    required WordPlacementTracker tracker,
    required List<String> board,
    required int startingPlacement,
    bool hasBeenMoved = false,
  }) {
    Map<String, int> result = {};

    if (!hasBeenMoved) {
      result = _checkEmptyRowsCols(board);

      tracker.clear();
      _resetBoard(board);
      StageValidationService.instance.clearFailedWords();

      return result;
    }

    tracker.clear();
    _resetBoard(board);
    StageValidationService.instance.clearFailedWords();

    startingPlacement++;
    result[startingPointKey] = startingPlacement;

    return result;
  }

  void _resetBoard(List<String> board) {
    for (int i = 0; i < board.length; i++) {
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
      while (!BoardHelper.positionWithLetter(board, row)) {
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
      int row = i;
      while (!BoardHelper.positionWithLetter(board, row)) {
        row = row + StageGeneratorService.maxRowLength;
        if (row > StageGeneratorService.maxBoardSize) break;
      }

      if (row > StageGeneratorService.maxBoardSize) {
        if ((row ~/ StageGeneratorService.maxRowLength) <
            (StageGeneratorService.maxRowLength / 2)) {
          result[leftKey] = (result[leftKey] ?? 0) + 1;
        } else {
          result[rightKey] = (result[rightKey] ?? 0) + 1;
        }
      }
    }

    return result;
  }

  String findBestSide(Map<String, int> notEnoughMap) {
    int left = notEnoughMap[leftKey] ?? 0;
    int right = notEnoughMap[rightKey] ?? 0;
    int top = notEnoughMap[topKey] ?? 0;
    int bottom = notEnoughMap[bottomKey] ?? 0;

    int maxValue = [left, right, top, bottom].reduce((a, b) => a > b ? a : b);

    if (maxValue == 0 || (left == right && right == top && top == bottom)) {
      return '';
    }

    if (left == maxValue) return leftKey;
    if (right == maxValue) return rightKey;

    if (top == maxValue) return topKey;
    if (bottom == maxValue) return bottomKey;

    return '';
  }
}
