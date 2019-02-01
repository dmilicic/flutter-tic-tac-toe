import 'package:flutter_tic_tac_toe/ai/ai.dart';

class Utils {

  //region utility
  static bool isBoardFull(List<int> board) {
    for (var val in board) {
      if (val == Ai.EMPTY_SPACE) return false;
    }

    return true;
  }

  static bool isMoveLegal(List<int> board, int move) {
    if (move < 0 || move >= board.length ||
        board[move] != Ai.EMPTY_SPACE)
      return false;

    return true;
  }

  /// Returns the current state of the board [winning player, draw or no winners yet]
  static int evaluateBoard(List<int> board) {
    for (var list in Ai.WIN_CONDITIONS_LIST) {
      if (board[list[0]] != Ai.EMPTY_SPACE && // if a player has played here AND
          board[list[0]] == board[list[1]] && // if all three positions are of the same player
          board[list[0]] == board[list[2]]) {
        return board[list[0]];
      }
    }

    if (isBoardFull(board)) {
      return Ai.DRAW;
    }

    return Ai.NO_WINNERS_YET;
  }

  /// Returns the opposite player from the current one.
  static int flipPlayer(int currentPlayer) {
    return -1 * currentPlayer;
  }
//endregion
}