import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ui/game_page.dart';


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
