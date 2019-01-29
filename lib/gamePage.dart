import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/field.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';

class GamePage extends StatefulWidget {

  final String title;
  Game game;

  @override
  _GamePageState createState() => _GamePageState();

  GamePage(this.title) {
    this.game = Game();
  };
}

class _GamePageState extends State<GamePage> {

  List<int> board;
  int currentPlayer;

  void _onTap(int idx) {
    setState(() {
      board[idx] = currentPlayer;
    });
  }


  @override
  void initState() {
    super.initState();

    currentPlayer = Game.PLAYER_X;
    board = List.generate(9, (idx) => 0);

    widget.game.ai(board, currentPlayer, 0);
  }

  @override
  Widget build(BuildContext context) {


    print(board);

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
                var symbol = Game.symbols[board[idx]];
                return Field(idx: idx, playerSymbol: symbol, onTap: _onTap);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
