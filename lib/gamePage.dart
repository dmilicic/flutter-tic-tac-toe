import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/field.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';

class GamePage extends StatefulWidget {

  final String title;

  @override
  _GamePageState createState() => _GamePageState();

  GamePage(this.title);
}

class _GamePageState extends State<GamePage> {

  List<int> board;

  void _onTap(int idx) {
    setState(() {
      board[idx] = 1;
    });
  }


  @override
  void initState() {
    super.initState();

    board = List.generate(9, (idx) {
      var rng = Random();
      return rng.nextInt(3);
    });
  }

  @override
  Widget build(BuildContext context) {


    print(board);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (idx) {
          var symbol = Game.symbols[board[idx]];
          return Field(idx: idx, playerSymbol: symbol, onTap: _onTap);
        }),
      ),
    );
  }
}
