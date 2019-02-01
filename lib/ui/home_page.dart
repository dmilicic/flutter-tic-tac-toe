import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ui/home_presenter.dart';
import 'package:flutter_tic_tac_toe/ui/game_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomePresenter _presenter;

  _HomePageState() {
    _presenter = HomePresenter();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Welcome to Flutter Tic Tac Toe!", style: TextStyle(fontSize: 20),),
          Center(
            child: ButtonTheme(
              minWidth: 200,
              height: 80,
              child: RaisedButton(
                color: Colors.amber,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage(widget.title))
                  );
                },
                child: Text("New game!", style: TextStyle(fontSize: 20),),
              ),
            ),
          ),
          StreamBuilder(
              stream: _presenter.buildVictoriesStream(),
              builder: (context, snapshot) {
                var playerCount = _presenter.getVictoryCount(snapshot);
                return Text("Number of players beaten: $playerCount", style: TextStyle(fontSize: 15));
          }),

        ],
      ),
    );
  }
}
