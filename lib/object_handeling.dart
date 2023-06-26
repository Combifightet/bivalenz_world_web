import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'theme.dart';


// import 'grid_snap.dart';

LogicBoard mainBoard = LogicBoard();


class LogicObj {
  List<String> id;
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
  [[], [LogicObj(id: ['b'], sides: 3)], [LogicObj(id: ['a'])], [LogicObj(id: [])], [LogicObj(id: [])], [], [], []],
  [[], [], [LogicObj(id: [])], [], [LogicObj(id: [])], [], [], []],
  [[], [], [LogicObj(id: [])], [LogicObj(id: [])], [LogicObj(id: [])], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []]];

  Offset? selected;

  void selectTile(Offset pos) {
    if (selected != Offset(pos.dx.floorToDouble(),pos.dy.floorToDouble())) {
      selected = Offset(pos.dx.floorToDouble(),pos.dy.floorToDouble());
    } else {
      selected = null;
    }
  }

  void deselectTile() {
    selected = null;
  }

  void addObj(LogicObj logicObj, [Offset? pos]) {
    pos = pos ?? selected;
    if (pos != null) {
      if (board[pos.dy.floor()][pos.dx.floor()].isEmpty) {
        board[pos.dy.floor()][pos.dx.floor()].add(logicObj);
      }
    }
  }

  void removeObj([Offset? pos]) {
    pos = pos ?? selected;
    if (pos != null) {
      board[pos.dy.floor()][pos.dx.floor()] = [];
    }
  }

  void addId(String id, [Offset? pos, bool multiObjectId = false]) {
    pos = pos ?? selected;
    if (pos != null) {
      if(board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
        if (!board[pos.dy.floor()][pos.dx.floor()][0].id.contains(id)) {
          if (multiObjectId) {
            board[pos.dy.floor()][pos.dx.floor()][0].id.add(id);
          } else {
            for (int i=0; i<board.length; i++) {
              for (int j=0; j<board[i].length; j++) {
                if (board[i][j].isNotEmpty && board[i][j][0].id.contains(id)) {
                  removeId(id, Offset(j.floorToDouble(), i.floorToDouble()));
                }
              }
            }
            board[pos.dy.floor()][pos.dx.floor()][0].id.add(id);
          }
        } else {
          removeId(id, pos);
        }
      }
    }
  }

  void removeId(String id, [Offset? pos]) {
    pos = pos ?? selected;
    if (pos != null) {
      if (board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
        board[pos.dy.floor()][pos.dx.floor()][0].id.remove(id);
      }
    }
  }

  void setSize(int size, [Offset? pos]) {
    pos = pos ?? selected;
    if (pos != null) {
      if(board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
        board[pos.dy.floor()][pos.dx.floor()][0].size = size;
      }
    }
  }

  void setSides(int sides, [Offset? pos]) {
    pos = pos ?? selected;
    if (pos != null) {
      if (board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
        if (board[pos.dy.floor()][pos.dx.floor()][0].sides == sides) {
          removeObj(pos);
        } else {
          board[pos.dy.floor()][pos.dx.floor()][0].sides = sides;
        }
      } else {
        addObj(LogicObj(id: [], sides: sides), pos);
      }
    }
  }

  void moveObj(Offset pos1, Offset pos2) {
    if (pos2 == Offset(pos2.dx.clamp(0, 7), pos2.dy.clamp(0, 7))) {
      if (board[pos1.dy.floor()][pos1.dx.floor()].isNotEmpty && board[pos2.dy.floor()][pos2.dx.floor()].isEmpty) {
        board[pos2.dy.floor()][pos2.dx.floor()] = board[pos1.dy.floor()][pos1.dx.floor()];
        removeObj(pos1);
        selectTile(pos2);
      }
    } else {
       removeObj(pos1);
    }
  }

  void rotateCCW() {
    List<List<List<LogicObj>>> rotArr = [];
    for (int i=0; i<board[0].length; i++) {
      rotArr.add([]);
      for (int j=0; j<board.length; j++) {
        rotArr[i].add(board[j][board[j].length-(i+1)]);
      }
    }
    board = rotArr;
    if (selected != null) {
    selected = Offset(selected!.dy, board[0].length-1-selected!.dx);
    }
  }
  void rotateCW() {
    List<List<List<LogicObj>>> rotArr = [];
    for (int i=0; i<board[0].length; i++) {
      rotArr.add([]);
      for (int j=0; j<board.length; j++) {
        rotArr[i].insert(0, board[j][i]);
      }
    }
    board = rotArr;
    if (selected != null) {
    selected = Offset(board.length-1-selected!.dy, selected!.dx);
    }
  }
}

