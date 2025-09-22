import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';

class BoardHelper {
  static bool isHorizontal(List<int> position) {
    if (position[1] - position[0] == 1) return true;
    return false;
  }

  static bool isAtSameRow(int position, {bool firstLetter = true}) {
    int rowPosition = position ~/ StageGeneratorService.maxRowLength;

    int adjustNeighbor = firstLetter ? position - 1 : position + 1;

    int rowNeighbor = adjustNeighbor ~/ StageGeneratorService.maxRowLength;

    if (rowPosition == rowNeighbor) return true;
    return false;
  }

  static bool availableSpot({
    required List<String> board,
    required int position,
    String? letter,
  }) {
    if (board[position].isEmpty || board[position] == AppKeys.boardPlaceholder)
      return true;
    if (letter != null && board[position] == letter) return true;

    return false;
  }

  static bool insideBoardLimits(int position) {
    if (position >= 0 && position < StageGeneratorService.maxBoardSize)
      return true;
    return false;
  }

  static bool positionWithLetter(List<String> board, int position) {
    if (board[position].isNotEmpty &&
        board[position] != AppKeys.boardPlaceholder &&
        board[position] != AppKeys.boardBannedPlace) {
      return true;
    }

    return false;
  }
}
