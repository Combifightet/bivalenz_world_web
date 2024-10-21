import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'theme.dart';


class PredicateButtons extends StatefulWidget {
  const PredicateButtons({super.key});

  @override
  State<PredicateButtons> createState() => _PredicateButtonsState();
}

class _PredicateButtonsState extends State<PredicateButtons> {
  double uiScale = 1;

  final List<List<String>> strings = [
    ['Tet','Cube','Dodec','SameShape',],
    ['Small','Medium','Large','SameSize',],
    ['LeftOf','RightOf','FrontOf','BackOf',],
    ['SameRow','SameCol','Between','Adjoins',],
    ['','Smaller','Larger','',],
  ];
  final List<List<String>> tooltips = [
    ['Tet(a)','Cube(a)','Dodec(a)','SameShape(a, b)',],
    ['Small(a)','Medium(a)','Large(a)','SameSize(a, b)',],
    ['LeftOf(a, b)','RightOf(a, b)','FrontOf(a, b)','BackOf(a, b)',],
    ['SameRow(a, b)','SameCol(a, b)','Between(a, b, c)','Adjoins(a, b)',],
    ['','Smaller(a, b)','Larger(a, b)','',],
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = min(constraints.maxHeight/2, constraints.maxWidth/3)/109;
        
        List<Widget> rows = [];

        for (int i=0; i<strings.length; i++) {
          List<Widget> currentRow = [];
          for (int j=0; j<strings[i].length; j++){
            if (strings[i][j].isEmpty) {
              currentRow.add(Expanded(child: SizedBox()));
            } else {
              currentRow.add(
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(uiScale),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (activeController!=null) {
                            int offset = min(activeController!.selection.baseOffset, activeController!.selection.extentOffset)+strings[i][j].length+1;
                            activeController!.text = '${activeController!.selection.textBefore(activeController!.text)}${strings[i][j]}()${activeController!.selection.textAfter(activeController!.text)}';
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
                        strings[i][j],
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
          }
          rows.add(
            Expanded(
              child: Row(
                children: currentRow,
              ),
            )
          );
        }

        return Column(
          children: rows,
        );
      }
    );
  }
}