import 'dart:math';

import 'package:flutter/material.dart';
import 'object_handeling.dart';
import 'option_buttons.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: backgroundColor,
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
    double logicTextSize = width*0.4;
    double topBarSize = (2*60)+(2*10)-25;
    double squareSize = (width-logicTextSize<height-topBarSize?width-logicTextSize:height-topBarSize).clamp(80, 80000);

    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          // First row
          SizedBox(
            height: topBarSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 40,
                  color: Colors.red,
                ),
                SizedBox(
                  width: width - logicTextSize - 40,
                  // color: Colors.green,
                  child: Center(
                    child: Container(
                      width: min(width - logicTextSize - 40, topBarSize*3),
                      height: topBarSize,
                      color: cyanAccentColor,
                      child: const OptionButtons(),
                    ),
                  ),
                ),
                Container(
                  width: logicTextSize,
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
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                    color: backgroundAccentColor,
                    child: Center(
                      child: SizedBox(width: squareSize-20, height: squareSize-20, child: const BoardRenderer()),
                    ),
                  ),
                ),
                Container(
                    width: logicTextSize,
                    color: Colors.yellow,
                  ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
