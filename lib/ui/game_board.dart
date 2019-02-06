import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ai/ai.dart';
import 'package:flutter_tic_tac_toe/ui/field.dart';
import 'package:flutter_tic_tac_toe/ui/game_presenter.dart';

class GameBoard extends StatefulWidget {

  final Widget child;
  final GamePresenter presenter;

  GameBoard({this.child, this.presenter});

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  List<int> board;
  int _currentPlayer;

  // contains widgets that display each cell
  List<Widget> _fields;

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.HUMAN) {
        // switch to AI player
        _currentPlayer = Ai.AI_PLAYER;
        widget.presenter.onHumanPlayed(board);

      } else {
        _currentPlayer = Ai.HUMAN;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reinitialize();
  }

  void reinitialize() {
    _currentPlayer = Ai.HUMAN;
    // generate the initial board
    board = List.generate(9, (idx) => 0);

    // generate the widgets that will display the board
    _fields = List.generate(9, (idx) {
      return Field(idx: idx, onTap: _movePlayed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameStateInheritedWidget(
      state: this,
      child: widget.child,
    );
  }
}

/// Inherited widget that we will use to refresh our board fields/cells.
class GameStateInheritedWidget extends InheritedWidget {
  const GameStateInheritedWidget ({
    Key key,
    @required this.state,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static GameStateInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(GameStateInheritedWidget);
  }

  final _GameBoardState state;

  @override
  bool updateShouldNotify(GameStateInheritedWidget old) {
    return true;
  }
}

