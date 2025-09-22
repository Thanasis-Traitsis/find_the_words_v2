import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';

abstract class PlacementStrategy {
  List<int> tryPlace({
    required List<String> board,
    required String word,
    required Map<int, String> intersections,
  });

  bool _canPlaceAtPosition(
    List<String> board,
    int position,
    String letter, {
    bool isHorizontal = true,
  }) {
    if (!BoardHelper.insideBoardLimits(position)) return false;
    if (!BoardHelper.availableSpot(
      board: board,
      position: position,
      letter: letter,
    )) {
      return false;
    }

    if (letter == board[position]) return true;

    final neighborPositions = _getPerpendicularNeighbors(
      position,
      isHorizontal,
    );

    for (final neighborPos in neighborPositions) {
      if (BoardHelper.insideBoardLimits(neighborPos) &&
          BoardHelper.positionWithLetter(board, neighborPos)) {
        return false;
      }
    }

    return true;
  }

  List<int> _getPerpendicularNeighbors(int position, bool isHorizontal) {
    if (isHorizontal) {
      return [
        position - StageGeneratorService.maxRowLength,
        position + StageGeneratorService.maxRowLength,
      ];
    } else {
      return [position - 1, position + 1];
    }
  }

  bool _wordTouchesOtherWord(List<String> board, int position) {
    if (BoardHelper.insideBoardLimits(position)) {
      return BoardHelper.positionWithLetter(board, position);
    }
    return false;
  }

  void _placeWordOnBoard(List<String> board, List<int> positions, String word) {
    for (int i = 0; i < positions.length; i++) {
      board[positions[i]] = word[i];
    }
  }
}

class VerticalPlacementStrategy extends PlacementStrategy {
  @override
  List<int> tryPlace({
    required List<String> board,
    required String word,
    required Map<int, String> intersections,
  }) {
    for (final entry in intersections.entries) {
      final position = entry.key;
      final letter = entry.value;

      for (int i = 0; i < word.length; i++) {
        if (letter == word[i]) {
          final positions = _calculateVerticalPositions(
            intersectionPosition: position,
            wordLength: word.length,
            letterIndex: i,
          );

          if (_allPositionsValid(board, positions, word)) {
            _placeWordOnBoard(board, positions, word);
            return positions;
          }
        }
      }
    }

    return [];
  }

  List<int> _calculateVerticalPositions({
    required int intersectionPosition,
    required int wordLength,
    required int letterIndex,
  }) {
    final positions = <int>[];

    // Add positions above intersection
    for (int i = letterIndex - 1; i >= 0; i--) {
      final offset = (letterIndex - i) * StageGeneratorService.maxRowLength;
      positions.add(intersectionPosition - offset);
    }

    // Add intersection position
    positions.add(intersectionPosition);

    // Add positions below intersection
    for (int i = letterIndex + 1; i < wordLength; i++) {
      final offset = (i - letterIndex) * StageGeneratorService.maxRowLength;
      positions.add(intersectionPosition + offset);
    }

    positions.sort();
    return positions;
  }

  bool _allPositionsValid(
    List<String> board,
    List<int> positions,
    String word,
  ) {
    if (positions.length != word.length) return false;

    for (int i = 0; i < positions.length; i++) {
      if (i == 0) {
        if (_wordTouchesOtherWord(
          board,
          positions[i] - StageGeneratorService.maxRowLength,
        )) {
          return false;
        }
      }
      if (i == positions.length - 1) {
        if (_wordTouchesOtherWord(
          board,
          positions[i] + StageGeneratorService.maxRowLength,
        )) {
          return false;
        }
      }
      if (!_canPlaceAtPosition(
        board,
        positions[i],
        word[i],
        isHorizontal: false,
      )) {
        return false;
      }
    }
    return true;
  }
}

class HorizontalPlacementStrategy extends PlacementStrategy {
  @override
  List<int> tryPlace({
    required List<String> board,
    required String word,
    required Map<int, String> intersections,
  }) {
    for (final entry in intersections.entries) {
      final position = entry.key;
      final letter = entry.value;

      for (int i = 0; i < word.length; i++) {
        if (letter == word[i]) {
          final positions = _calculateHorizontalPositions(
            intersectionPosition: position,
            wordLength: word.length,
            letterIndex: i,
          );

          if (_allPositionsValid(board, positions, word)) {
            _placeWordOnBoard(board, positions, word);
            return positions;
          }
        }
      }
    }

    return [];
  }

  List<int> _calculateHorizontalPositions({
    required int intersectionPosition,
    required int wordLength,
    required int letterIndex,
  }) {
    final positions = <int>[];

    // Add positions before intersection
    for (int i = letterIndex - 1; i >= 0; i--) {
      final offset = letterIndex - i;
      positions.add(intersectionPosition - offset);
    }

    // Add intersection position
    positions.add(intersectionPosition);

    // Add positions after intersection
    for (int i = letterIndex + 1; i < wordLength; i++) {
      final offset = i - letterIndex;
      positions.add(intersectionPosition + offset);
    }

    positions.sort();
    return positions;
  }

  bool _allPositionsValid(
    List<String> board,
    List<int> positions,
    String word,
  ) {
    if (positions.length != word.length) {
      return false;
    }

    for (int i = 0; i < positions.length; i++) {
      if (i != 0) {
        int currentRow = positions[i] ~/ StageGeneratorService.maxRowLength;
        int previousRow =
            positions[i - 1] ~/ StageGeneratorService.maxRowLength;
        if (currentRow != previousRow) {
          return false;
        }
      }

      if (i == 0 && _wordTouchesOtherWord(board, positions[i] - 1)) {
        return false;
      }

      if (i == positions.length - 1 &&
          _wordTouchesOtherWord(board, positions[i] + 1)) {
        return false;
      }

      if (!_canPlaceAtPosition(board, positions[i], word[i])) {
        return false;
      }
    }

    return true;
  }
}
