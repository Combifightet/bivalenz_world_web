import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'predicate_buttons.dart';
import 'operator_buttons.dart';
import 'function_buttons.dart';
import 'logic_sentences.dart';
import 'fol_world_board.dart';
import 'object_buttons.dart';
import 'rotate_import.dart';

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

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          uiScale = min(constraints.maxHeight, constraints.maxWidth/10*9)/820;
          return Column(
            children: [
              Expanded(
                flex: 3,
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
                                child: RotateImport(),
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
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                      flex: 11,
                        child: Container(
                          color: Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.selected}),
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
                        ),
                    ),
                    Expanded(
                      flex: 6,
                      child: LogicSentences(
                        key: folScentenceKey,
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