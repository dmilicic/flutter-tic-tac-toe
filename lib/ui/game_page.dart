
import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ai/Ai.dart';
import 'package:flutter_tic_tac_toe/ui/Field.dart';
import 'package:flutter_tic_tac_toe/ui/game_presenter.dart';

class GamePage extends StatefulWidget {

  final String title;

  @override
  _GamePageState createState() => _GamePageState();

  GamePage(this.title);
}

class _GamePageState extends State<GamePage> {

  List<int> board;
  int currentPlayer;
  GamePresenter game;

  _GamePageState() {
    this.game = GamePresenter(_movePlayed, _onGameEnd);
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
        board[idx] = currentPlayer;

      if (currentPlayer == Ai.HUMAN) {
        // switch to AI player
        currentPlayer = Ai.AI_PLAYER;
        game.onHumanPlayed(board);

      } else {
        currentPlayer = Ai.HUMAN;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reinitialize();
  }

  void reinitialize() {
    currentPlayer = Ai.HUMAN;
    board = List.generate(9, (idx) => 0);
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
            child: Text("You are playing as X", style: TextStyle(fontSize: 30),),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (idx) {
                var symbol = Ai.SYMBOLS[board[idx]];
                return Field(idx: idx, playerSymbol: symbol, onTap: _movePlayed);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
