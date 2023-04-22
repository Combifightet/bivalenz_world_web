import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:math' as math;


// import 'grid_snap.dart';



class LogicObj {
  List<String> id;
  // Offset pos;
  int size;
  int sides;    // shape

  LogicObj({
    required this.id,
    // required this.pos,
    this.size = 2,
    this.sides = 4,
  });
}

class LogicBoard {
  List<List<List<LogicObj>>> board = [
  [[], [], [], [], [], [], [], []],
  [[], [], [LogicObj(id: ['a','b'])], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []]];

  void addObj(LogicObj logicObj, Offset pos) {
    if (board[pos.dy.floor()][pos.dx.floor()].isEmpty) {
      board[pos.dy.floor()][pos.dx.floor()].add(logicObj);
    }
  }

  void addId(Offset pos, String id) {
    if(board[pos.dy.floor()][pos.dx.floor()].isNotEmpty && !board[pos.dx.floor()][pos.dy.floor()][0].id.contains(id)) {
      board[pos.dy.floor()][pos.dx.floor()][0].id.add(id);
    }
  }

  void removeId(Offset pos, String id) {
    if (board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
      board[pos.dy.floor()][pos.dx.floor()][0].id.remove(id);
      // if(board[pos.dx.floor()][pos.dy.floor()][0].id.isEmpty) {
      //   board[pos.dx.floor()][pos.dy.floor()].removeAt(0);
      // }
    }
  }

  void setSize(Offset pos, int size) {
    if(board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
      board[pos.dy.floor()][pos.dx.floor()][0].size = size;
    }
  }

  void setSides(Offset pos, int sides) {
    if (board[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
      board[pos.dy.floor()][pos.dx.floor()][0].sides = sides;
    }
  }

  void moveObj(Offset pos1, Offset pos2) {
    pos1 = Offset(pos1.dx.clamp(0, 7), pos1.dy.clamp(0, 7));
    pos2 = Offset(pos2.dx.clamp(0, 7), pos2.dy.clamp(0, 7));
    if (board[pos1.dy.floor()][pos1.dx.floor()].isNotEmpty && board[pos2.dy.floor()][pos2.dx.floor()].isEmpty) {
     board[pos2.dy.floor()][pos2.dx.floor()] = board[pos1.dy.floor()][pos1.dx.floor()];
     board[pos1.dy.floor()][pos1.dx.floor()] = [];
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
  final _boardKey = GlobalKey();

  LogicBoard mainBoard = LogicBoard();

  late Offset dragStartPos;
  late Offset dragEndPos;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      mainBoard.addObj(LogicObj(id: [''], sides: 3+math.Random().nextInt(3), size: math.Random().nextInt(3)), Offset((details.localPosition.dx/(_boardKey.currentContext!.size!.width/8)).floorToDouble(), (details.localPosition.dy/(_boardKey.currentContext!.size!.width/8)).floorToDouble()));
    });
  }

  void _onPanStart(DragStartDetails details) {
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
                width: constraints.maxWidth ,
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}