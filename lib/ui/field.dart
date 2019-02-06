import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tic_tac_toe/ui/game_page.dart';

class Field extends StatefulWidget {

  final int idx;
  final Function(int idx) onTap;

  final BorderSide _borderSide = BorderSide(
      color: Colors.amber,
      width: 2.0,
      style: BorderStyle.solid
  );


  Field({Key key, this.idx, @required this.onTap}) : super(key: key);

  /// Returns a border to draw depending on this field index.
  Border _determineBorder() {
    Border determinedBorder = Border.all();

    switch(idx) {
      case 0:
        determinedBorder = Border(bottom: _borderSide, right: _borderSide);
        break;
      case 1:
        determinedBorder = Border(left: _borderSide, bottom: _borderSide, right: _borderSide);
        break;
      case 2:
        determinedBorder = Border(left: _borderSide, bottom: _borderSide);
        break;
      case 3:
        determinedBorder = Border(bottom: _borderSide, right: _borderSide, top: _borderSide);
        break;
      case 4:
        determinedBorder = Border(left: _borderSide, bottom: _borderSide, right: _borderSide, top: _borderSide);
        break;
      case 5:
        determinedBorder = Border(left: _borderSide, bottom: _borderSide, top: _borderSide);
        break;
      case 6:
        determinedBorder = Border(right: _borderSide, top: _borderSide);
        break;
      case 7:
        determinedBorder = Border(left: _borderSide, top: _borderSide, right: _borderSide);
        break;
      case 8:
        determinedBorder = Border(left: _borderSide, top: _borderSide);
        break;
    }

    return determinedBorder;
  }



  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {

  String playerSymbol;

  void _handleTap() {
    // only send tap events if the field is empty
    if (playerSymbol == "")
      widget.onTap(widget.idx);
  }


  @override
  Widget build(BuildContext context) {

    // determine the symbol that this widget needs to show
    GameStateInheritedWidget inherited = GameStateInheritedWidget.of(context);
    playerSymbol = inherited.state.getSymbolForIdx(widget.idx);

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        margin: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            border: widget._determineBorder()
        ),
        child: Center(
            child: Text(playerSymbol, style: TextStyle(fontSize: 50))
        ),
      ),
    );
  }
}

