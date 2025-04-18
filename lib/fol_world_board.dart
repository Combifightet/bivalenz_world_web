import 'package:logic_expr_tree/logic_expr_tree.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'theme.dart';

Offset? cursorLocation;

class FolWorldBoard extends StatefulWidget {
  final double uiScale;

  const FolWorldBoard({
    super.key,
    this.uiScale=1,
  });

  @override
  State<FolWorldBoard> createState() => _FolWorldBoardState();
}

class _FolWorldBoardState extends State<FolWorldBoard> {
  late double canvasSize;
  double uiScale = 1;

  void rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        canvasSize = min(constraints.maxWidth, constraints.maxHeight);
        uiScale = canvasSize/520;
        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              CustomPaint(
                painter: BoardPainter(
                  world: folWorlds[folWorldIndex],
                  canvasSize: canvasSize,
                  lightTheme: Theme.of(context).brightness==Brightness.light,
                  textColor: Theme.of(context).elevatedButtonTheme.style!.foregroundColor!.resolve({WidgetState.selected})!,
                ),
                size: Size(canvasSize, canvasSize),
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
    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), (folWorldSize-1)-newSelection.dy.floorToDouble());
    if (selectedTile==null || (newSelection.distanceSquared-selectedTile!.distanceSquared).abs()!=0) {
      selectedTile = newSelection;
    } else {
      selectedTile = null;
    }
    objecButtonsKey.currentState?.refresh();
    folScentenceKey.currentState?.validateAll();
    setState(() {});    // To force repaint
    print('selectedTile: $selectedTile');
  }

  void _onPanStart(DragStartDetails details) {
    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), (folWorldSize-1)-newSelection.dy.floorToDouble());
    selectedTile = newSelection;
    
    cursorLocation = details.localPosition/canvasSize*(folWorldSize*1);
    cursorLocation = Offset(cursorLocation!.dx, (folWorldSize)-cursorLocation!.dy);
    objecButtonsKey.currentState?.refresh();
    setState(() {});    // To force repaint
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorLocation = details.localPosition/canvasSize*(folWorldSize*1);
    cursorLocation = Offset(cursorLocation!.dx, (folWorldSize)-cursorLocation!.dy);
    setState(() {});    // To force repaint
  }

  void _onPanEnd(DragEndDetails details) {
    Offset newSelection = details.localPosition/canvasSize*(folWorldSize*1);
    newSelection = Offset(newSelection.dx.floorToDouble(), (folWorldSize-1)-newSelection.dy.floorToDouble());
    if (newSelection.dx.floor()<0||newSelection.dx.floor()>=folWorldSize || newSelection.dy.floor()<0||newSelection.dy.floor()>=folWorldSize) {
      folWorlds[folWorldIndex].clear(selectedTile!.dx.floor(), selectedTile!.dy.floor());
    }
    if (folWorlds[folWorldIndex].move(selectedTile!.dx.floor(), selectedTile!.dy.floor(), newSelection.dx.floor(), newSelection.dy.floor())) {
      selectedTile = newSelection;
    }
    cursorLocation = null;
    objecButtonsKey.currentState?.refresh();
    folScentenceKey.currentState?.validateAll();
    setState(() {});
  }
}

class BoardPainter extends CustomPainter {
  final FolWorld world;
  final double canvasSize;
  final bool lightTheme;
  final Color textColor;

  BoardPainter({
    required this.world,
    required this.canvasSize,
    this.lightTheme=true,
    this.textColor=Colors.black,
  });

  late double width;
  late double uiScale;


  Path drawPoly(int sides, Offset pos, ObjectSize size) {
    final double centerX = width*pos.dx + width/2;
    final double centerY = width*((folWorldSize-1)-pos.dy) + width/2 + (sides==3?4:sides==5?2:0*uiScale*8/folWorldSize);
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
    uiScale = canvasSize/520;
    // drawing background tiles
    canvas.drawRect(
      Rect.fromPoints(
        Offset.zero,
        Offset(canvasSize, canvasSize)
      ),
      Paint()
        ..color = lightTheme
          ? invertBoard?boardLightLightColor:boardLightDarkColor
          : invertBoard?boardDarkLightColor:boardDarkDarkColor
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
            ..color = lightTheme
              ? invertBoard?boardLightDarkColor:boardLightLightColor
              : invertBoard?boardDarkDarkColor:boardDarkLightColor
            ..style = PaintingStyle.fill,
        );
      }
    }
    // highliht selected field if it exists
    if (selectedTile!=null &&
        selectedTile!.dx>=0&&selectedTile!.dx<folWorldSize &&
        selectedTile!.dy>=0&&selectedTile!.dy<folWorldSize) {
      canvas.drawRect(
      Rect.fromCircle(
        center: Offset(width*selectedTile!.dx.floor()+width/2, width*((folWorldSize-1)-selectedTile!.dy.floor())+width/2),
        radius: width/2,
      ),
      Paint()
        ..color = greenAccentColor.withAlpha(127)
        ..style = PaintingStyle.fill,
      );
    }
    // paint objects
    for (LogicObj obj in folWorlds[folWorldIndex].getWorld()) {
      double objX = cursorLocation!=null&&selectedTile!=null&&(((selectedTile!.dx-obj.getX()*1).abs()+(selectedTile!.dy-obj.getY()*1).abs())<0.001)?cursorLocation!.dx-.5:obj.getX()*1;
      double objY = cursorLocation!=null&&selectedTile!=null&&(((selectedTile!.dx-obj.getX()*1).abs()+(selectedTile!.dy-obj.getY()*1).abs())<0.001)?cursorLocation!.dy-.5:obj.getY()*1;
        canvas.drawPath(
          drawPoly(
            obj.type.sides(),
            Offset(objX*1, objY*1),
            obj.size,
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
        String constsString = obj.getConsts().toString();
        constsString = constsString.substring(1, constsString.length-1);
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: constsString,
            style: TextStyle(
              fontSize: 14*uiScale*8/folWorldSize,
              fontWeight: FontWeight.bold,
              color: textColor
            )
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
        )..layout(maxWidth: size.width/folWorldSize-12*uiScale);
        textPainter.paint(
          canvas,
          Offset(
            width*objX + width*0.5 - textPainter.width*0.5,
            width*((folWorldSize-1)-objY) + width*0.8
          )
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}