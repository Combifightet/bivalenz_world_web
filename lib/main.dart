import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: DraggableCircleDemo()
        ),
      ),
    );
  }
}


// class CircleWidget extends StatefulWidget {
//   const CircleWidget({super.key});

//   @override
//   CircleWidgetState createState() => CircleWidgetState();
// }

// class CircleWidgetState extends State<CircleWidget> {
//   Offset position = const Offset(0, 0);
//   final double gridSize = 50;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         setState(() {
//           double dx = position.dx + details.delta.dx;
//           double dy = position.dy + details.delta.dy;
//           // snap to grid
//           // position = Offset(dx, dy);
//           position = Offset((dx / gridSize).round() * gridSize, (dy / gridSize).round() * gridSize);
          
//         });
//       },
//       child: Stack(
//         children: [
//           Positioned(
//             left: position.dx,
//             top: position.dy,
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class DraggableCircle extends StatefulWidget {
  const DraggableCircle({super.key});

  @override
  DraggableCircleState createState() => DraggableCircleState();
}

class DraggableCircleState extends State<DraggableCircle> {
  double _left = 10;
  double _top = 10;
  final double _radius = 40.0;

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      _left += details.delta.dx;
      _top += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _left = (_left / 100.0).round().clamp(0, 7) * 100.0 + 10;
      _top = (_top / 100.0).round().clamp(0, 7) * 100.0 + 10;
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
        child: Container(
          width: _radius * 2,
          height: _radius * 2,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class DraggableCircleDemo extends StatelessWidget {
  const DraggableCircleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800.0,
          height: 800.0,
          color: Colors.lightGreenAccent.withOpacity(0.5),
          child: Stack(
            children: const [
              Image(
                image: AssetImage('8x8_grid.png'),
                height: 800,
                width: 800,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
              DraggableCircle(),
            ],
          ),
        ),
      ),
    );
  }
}
