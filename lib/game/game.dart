class Game {

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

  // callbacks into our UI
  void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) onGameEnd;

  Game(this.showMoveOnUi, this.onGameEnd);

  void onHumanPlayed(List<int> board) {

    // evaluate the board after the human player move
    int evaluation = evaluateBoard(board);
    if (evaluation != NO_WINNERS_YET) {
      onGameEnd(evaluation);
      return;
    }

    // calculate the next move
    int aiMove = ai(board, Game.AI_PLAYER);

    // do the next move
    board[aiMove] = AI_PLAYER;

    // evaluate the board after the AI player move
    evaluation = evaluateBoard(board);
    if (evaluation != NO_WINNERS_YET)
      onGameEnd(evaluation);
    else
      showMoveOnUi(aiMove);
  }

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
  int ai(List<int> board, int currentPlayer) {

    List<int> newBoard;
    // will contain our next best score and move
    int bestScore = -10000;
    int bestMove;

    // try all possible moves
    for(int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!isMoveLegal(board, currentMove)) continue;

      // we need a copy of the board so we don't pollute our real board
      newBoard = List.from(board);

      // make the move
      newBoard[currentMove] = currentPlayer;

      int nextScore = -getBestScore(newBoard, flipPlayer(currentPlayer));

      // check if the current move is better than our best found move
      if (nextScore > bestScore) {
        bestScore = nextScore;
        bestMove = currentMove;
      }
    }

    return bestMove;
  }

  /// Returns the best possible score for a certain board condition.
  int getBestScore(List<int> board, int currentPlayer) {
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
      int nextScore = -getBestScore(newBoard, flipPlayer(currentPlayer));

      // check if the current move is better than our best found move
      if (nextScore > bestScore) {
        bestScore = nextScore;
      }
    }

    return bestScore;
  }
}