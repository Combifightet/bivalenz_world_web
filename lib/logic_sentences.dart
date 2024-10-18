import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';

class LogicSentences extends StatefulWidget {
  const LogicSentences({super.key});

  @override
  State<LogicSentences> createState() => _LogicSentencesState();
}

class _LogicSentencesState extends State<LogicSentences> {
  double uiScale = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = min(constraints.maxHeight/8, constraints.maxWidth/6)/65;

        return Column(
          children: [
            SizedBox(
              height: 64*uiScale,
              child: Padding(
                padding: EdgeInsets.all(8*uiScale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      AspectRatio(
                        aspectRatio: 1,
                        // child: Expanded(
                          child: Container(color: Colors.green),
                        // )
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8*uiScale),
                        child: Container(color: Colors.amber),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      // child: Expanded(
                        child: Container(color: Colors.red),
                      // )
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8*uiScale),
              child: Divider(
                height: 4*uiScale,
                color: backgroundColor
              ),
            ),
            SingleChildScrollView(
              child: Column(
                
              )
            ),
          ],
        );
      }
    );
  }
}