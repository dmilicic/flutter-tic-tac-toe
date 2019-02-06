import 'package:flutter/material.dart';
import 'ui/home_page.dart';

String title = "Flutter Tic Tac Toe";

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(title: title),
    );
  }
}