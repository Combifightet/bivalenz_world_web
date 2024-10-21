import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'theme.dart';


class FunctionButtons extends StatefulWidget {
  const FunctionButtons({super.key});

  @override
  State<FunctionButtons> createState() => _FunctionButtonsState();
}

class _FunctionButtonsState extends State<FunctionButtons> {
  double uiScale = 1;

  final List<String> strings = ['rm','lm','fm','bm'];
  final List<String> tooltips = ['rightmost','leftmost','frontmost','backmost'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = min(constraints.maxHeight, constraints.maxWidth/11)/28;
        
        List<Widget> row = [];

        for (int i=0; i<strings.length; i++) {
        row.add(
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(uiScale),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (activeController!=null) {
                      int offset = min(activeController!.selection.baseOffset, activeController!.selection.extentOffset)+strings[i].length+1;
                      activeController!.text = '${activeController!.selection.textBefore(activeController!.text)}${strings[i]}()${activeController!.selection.textAfter(activeController!.text)}';
                      activeController!.selection = TextSelection(
                        baseOffset: offset,
                        extentOffset: offset
                      );
                      // TODO: fix one frame long flicker ???
                      Future.microtask(() {
                        activeTextField!.requestFocus();
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          activeController!.selection = TextSelection(
                            baseOffset: offset,
                            extentOffset: offset
                          );
                        });
                      });
                    }
                  });
                },
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5*uiScale),
                    )
                  ),
                ),
                child: Text(
                  strings[i],
                  style: TextStyle(
                    fontSize: 16*uiScale,
                    fontWeight: FontWeight.bold
                  ),
                )
              )
            ),
          )
        );
        }

        return Row(
          children: row,
        );
      }
    );
  }
}