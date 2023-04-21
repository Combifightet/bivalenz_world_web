import 'package:flutter/material.dart';
import 'object_handeling.dart';

// import 'grid_snap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: TwoRowsWidget(),
        // body: DraggableObjektDemo(scale: 400),
      ),
    );
  }
}

class TwoRowsWidget extends StatelessWidget {
  const TwoRowsWidget({super.key});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double squareSize = (width-200<height-150?width-200:height-150).clamp(80, 80000);

    return Column(
      children: [
        // First row
        Container(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.red,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.green,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        // Second row
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(right: (width-200-squareSize)/2),
                // child: SizedBox(width: squareSize, height: squareSize, child: DraggableObjektDemo(scale: squareSize),)
                child:SizedBox(width: squareSize, height: squareSize, child: const BoardRenderer()),
              ),
              Container(
                  width: 200,
                  color: Colors.yellow,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
