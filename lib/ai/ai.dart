import 'utils.dart';

class Ai {

  // evaluation condition values
  static const int HUMAN = 1;
  static const int AI_PLAYER = -1;
  static const int NO_WINNERS_YET = 0;
  static const int DRAW = 2;

  static const int EMPTY_SPACE = 0;
  static const SYMBOLS = {EMPTY_SPACE: "", HUMAN: "X", AI_PLAYER: "O"};

  // arbitrary values for winning, draw and losing conditions
  static const int WIN_SCORE = 100;
  static const int DRAW_SCORE = 0;
  static const int LOSE_SCORE = -100;

  static const WIN_CONDITIONS_LIST = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  /// Returns the optimal move based on the state of the board.
  int play(List<int> board, int currentPlayer) {
    return _getBestMove(board, currentPlayer).move;
  }

  /// Returns the best possible score for a certain board condition.
  /// This method implements the stopping condition.
  int _getBestScore(List<int> board, int currentPlayer) {
    int evaluation = Utils.evaluateBoard(board);

    if (evaluation == currentPlayer)
      return WIN_SCORE;

    if (evaluation == DRAW)
      return DRAW_SCORE;

    if (evaluation == Utils.flipPlayer(currentPlayer)) {
      return LOSE_SCORE;
    }

    return _getBestMove(board, currentPlayer).score;
  }

  /// This is where the actual Minimax algorithm is implemented
  Move _getBestMove(List<int> board, int currentPlayer) {
    // try all possible moves
    List<int> newBoard;
    // will contain our next best score
    Move bestMove = Move(score: -10000, move: -1);

    for(int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!Utils.isMoveLegal(board, currentMove)) continue;

      // we need a copy of the initial board so we don't pollute our real board
      newBoard = List.from(board);

      // make the move
      newBoard[currentMove] = currentPlayer;

      // solve for the next player
      // what is a good score for the opposite player is opposite of good score for us
      int nextScore = -_getBestScore(newBoard, Utils.flipPlayer(currentPlayer));

      // check if the current move is better than our best found move
      if (nextScore > bestMove.score) {
        bestMove.score = nextScore;
        bestMove.move = currentMove;
      }
    }

    return bestMove;
  }

}

class Move {
  int score;
  int move;

  Move({this.score, this.move});
}