import 'package:logic_expr_tree/logic_expr_tree.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'theme.dart';

Offset? cursorLocation;

class FolWorldBoard extends StatefulWidget {
  const FolWorldBoard({super.key});

  @override
  State<FolWorldBoard> createState() => _FolWorldBoardState();
}

class _FolWorldBoardState extends State<FolWorldBoard> {
  late double canvasSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        canvasSize = min(constraints.maxWidth, constraints.maxHeight);
        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              CustomPaint(
                painter: BoardPainter(
                  world: folWorlds[folWorldIndex],
                  canvasSize: canvasSize
                ),
              ),
              GestureDetector(
                onTapDown: _onTapDown,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
              )
            ],
          ),
        );
      },
    );
  }

  void _onTapDown(TapDownDetails details) {
    print('_onTapDown');
    List<String> chars = ['a','b','c','d','e','f','g','h','i','j','k','l','m'];
    chars.shuffle();
    folWorlds[folWorldIndex].createObj(
      Random().nextInt(folWorldSize),
      Random().nextInt(folWorldSize),
      ObjectType.values[Random().nextInt(3)],
      ObjectSize.values[Random().nextInt(3)],
      chars.sublist(Random().nextInt(7)).sublist(Random().nextInt(6))
    );

    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), newSelection.dy.floorToDouble());
    if (selectedTile==null || (newSelection.distanceSquared-selectedTile!.distanceSquared).abs()!=0) {
      selectedTile = newSelection;
    } else {
      selectedTile = null;
    }

    setState(() {});    // To force repaint
  }

  void _onPanStart(DragStartDetails details) {
    print('_onPanStart');
    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), newSelection.dy.floorToDouble());
    selectedTile = newSelection;
    
    cursorLocation = details.localPosition/canvasSize*(folWorldSize*1);
    setState(() {});    // To force repaint
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // print('_onPanUpdate');
    cursorLocation = details.localPosition/canvasSize*(folWorldSize*1);
    setState(() {});    // To force repaint
  }

  void _onPanEnd(DragEndDetails details) {
    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), newSelection.dy.floorToDouble());
    if (folWorlds[folWorldIndex].move(selectedTile!.dx.floor(), selectedTile!.dy.floor(), newSelection.dx.floor(), newSelection.dy.floor())) {
      selectedTile = newSelection;
    }
    cursorLocation = null;
    setState(() {});
  }
}

class BoardPainter extends CustomPainter {
  final FolWorld world;
  final double canvasSize;

  BoardPainter({
    required this.world,
    required this.canvasSize,
  });

  late double width;


  Path drawPoly(int sides, Offset pos, ObjectSize size) {
    final double centerX = width*pos.dx + width/2;
    final double centerY = width*pos.dy + width/2 + (sides==3?4:sides==5?2:0*uiScale);  // TODO: scale addition by some factor
    final double angle = (pi*2)/sides;
    final Path polygonPath = Path();
    final double radius = width/7 * (size.index+1);

    for (int i = 0; i < sides; i++) {
      final double x = centerX + radius * cos(angle*i - (sides%2==0?pi/sides:pi/2));
      final double y = centerY + radius * sin(angle*i - (sides%2==0?pi/sides:pi/2));

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
    width = canvasSize/folWorldSize;
    // drawing background tiles
    canvas.drawRect(
      Rect.fromPoints(
        Offset.zero,
        Offset(canvasSize, canvasSize)
      ),
      Paint()
        ..color = invertBoard?boardLightColor:boardDarkColor
        ..style = PaintingStyle.fill,
    );
    for (int y=0; y<folWorldSize; y++) {
      for (int x=y%2; x<folWorldSize; x+=2) {
        canvas.drawRect(
          Rect.fromCircle(
            center: Offset(width*x+width/2, width*y+width/2),
            radius: width/2,
          ),
          Paint()
            ..color = invertBoard?boardDarkColor:boardLightColor
            ..style = PaintingStyle.fill,
        );
      }
    }
    // highliht selected field if it exists
    if (selectedTile!=null &&
        selectedTile!.dx>=0&&selectedTile!.dx<canvasSize &&
        selectedTile!.dy>=0&&selectedTile!.dy<canvasSize) {
      canvas.drawRect(
      Rect.fromCircle(
        center: Offset(width*selectedTile!.dx.floor()+width/2, width*selectedTile!.dy.floor()+width/2),
        radius: width/2,
      ),
      Paint()
        ..color = greenAccentColor.withOpacity(0.5)
        ..style = PaintingStyle.fill,
      );
    }
    // paint objects
    for (LogicObj obj in folWorlds[folWorldIndex].getWorld()) {
      // if (curerntlyDragging) {
        canvas.drawPath(
          drawPoly(
            obj.type.sides(),
            Offset(obj.getX()*1, obj.getY()*1),
            obj.size
          ),
          Paint()
          ..color = obj.type==ObjectType.Tet
            ? redAccentColor
            : obj.type==ObjectType.Cube
              ? blueAccentColor
              : obj.type==ObjectType.Dodec
                ? yellowAccentColor
                : const Color(0xffff00ff)
          ..style = PaintingStyle.fill
        );
      // } else {
      // }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