class BoardRenderer extends StatefulWidget{
  const BoardRenderer({super.key});

  @override
  State<BoardRenderer> createState() => BorderRendererState(); 

}

class BorderRendererState extends State<BoardRenderer> {
  final _boardKey = GlobalKey();

  late Offset dragStartPos;
  late Offset dragEndPos;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      mainBoard.selectTile(Offset((details.localPosition.dx/(_boardKey.currentContext!.size!.width/8)).floorToDouble(), (details.localPosition.dy/(_boardKey.currentContext!.size!.width/8)).floorToDouble()));
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
    });
    dragStartPos = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    dragEndPos = details.localPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      mainBoard.moveObj(Offset((dragStartPos.dx/(_boardKey.currentContext!.size!.width/8)).floorToDouble(), (dragStartPos.dy/(_boardKey.currentContext!.size!.width/8)).floorToDouble()), Offset((dragEndPos.dx/(_boardKey.currentContext!.size!.width/8)).floorToDouble(), (dragEndPos.dy/(_boardKey.currentContext!.size!.width/8)).floorToDouble()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _boardKey,
      children: [
        const Image(
          image: AssetImage('8x8_grid.png'),
          height: 80000,
          width: 80000,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){ 
            return CustomPaint(
              painter: BoardPainter(
                board: mainBoard,
                width: constraints.maxWidth
              ),
              willChange: true,
            );
          }
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


class BoardPainter extends CustomPainter {
  final LogicBoard board;
  final double width;

  BoardPainter({
    required this.board,
    required this.width,
  });

  Path drawPoly(int radius, int sides, Offset pos, double size) {
    final double centerX = (size/8*pos.dy) + (size/8)/2;
    final double centerY = (size/8*pos.dx) + (size/8)/2 + (sides==3?4:sides==5?2:0);
    final double angle = (math.pi * 2) / sides;
    final Path polygonPath = Path();

    for (int i = 0; i < sides; i++) {
      final double x = centerX + radius * math.cos(angle * i - (sides%2==0?math.pi/sides:math.pi/2));
      final double y = centerY + radius * math.sin(angle * i - (sides%2==0?math.pi/sides:math.pi/2));

      if (i == 0) {
        polygonPath.moveTo(x, y);
      } else {
        polygonPath.lineTo(x, y);
      }
    }

    polygonPath.close();
    return polygonPath;
  }


  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: foregroundColor,
      fontSize: 0.2*width/8
    );

    if (board.selected != null) {
      canvas.drawRect(
        Rect.fromCircle(
          center: Offset((width/8*board.selected!.dx) + (width/8)/2, (width/8*board.selected!.dy) + (width/8)/2),
          radius: width/8/2,
        ),
        Paint()
          ..color = greenAccentColor.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }

    for (int i=0; i<board.board.length; i++) {
      for (int j=0; j<board.board[i].length; j++) {
        if (board.board[i][j].isNotEmpty){
          canvas.drawPath(
            drawPoly(((board.board[i][j][0].size+1)*15*(width/700)).floor(), board.board[i][j][0].sides, Offset(i.toDouble(), j.toDouble()), width),
            Paint()
            ..color = board.board[i][j][0].sides==3?redAccentColor:board.board[i][j][0].sides==4?blueAccentColor:board.board[i][j][0].sides==5?yellowAccentColor:foregroundColor
            ..style = PaintingStyle.fill
          );
        }
      }
    }

    for (int i=0; i<board.board.length; i++) {
      for (int j=0; j<board.board[i].length; j++) {
        if (board.board[i][j].isNotEmpty && board.board[i][j][0].id.isNotEmpty) {
          String idString = board.board[i][j][0].id.toString();
          final textSpan = TextSpan(
            text: idString.substring(1, idString.length-1),
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );
          textPainter.layout(
            minWidth: 1000,
            // maxWidth: size.width,
          );
          // double textOffset = textPainter.width;
          textPainter.paint(canvas, Offset(j*(width/8)+width/16-500, i*(width/8)+width/8-width/100));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
