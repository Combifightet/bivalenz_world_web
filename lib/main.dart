import 'package:flutter/material.dart';
import 'dart:math';

import 'object_handeling.dart';
import 'object_buttons.dart';
import 'logic_handeling.dart';
import 'logic_buttons.dart';
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

class TwoRowsWidget extends StatefulWidget {
  const TwoRowsWidget({super.key});
  
  @override
  State<StatefulWidget> createState() => TwoRowsWidgetState();
}

class TwoRowsWidgetState extends State<TwoRowsWidget> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double logicTextSize = width*0.4;
    double topBarSize = (2*60)+(2*10)-25;
    double squareSize = (width-logicTextSize<height-topBarSize?width-logicTextSize:height-topBarSize).abs().clamp(160, 80000);

    return SingleChildScrollView(
      controller: ScrollController(),
      child:  Container(
      height: topBarSize + (height-topBarSize).abs().clamp(160, double.infinity),
      color: backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: topBarSize,
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Tooltip(
                                  message: 'import / export',
                                  waitDuration: const Duration(seconds: 1),
                                  child: TextButton(
                                    style: squareButtonStyle,
                                    onPressed: () {
                                      setState(() {
                                        
                                      });
                                    },
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Icon(Icons.menu_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Tooltip(
                                  message: 'rotate board counter clockwise',
                                  waitDuration: const Duration(seconds: 1),
                                  child: TextButton(
                                    style: squareButtonStyle,
                                    onPressed: () {
                                      setState(() {
                                        mainBoard.rotateCCW();
                                      });
                                    },
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Icon(Icons.rotate_90_degrees_ccw_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Tooltip(
                                  message: 'rotate board clockwise',
                                  waitDuration: const Duration(seconds: 1),
                                  child: TextButton(
                                    style: squareButtonStyle,
                                    onPressed: () {
                                      setState(() {
                                        mainBoard.rotateCW();
                                      });
                                    },
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Icon(Icons.rotate_90_degrees_cw_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width - logicTextSize - 40,
                        child: Center(
                          child: SizedBox(
                            width: min(width - logicTextSize - 40, topBarSize*3),
                            height: topBarSize,
                           // color: cyanAccentColor,
                            child: const OptionButtons(),
                          ),
                        ),
                      ),
                    ]
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: backgroundAccentColor,
                      child: Center(
                        child: SizedBox(
                          width: squareSize-20,
                          height: squareSize-20,
                          child: const BoardRenderer()),
                      ),
                    ),
                  ),
                ],
              )
            ),
            SizedBox(
              width: logicTextSize,
              child: Column(
                children: [
                  Container(
                    height: topBarSize,
                    // color: Colors.blue.withOpacity(.1),
                    child: const LogicButtons()
                  ),
                  const Expanded(child: Center(child: LogicObjList()),)
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
