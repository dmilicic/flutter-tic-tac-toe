class Game {

  static List<String> symbols = ["", "X", "O"]; // X is player 1, O is player 2
  static const int EMPTY_SPACE = 0;

  // evaluation condition values
  static const int PLAYER_X = 1;
  static const int PLAYER_Y = -1;
  static const int NO_WINNERS_YET = 0;
  static const int DRAW = 2;

  // arbitrary values for winning, draw and losing conditions
  static const int WIN_SCORE = 100;
  static const int DRAW_SCORE = 0;
  static const int LOSE_SCORE = -100;

  static const List<List<int>> WIN_CONDITIONS_LIST = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  //region utility
  bool isBoardFull(List<int> board) {
    for (var val in board) {
      if (val == EMPTY_SPACE) return false;
    }

    return true;
  }

  bool isMoveLegal(List<int> board, int move) {
    if (move < 0 || move >= board.length ||
        board[move] != EMPTY_SPACE)
      return false;

    return true;
  }

  /// Returns the current state of the board [winning player, draw or no winners yet]
  int evaluateBoard(List<int> board) {
    for (var list in WIN_CONDITIONS_LIST) {
      if (board[list[0]] != EMPTY_SPACE && // if a player has played here AND
          board[list[0]] == board[list[1]] && // if all three positions are of the same player
          board[list[0]] == board[list[2]]) {
        return board[list[0]];
      }
    }
    
    if (isBoardFull(board)) {
      return DRAW;
    }

    return NO_WINNERS_YET;
  }

  /// Returns the opposite player from the current one.
  int flipPlayer(int currentPlayer) {
    return -1 * currentPlayer;
  }
  //endregion

  /// Returns the optimal move based on the state of the board.
  Move ai(List<int> board, int currentPlayer, int previousMove) {

    int evaluation = evaluateBoard(board);

    if (evaluation == currentPlayer)
      return Move(previousMove, WIN_SCORE);

    if (evaluation == DRAW)
      return Move(previousMove, DRAW_SCORE);

    if (evaluation == flipPlayer(currentPlayer)) {
      return Move(previousMove, LOSE_SCORE);
    }

    // try all possible moves
    List<int> newBoard;
    // will contain our next best move
    Move bestMove;

    for(int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!isMoveLegal(board, currentMove)) continue;

      // we need a copy of the board so we don't pollute our real board
      newBoard = List.from(board);

      // make the move
      newBoard[currentMove] = currentPlayer;
      Move nextMove = ai(newBoard, flipPlayer(currentPlayer), currentMove);
      nextMove.score = -nextMove.score; // what is a good score for the opposite player is opposite of good score for us

      // check if the current move is better than our best found move
      if (bestMove == null || bestMove.score < nextMove.score) {
        bestMove = nextMove;
      }
    }

    return bestMove;
  }

  int solve(List<int> board, int currentPlayer) {
    int evaluation = evaluateBoard(board);

    if (evaluation == currentPlayer)
      return WIN_SCORE;

    if (evaluation == DRAW)
      return DRAW_SCORE;

    if (evaluation == flipPlayer(currentPlayer)) {
      return LOSE_SCORE;
    }

    // try all possible moves
    List<int> newBoard;
    // will contain our next best score
    int bestScore = -10000;

    for(int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!isMoveLegal(board, currentMove)) continue;

      // we need a copy of the board so we don't pollute our real board
      newBoard = List.from(board);

      // make the move
      newBoard[currentMove] = currentPlayer;

      // solve for the next player
      // what is a good score for the opposite player is opposite of good score for us
      int nextScore = -solve(newBoard, flipPlayer(currentPlayer));

      // check if the current move is better than our best found move
      if (nextScore > bestScore) {
        bestScore = nextScore;
      }
    }

    return bestScore;
  }

}

class Move {
  int move;
  int score;

  Move(this.move, this.score);
}