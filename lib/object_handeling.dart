import 'package:flutter/material.dart';

// import 'grid_snap.dart';



class LogicObj {
  List<String> id;
  // Offset pos;
  int size;
  int sides;    // shape

  LogicObj({
    required this.id,
    // required this.pos,
    this.size = 1,
    this.sides = 4,
  });
}

class LogicBoard {
  List<List<List<LogicObj>>> board = [
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []]];

  void addObj(LogicObj logicObj, Offset pos) {
    if (board[pos.dx.floor()][pos.dy.floor()].isEmpty) {
      board[pos.dx.floor()][pos.dy.floor()].add(logicObj);
    }
  }

  void addId(Offset pos, String id) {
    if(board[pos.dx.floor()][pos.dy.floor()].isNotEmpty && !board[pos.dx.floor()][pos.dy.floor()][0].id.contains(id)) {
      board[pos.dx.floor()][pos.dy.floor()][0].id.add(id);
    }
  }

  void removeId(Offset pos, String id) {
    if (board[pos.dx.floor()][pos.dy.floor()].isNotEmpty) {
      board[pos.dx.floor()][pos.dy.floor()][0].id.remove(id);
      // if(board[pos.dx.floor()][pos.dy.floor()][0].id.isEmpty) {
      //   board[pos.dx.floor()][pos.dy.floor()].removeAt(0);
      // }
    }
  }

  void setSize(Offset pos, int size) {
    if(board[pos.dx.floor()][pos.dy.floor()].isNotEmpty) {
      board[pos.dx.floor()][pos.dy.floor()][0].size = size;
    }
  }

  void setSides(Offset pos, int sides) {
    if (board[pos.dx.floor()][pos.dy.floor()].isNotEmpty) {
      board[pos.dx.floor()][pos.dy.floor()][0].sides = sides;
    }
  }

  void moveObj(Offset pos1, Offset pos2) {
    if (board[pos1.dx.floor()][pos1.dy.floor()].isNotEmpty && board[pos2.dx.floor()][pos2.dy.floor()].isEmpty) {
     board[pos2.dx.floor()][pos2.dy.floor()] = board[pos1.dx.floor()][pos1.dy.floor()];
     board[pos1.dx.floor()][pos1.dy.floor()] = [];
    }
  }

  void rotateLeft() {
    List<List<List<LogicObj>>> rotArr = [];
    for (int i=0; i<board[0].length; i++) {
      rotArr.add([]);
      for (int j=0; j<board.length; j++) {
        rotArr[i].add(board[j][board[j].length-(i+1)]);
      }
    }
    board = rotArr;
  }

  void rotateRight() {
    List<List<List<LogicObj>>> rotArr = [];
    for (int i=0; i<board[0].length; i++) {
      rotArr.add([]);
      for (int j=0; j<board.length; j++) {
        rotArr[i].insert(0, board[j][i]);
      }
    }
    board = rotArr;
  }
}

class BoardRenderer extends StatefulWidget{
  const BoardRenderer({super.key});

  @override
  State<BoardRenderer> createState() => BorderRendererState(); 

}

class BorderRendererState extends State<BoardRenderer> {

  void _onTapDown(TapDownDetails details) {

  }

  void _onPanStart(DragStartDetails details) {

  }

  void _onPanUpdate(DragUpdateDetails details) {

  }

  void _onPanEnd(DragEndDetails details) {

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       const Image(
        image: AssetImage('8x8_grid.png'),
        height: 80000,
        width: 80000,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
      GestureDetector(
        onTapDown: _onTapDown,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      ),
      ],
      );
  }

}