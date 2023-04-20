import 'package:flutter/material.dart';
import 'dart:math' as math;


class DraggableObjekt extends StatefulWidget {
  const DraggableObjekt({
    super.key,
    required this.id,         //  a / b / c / d / e / f
    required this.position,   //  1-8 / 1-8
    required this.gridSize,   // in px
    this.size = 1,            //  small / medium / big / ...             (0/1/2)
    this.type = 1,            //  Triangle / Square / Pentagon / ...     (0/1/2)
    this.color = Colors.blue,
  });

  final int id;
  final Offset position;
  final int gridSize;
  final int size;
  final int type;
  final Color color;

  @override
  DraggableObjektState createState() => DraggableObjektState();
}

class DraggableObjektState extends State<DraggableObjekt> {
  double _left = -1000;
  double _top =-1000;

  @override
  void initState() {
    super.initState();
    setState(() {
    _left =  (widget.position.dx*(widget.gridSize/8));
    _top =  widget.position.dy*(widget.gridSize/8);
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
      _left = (_left / 100.0).round().clamp(0, 7) * 100.0;
      _top = (_top / 100.0).round().clamp(0, 7) * 100.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanUpdate: _onDrag,
        onPanEnd: _onDragEnd,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: CustomPaint(
              painter: PolygonPainter(
                sides: widget.type+3,
                radius: widget.size*10+20,
                polygonPaint: Paint()
                  ..color = widget.color
                  ..strokeWidth = 2.0
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
  const DraggableObjektDemo(
    {super.key}
    
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800.0,
          height: 800.0,
          child: Stack(
            children: const [
              Image(
                image: AssetImage('8x8_grid.png'),
                height: 800,
                width: 800,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
              DraggableObjekt(id: 1, position: Offset(1, 1), gridSize: 800, size:1, type: 0, color: Colors.red),
              DraggableObjekt(id: 1, position: Offset(2, 1), gridSize: 800, size:2, type: 0, color: Colors.red),
              DraggableObjekt(id: 1, position: Offset(3, 1), gridSize: 800, size:3, type: 0, color: Colors.red),
              DraggableObjekt(id: 1, position: Offset(1, 2), gridSize: 800, size:1, type: 1, color: Colors.green),
              DraggableObjekt(id: 1, position: Offset(2, 2), gridSize: 800, size:2, type: 1, color: Colors.green),
              DraggableObjekt(id: 1, position: Offset(3, 2), gridSize: 800, size:3, type: 1, color: Colors.green),
              DraggableObjekt(id: 1, position: Offset(1, 3), gridSize: 800, size:1, type: 2, color: Colors.blue),
              DraggableObjekt(id: 1, position: Offset(2, 3), gridSize: 800, size:2, type: 2, color: Colors.blue),
              DraggableObjekt(id: 1, position: Offset(3, 3), gridSize: 800, size:3, type: 2, color: Colors.blue),
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
      final double x = centerX + radius * math.cos(angle * i - (sides%2==0?math.pi/4:math.pi/2));
      final double y = centerY + radius * math.sin(angle * i - (sides%2==0?math.pi/4:math.pi/2));

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