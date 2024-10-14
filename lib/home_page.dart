import 'package:bivalenz_world_web/fol_world_board.dart';
import 'package:bivalenz_world_web/object_buttons.dart';
import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';

import 'rotate_export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    List<Widget> boxes = [];
    for (int i=0; i<11*17; i++) {
      boxes.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.3))
        ),
      ));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: backgroundAccentColor,
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: RotateExport(),
                  ),
                  const Expanded(
                    flex: 10,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 17/6,
                        child: ObjectButtons()
                      )
                    )
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
                                child: Container(color: Colors.blue)
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(color: Colors.blueGrey)
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(color: Colors.deepPurple),
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
                const Expanded(
                  flex: 11,
                  // child: Padding(
                    // padding: EdgeInsets.all(8*uiScale),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FolWorldBoard()
                      ),
                    ),
                  // )
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: backgroundAccentColor,
                    child: Container(color: Colors.cyan),
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}