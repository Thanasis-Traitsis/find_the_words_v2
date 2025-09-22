import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';

class NeighborMarker {
  final List<String> board;

  NeighborMarker({required this.board});

  void markHorizontalWordNeighbors(List<int> positions) {
    _markWordEnds(positions, isHorizontal: true);
    _markParallelNeighbors(positions, isHorizontal: true);
  }

  void markVerticalWordNeighbors(List<int> positions) {
    _markWordEnds(positions, isHorizontal: false);
    _markParallelNeighbors(positions, isHorizontal: false);
  }

  void _markWordEnds(List<int> positions, {required bool isHorizontal}) {
    final firstEndPosition = _calculateEndPosition(
      positions.first,
      isStart: true,
      isHorizontal: isHorizontal,
    );

    final lastEndPosition = _calculateEndPosition(
      positions.last,
      isStart: false,
      isHorizontal: isHorizontal,
    );

    if (firstEndPosition != null)
      _markIfValid(firstEndPosition, AppKeys.boardBannedPlace);
    if (lastEndPosition != null)
      _markIfValid(lastEndPosition, AppKeys.boardBannedPlace);
  }

  void _markParallelNeighbors(
    List<int> positions, {
    required bool isHorizontal,
  }) {
    for (final position in positions) {
      final neighbors = _getParallelNeighbors(position, isHorizontal);

      for (final neighbor in neighbors) {
        _markAsAvailableNeighbor(neighbor);
      }
    }
  }

  int? _calculateEndPosition(
    int position, {
    required bool isStart,
    required bool isHorizontal,
  }) {
    if (isHorizontal) {
      if (isStart) {
        if (BoardHelper.isAtSameRow(position)) {
          return position - 1;
        }
      } else {
        if (BoardHelper.isAtSameRow(position, firstLetter: false)) {
          return position + 1;
        }
      }
    } else {
      return isStart
          ? position - StageGeneratorService.maxRowLength
          : position + StageGeneratorService.maxRowLength;
    }

    return null;
  }

  List<int> _getParallelNeighbors(int position, bool isHorizontal) {
    if (isHorizontal) {
      return [
        position - StageGeneratorService.maxRowLength,
        position + StageGeneratorService.maxRowLength,
      ];
    } else {
      return [
        if (BoardHelper.isAtSameRow(position)) position - 1,
        if (BoardHelper.isAtSameRow(position, firstLetter: false)) position + 1,
      ];
    }
  }

  void _markIfValid(int position, String marker) {
    if (BoardHelper.insideBoardLimits(position) &&
        BoardHelper.availableSpot(board: board, position: position)) {
      board[position] = marker;
    }
  }

  void _markAsAvailableNeighbor(int position) {
    if (BoardHelper.insideBoardLimits(position) &&
        BoardHelper.availableSpot(board: board, position: position)) {
      board[position] = board[position] + AppKeys.boardPlaceholder;
    }
  }
}
