import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:math' as math;


class DraggableObjekt extends StatefulWidget {
  const DraggableObjekt({
    super.key,
    required this.id,         //  a / b / c / d / e
    required this.position,   //  1-8 / 1-8
    required this.gridSize,   // in px
    this.size = 1,            //  small / medium / big / ...             (0/1/2)
    this.type = 1,            //  Triangle / Square / Pentagon / ...     (0/1/2)
  });

  final int id;
  final Offset position;
  final double gridSize;
  final int size;
  final int type;

  @override
  DraggableObjektState createState() => DraggableObjektState();
}

class DraggableObjektState extends State<DraggableObjekt> {
  late double _left;
  late double _top;
  late double _scale;
  

  @override
  void initState() {
    super.initState();
    setState(() {
    _left =  (widget.position.dx*(widget.gridSize/8));
    _top =  widget.position.dy*(widget.gridSize/8) + (widget.type==0?7:widget.type==2?3:0);
    _scale = widget.gridSize/800;
    });
  }

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      _left += details.delta.dx;
      _top += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _left = (_left / (100*_scale)).round().clamp(0, 7) * 100*_scale;
      _top = (_top / (100*_scale)).round().clamp(0, 7) * 100*_scale + (widget.type==0?7:widget.type==2?3:0);
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _scale = (width-200<height-150?width-200:height-150).clamp(80, 80000)/800;

    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanUpdate: _onDrag,
        onPanEnd: _onDragEnd,
        child: SizedBox(
          width: 100*_scale,
          height: 100*_scale,
          child: Center(
            child: CustomPaint(
              painter: PolygonPainter(
                sides: widget.type+3,
                radius: (widget.size+1)*15*_scale,
                polygonPaint: Paint()
                  ..color = widget.type==0?redAccentColor:widget.type==1?blueAccentColor:widget.type==2?yellowAccentColor:Colors.blueGrey
                  ..style = PaintingStyle.fill,
              ),
              child: Container(),
            )
          )
        )
      ),
    );
  }
}

class DraggableObjektDemo extends StatelessWidget {
  const DraggableObjektDemo({
    super.key, 
    required this.scale,
  });
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: scale,
          height: scale,
          child: Stack(
            children: [
              const Image(
                image: AssetImage('8x8_grid.png'),
                height: 800,
                width: 800,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
              DraggableObjekt(id: 1, position: const Offset(-1, -1), gridSize: scale, size:1, type: 1),
              DraggableObjekt(id: 1, position: const Offset(-1, -1), gridSize: scale, size:1, type: 1),
              DraggableObjekt(id: 1, position: const Offset(-1, -1), gridSize: scale, size:1, type: 1),
              DraggableObjekt(id: 1, position: const Offset(-1, -1), gridSize: scale, size:1, type: 1),
              DraggableObjekt(id: 1, position: const Offset(-1, -1), gridSize: scale, size:1, type: 1),
              DraggableObjekt(id: 1, position: const Offset(-0, -0), gridSize: scale, size:1, type: 1),

            ],
          ),
        ),
      ),
    );
  }
}




class PolygonPainter extends CustomPainter {
  final int sides;
  final double radius;
  final Paint polygonPaint;

  PolygonPainter({required this.sides, required this.radius, required this.polygonPaint});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
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
    canvas.drawPath(polygonPath, polygonPaint);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) {
    return sides != oldDelegate.sides ||
           radius != oldDelegate.radius ||
           polygonPaint != oldDelegate.polygonPaint;
  }
}