import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'theme.dart';


class OperatorButtons extends StatefulWidget {
  const OperatorButtons({super.key});

  @override
  State<OperatorButtons> createState() => _OperatorButtonsState();
}

class _OperatorButtonsState extends State<OperatorButtons> {
  double uiScale = 1;
  final List<List<String>> strings = [
    ['∧','∨','¬','→','↔','⊥',],
    ['a','b','c','d','e','f',],
    ['∀','∃','=','≠','(',')',],
    ['x','y','z','u','v','w',],
  ];
  final List<List<String>> tooltips = [
    ['discunction','conjunction','negation','implication','biimplication','contradiction',],
    ['constant a','constant b','constant c','constant d','constant e','constant f',],
    ['universal quantification','existential  quantification','equal','not equal','bracket open','bracket close',],
    ['variable x','variable y','variable z','variable u','variable v','variable w',],
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = min(constraints.maxHeight/4, constraints.maxWidth/6)/27;
        
        List<Widget> rows = [];

        for (int i=0; i<strings.length; i++) {
          List<Widget> currentRow = [];
          for (int j=0; j<strings[i].length; j++){
            currentRow.add(
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(uiScale),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (activeController!=null) {
                          int offset = min(activeController!.selection.baseOffset, activeController!.selection.extentOffset)+strings[i][j].length;
                          activeController!.text = activeController!.selection.textBefore(activeController!.text)+strings[i][j]+activeController!.selection.textAfter(activeController!.text);
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
                      folScentenceKey.currentState?.validate(folSentences[folSentenceIndex].indexWhere((s) => s.controller==activeController));
                      folScentenceKey.currentState?.refresh();
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
                      maxLines: 1,
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