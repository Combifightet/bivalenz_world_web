import 'package:flutter/material.dart';

import 'logic_handeling.dart';
import 'theme.dart';


//  ∨  ∧  ¬  →  ↔  ⊥
//  a  b  c  d  e  f
//  ∀  ∃  =  ≠  (  )
//  x  y  z  u  v  w

//  Tet      Cube     Dodec    SameShape
//  Small    Medium   Large    SameSize
//  LeftOf   RightOf  FrontOf  BackOf
//  SameRow  SameCol  Between  Adjoins
//           Smaller  Larger

//  lm  rm  fm  bm

class LogicButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String? tooltip;
  final String text;
  const LogicButton({
    super.key,
    required this.padding,
    required this.text,
    this.tooltip
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: Tooltip(
          message: tooltip,
          waitDuration: const Duration(seconds: 1),
          child: TextButton(
            style: smallButtonStyle,
            onPressed: () => inputText(text),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(text)
            ),
          ),
        ),
      ),
    );
  }
}

void inputText(String text) {
  print('Button [$text${text.length>1?'()':''}] pressed (cursor offset: ${text.length>1?text.length+1:text.length})');
}

class LogicButtons extends StatefulWidget {
  const LogicButtons({super.key});

  @override
  State<LogicButtons> createState() => LogicButtonsState();
}

class LogicButtonsState extends State<LogicButtons> {

  EdgeInsetsGeometry padding = const EdgeInsets.all(1);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            SizedBox(
              height: 3.25/4*constraints.maxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 2.4/6*constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: '∨', tooltip: ''),
                                LogicButton(padding: padding, text: '∧', tooltip: ''),
                                LogicButton(padding: padding, text: '¬', tooltip: ''),
                                LogicButton(padding: padding, text: '→', tooltip: ''),
                                LogicButton(padding: padding, text: '↔', tooltip: ''),
                                LogicButton(padding: padding, text: '⊥', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'a', tooltip: ''),
                                LogicButton(padding: padding, text: 'b', tooltip: ''),
                                LogicButton(padding: padding, text: 'c', tooltip: ''),
                                LogicButton(padding: padding, text: 'd', tooltip: ''),
                                LogicButton(padding: padding, text: 'e', tooltip: ''),
                                LogicButton(padding: padding, text: 'f', tooltip: '')
                              ]
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: '∀', tooltip: ''),
                                LogicButton(padding: padding, text: '∃', tooltip: ''),
                                LogicButton(padding: padding, text: '=', tooltip: ''),
                                LogicButton(padding: padding, text: '≠', tooltip: ''),
                                LogicButton(padding: padding, text: '(', tooltip: ''),
                                LogicButton(padding: padding, text: ')', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'x', tooltip: ''),
                                LogicButton(padding: padding, text: 'y', tooltip: ''),
                                LogicButton(padding: padding, text: 'z', tooltip: ''),
                                LogicButton(padding: padding, text: 'u', tooltip: ''),
                                LogicButton(padding: padding, text: 'v', tooltip: ''),
                                LogicButton(padding: padding, text: 'w', tooltip: '')
                              ]
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (1-2.4/6)*constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'Tet', tooltip: ''),
                                LogicButton(padding: padding, text: 'Cube', tooltip: ''),
                                LogicButton(padding: padding, text: 'Dodec', tooltip: ''),
                                LogicButton(padding: padding, text: 'SameShape', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'Small', tooltip: ''),
                                LogicButton(padding: padding, text: 'Medium', tooltip: ''),
                                LogicButton(padding: padding, text: 'Large', tooltip: ''),
                                LogicButton(padding: padding, text: 'SameSize', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'LeftOf', tooltip: ''),
                                LogicButton(padding: padding, text: 'RightOf', tooltip: ''),
                                LogicButton(padding: padding, text: 'FrontOf', tooltip: ''),
                                LogicButton(padding: padding, text: 'BackOf', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'SameRow', tooltip: ''),
                                LogicButton(padding: padding, text: 'SameCol', tooltip: ''),
                                LogicButton(padding: padding, text: 'Between', tooltip: ''),
                                LogicButton(padding: padding, text: 'Adjoins', tooltip: '')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                LogicButton(padding: padding, text: 'Smaller', tooltip: ''),
                                LogicButton(padding: padding, text: 'Larger', tooltip: ''),
                                Expanded(child: Container())
                              ]
                            )
                          )
                        ],
                      )
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Container()),
                  LogicButton(padding: padding, text: 'lm', tooltip: ''),
                  LogicButton(padding: padding, text: 'rm', tooltip: ''),
                  LogicButton(padding: padding, text: 'fm', tooltip: ''),
                  LogicButton(padding: padding, text: 'bm', tooltip: ''),
                  Expanded(child: Container())
                ],
              )
            )
          ],
        );
      },
    );
  }
}