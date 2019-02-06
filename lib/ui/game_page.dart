
import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ai/ai.dart';
import 'package:flutter_tic_tac_toe/ui/field.dart';
import 'package:flutter_tic_tac_toe/ui/game_board.dart';
import 'package:flutter_tic_tac_toe/ui/game_presenter.dart';
import 'package:flutter_tic_tac_toe/ui/game_state_inherited_widget.dart';

class GamePage extends StatefulWidget {

  final String title;

  GamePage(this.title);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {

  List<int> board;
  int _currentPlayer;
  
  GamePresenter _presenter;
  
  // contains widgets that display each cell
  List<Widget> _fields;

  GamePageState() {
    this._presenter = GamePresenter(_movePlayed, _onGameEnd);
  }

  void _onGameEnd(int winner) {

    var title = "Game over!";
    var content = "You lose :(";
    switch(winner) {
      case Ai.HUMAN: // will never happen :)
        title = "Congratulations!";
        content = "You managed to beat an unbeatable AI!";
        break;
      case Ai.AI_PLAYER:
        title = "Game Over!";
        content = "You lose :(";
        break;
      default:
        title = "Draw!";
        content = "No winners here.";
    }


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    setState(() {
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Restart"))
            ],
          );
    });
  }

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.HUMAN) {
        // switch to AI player
        _currentPlayer = Ai.AI_PLAYER;
        _presenter.onHumanPlayed(board);

      } else {
        _currentPlayer = Ai.HUMAN;
      }
    });
  }


  String getSymbolForIdx(int idx) {
    return Ai.SYMBOLS[board[idx]];
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


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(60),
            child: Text("You are playing as X", style: TextStyle(fontSize: 25),),
          ),
          GameStateInheritedWidget(
              state: this,
              child: Expanded(
                  child: GridView.count(
                      crossAxisCount: 3,
                      children: _fields
                  ),
              ),
            )
        ],
      ),
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

  final GamePageState state;

  @override
  bool updateShouldNotify(GameStateInheritedWidget old) {
    return true;
  }
}

