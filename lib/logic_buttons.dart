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
                                LogicButton(padding: padding, text: '∨', tooltip: 'Disjunction'),
                                LogicButton(padding: padding, text: '∧', tooltip: 'Conjunction'),
                                LogicButton(padding: padding, text: '¬', tooltip: 'Negation'),
                                LogicButton(padding: padding, text: '→', tooltip: 'Implication'),
                                LogicButton(padding: padding, text: '↔', tooltip: 'Equivalence'),
                                LogicButton(padding: padding, text: '⊥', tooltip: 'Falsum')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'a', tooltip: 'Individual Constant'),
                                LogicButton(padding: padding, text: 'b', tooltip: 'Individual Constant'),
                                LogicButton(padding: padding, text: 'c', tooltip: 'Individual Constant'),
                                LogicButton(padding: padding, text: 'd', tooltip: 'Individual Constant'),
                                LogicButton(padding: padding, text: 'e', tooltip: 'Individual Constant'),
                                LogicButton(padding: padding, text: 'f', tooltip: 'Individual Constant')
                              ]
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: '∀', tooltip: 'All Quantifier'),
                                LogicButton(padding: padding, text: '∃', tooltip: 'Existential Quantifier'),
                                LogicButton(padding: padding, text: '=', tooltip: 'Equality'),
                                LogicButton(padding: padding, text: '≠', tooltip: 'Inequality'),
                                LogicButton(padding: padding, text: '(', tooltip: 'Bracket'),
                                LogicButton(padding: padding, text: ')', tooltip: 'Bracket')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'x', tooltip: 'Variable'),
                                LogicButton(padding: padding, text: 'y', tooltip: 'Variable'),
                                LogicButton(padding: padding, text: 'z', tooltip: 'Variable'),
                                LogicButton(padding: padding, text: 'u', tooltip: 'Variable'),
                                LogicButton(padding: padding, text: 'v', tooltip: 'Variable'),
                                LogicButton(padding: padding, text: 'w', tooltip: 'Variable')
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
                                LogicButton(padding: padding, text: 'Tet', tooltip: 'Tet(a)'),
                                LogicButton(padding: padding, text: 'Cube', tooltip: 'Cube(a)'),
                                LogicButton(padding: padding, text: 'Dodec', tooltip: 'Dodec(a)'),
                                LogicButton(padding: padding, text: 'SameShape', tooltip: 'SameShape(a, b)')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'Small', tooltip: 'Small(a)'),
                                LogicButton(padding: padding, text: 'Medium', tooltip: 'Medium(a)'),
                                LogicButton(padding: padding, text: 'Large', tooltip: 'Large(a)'),
                                LogicButton(padding: padding, text: 'SameSize', tooltip: 'SameSize(a, b)')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'LeftOf', tooltip: 'LeftOf(a, b)'),
                                LogicButton(padding: padding, text: 'RightOf', tooltip: 'RightOf(a, b)'),
                                LogicButton(padding: padding, text: 'FrontOf', tooltip: 'FrontOf(a, b)'),
                                LogicButton(padding: padding, text: 'BackOf', tooltip: 'BackOf(a, b)')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogicButton(padding: padding, text: 'SameRow', tooltip: 'SameRow(a, b)'),
                                LogicButton(padding: padding, text: 'SameCol', tooltip: 'SameCol(a, b)'),
                                LogicButton(padding: padding, text: 'Between', tooltip: 'Between(a, b, c)'),
                                LogicButton(padding: padding, text: 'Adjoins', tooltip: 'Adjoins(a, b)')
                              ]
                            )
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                LogicButton(padding: padding, text: 'Smaller', tooltip: 'Smaller(a, b)'),
                                LogicButton(padding: padding, text: 'Larger', tooltip: 'Larger(a, b)'),
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
                  LogicButton(padding: padding, text: 'lm', tooltip: 'leftmost lm(a)'),
                  LogicButton(padding: padding, text: 'rm', tooltip: 'rightmost rm(a)'),
                  LogicButton(padding: padding, text: 'fm', tooltip: 'bottommost fm(a)'),
                  LogicButton(padding: padding, text: 'bm', tooltip: 'topmost bm(a)'),
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