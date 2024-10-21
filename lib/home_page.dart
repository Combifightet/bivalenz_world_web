import 'dart:math';

import 'package:bivalenz_world_web/fol_world_board.dart';
import 'package:bivalenz_world_web/function_buttons.dart';
import 'package:bivalenz_world_web/logic_sentences.dart';
import 'package:bivalenz_world_web/object_buttons.dart';
import 'package:bivalenz_world_web/operator_buttons.dart';
import 'package:bivalenz_world_web/predicate_buttons.dart';
import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';

import 'rotate_export.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double uiScale = 1;

  @override
  Widget build(BuildContext context) {

    List<Widget> boxes = [];
    for (int i=0; i<11*17; i++) {
      boxes.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withAlpha(77))
        ),
      ));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          uiScale = min(constraints.maxHeight, constraints.maxWidth/10*9)/820;
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: backgroundAccentColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 11,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(6*uiScale),
                              child: AspectRatio(
                                aspectRatio:  1/3,
                                // child: Expanded(
                                  child: RotateExport(),
                                // ),
                              ),
                            ),
                            Expanded(
                              // flex: 10,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 24*uiScale, 
                                    horizontal: 4*uiScale
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 6/2,
                                    child: ObjectButtons(
                                      uiScale: uiScale,
                                    )
                                  ),
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10*uiScale, horizontal: 6*uiScale),
                                      child: OperatorButtons(),
                                    )
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.all(6*uiScale),
                                      child: PredicateButtons(),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8*uiScale, horizontal: 18*uiScale),
                                child: FunctionButtons(),
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                      flex: 11,
                      // child: Padding(
                        // padding: EdgeInsets.all(8*uiScale),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8*uiScale),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: FolWorldBoard(
                                uiScale: uiScale,
                              )
                            ),
                          ),
                        ),
                      // )
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: backgroundAccentColor,
                        child: LogicSentences(),
                      )
                    )
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}