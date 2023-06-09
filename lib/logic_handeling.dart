import 'dart:math';

import 'package:bivalenz_world_web/object_handeling.dart';
import 'package:flutter/material.dart';

import 'logic_checking.dart';
import 'theme.dart';

int currentIndex = 0;

class LogicObj extends StatefulWidget {
  final TextEditingController controller;
  final int index;
  const LogicObj({
    super.key,
    required this.controller,
    required this.index
  });

  @override
  State<LogicObj> createState() => _LogicObjState();
}

String? logicObjEvaluation;

class _LogicObjState extends State<LogicObj> {
  String _logicObjEvaluation = '';
  
  void verifyLogic() {
    setState(() {
      _logicObjEvaluation = checkLogicTxt(widget.controller.value.text, mainBoard.board);
      debugPrint('Result:          $_logicObjEvaluation');
    });
  }
  late int lastTextLength;


  @override
  void initState() {
    super.initState();
    lastTextLength = widget.controller.text.length;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              color: backgroundAccentColor,
              elevation: 5,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Builder(
                  builder: (BuildContext context) {
                    switch (_logicObjEvaluation.substring(0, min(6, _logicObjEvaluation.length))) {
                    // switch (checkLogicTxt('rm(a)', mainBoard)) {
                      case '⊤':
                        return const Tooltip(
                          message: 'truth value \'true\'',
                          waitDuration: Duration(seconds: 1),
                          child: Text('⊤', style: TextStyle(fontWeight: FontWeight.bold, color: greenAccentColor))
                        );
                      case '⊥':
                        return const Tooltip(
                          message: 'truth value \'false\'',
                          waitDuration: Duration(seconds: 1),
                          child: Text('⊥', style: TextStyle(fontWeight: FontWeight.bold, color: redAccentColor))
                        );
                      case 'error0':
                        return const Tooltip(
                          message: 'Failed to parrse \'formmulaBegin\'',
                          waitDuration: Duration(seconds: 1),
                          child: Icon(Icons.star, color: foregroundAccentColor)
                        );
                      case 'error1':
                        return Tooltip(
                          message: 'Function \'${_logicObjEvaluation.substring(min(7, _logicObjEvaluation.length-1), _logicObjEvaluation.length-1)}\' not found in the signature',
                          waitDuration: const Duration(seconds: 1),
                          child: const Icon(Icons.close_rounded, color: foregroundAccentColor)
                        );
                      case 'error2':
                        return const Tooltip(
                          message: 'The constant symbol [a] is not assigned to this world',
                          waitDuration: Duration(seconds: 1),
                          child: Icon(Icons.close_rounded, color: foregroundAccentColor)
                        );
                      case 'error3':
                        return Tooltip(
                          message: 'Predicate \'${_logicObjEvaluation.substring(min(7, _logicObjEvaluation.length-1), _logicObjEvaluation.length-1)}\' not found in the signature',
                          waitDuration: const Duration(seconds: 1),
                          child: const Icon(Icons.close_rounded, color: foregroundAccentColor)
                        );
                      case 'error4':
                        return Tooltip(
                          message: 'Existential quantor \'${_logicObjEvaluation.substring(min(7, _logicObjEvaluation.length-1), _logicObjEvaluation.length-1)}\' found no objects in the world',
                          waitDuration: const Duration(seconds: 1),
                          child: const Icon(Icons.close_rounded, color: foregroundAccentColor)
                        );
                      default:
                      return const Tooltip(
                        message: 'enter a logic statement',
                        waitDuration: Duration(seconds: 1),
                      );
                    }
                  },
                ),
              ),
            )
          )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: backgroundAccentColor,
                hintText: 'Enter a logic statement',
                hintStyle: TextStyle(color: foregroundAccentColor.withOpacity(.5)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: foregroundAccentColor.withOpacity(0.5))) // TODO: Does not yet display the correct color for the underline of the text field
              ),
              style: const TextStyle(
                color: foregroundAccentColor,
              ),
              controller: widget.controller,
              onSubmitted: (event) => verifyLogic(),
              onTapOutside: (event) => verifyLogic(),
              onTap: () => currentIndex = widget.index,
              onChanged: (value) {
                int cursorOffset = widget.controller.selection.baseOffset;
                String formattedInput = value.replaceAll('!', '¬');             // logical not
                cursorOffset -= RegExp('->').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('->', '→');          // logical implication
                cursorOffset -= 2 * RegExp('<->').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('<->', '↔');        // logical equivalence
                cursorOffset -= 1 * RegExp('<→').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('<→', '↔');
                cursorOffset -= RegExp('¬=').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('¬=', '≠');          // not equal
                cursorOffset -= RegExp('¬≠').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('¬≠', '=');          // equal
                cursorOffset -= RegExp('_¬').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('_¬', '⊥');          // contradiction (truth value false)
                cursorOffset -= RegExp('¬⊥').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('¬⊥', '⊤');          // tautology (truth value true)
                cursorOffset -= RegExp('¬⊤').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('¬⊤', '⊥');          // tautology (truth value true)
                formattedInput = formattedInput.replaceAll('|', '∨');           // logical disjunction (or)
                formattedInput = formattedInput.replaceAll('&', '∧');           // logical conjunction (and)
                cursorOffset -= RegExp('_V').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('_V', '∀');          // quantification (for all)
                cursorOffset -= RegExp('_E').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('_E', '∃');          // quantification (there exists)
                
                cursorOffset = cursorOffset.clamp(0, value.length);
                
                if (lastTextLength < widget.controller.text.length) {
                  if (cursorOffset != 0 && formattedInput[cursorOffset-1] == '(') {
                    if (cursorOffset == value.length) {
                      formattedInput = '$formattedInput)';
                    } else {
                      if (formattedInput[cursorOffset] != ')') {
                        formattedInput = '${formattedInput.substring(0, cursorOffset)})${formattedInput.substring(cursorOffset)}';
                      }
                    }
                  }
                }

                widget.controller.value = TextEditingValue(
                  text: formattedInput,
                  selection: TextSelection.collapsed(offset: cursorOffset.clamp(0, value.length)),
                );

                lastTextLength = widget.controller.text.length;
              },
            )
          ),
        ),
      ],
    );
  }
}


class LogicObjList extends StatefulWidget {
  const LogicObjList({super.key});

  @override
  LogicObjListState createState() => LogicObjListState();
}

final List<TextEditingController> logicControllers = [TextEditingController()];
class LogicObjListState extends State<LogicObjList> {

  void verifyLogic(String statement) {
    setState(() {
      debugPrint('Verifying: $statement');
      // logicObjEvaluation = checkLogicTxt(widget.controller.value.text, mainBoard.board);
      logicObjEvaluation = checkLogicTxt(statement, mainBoard.board);
      debugPrint('Result: $logicObjEvaluation');
    });
  }

  void _addItem() {
    setState(() {
      logicControllers.add(TextEditingController());
    });
  }

  void _removeItem(index) {
    setState(() {
      logicControllers.removeAt(index);
      if (logicControllers.isEmpty) {
        _addItem();
      }
    });
  }

  void _clearItems() {
    setState(() {
      logicControllers.clear();
      _addItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: AspectRatio(aspectRatio: 1, child:Tooltip(
                    message: 'verify all logic statements',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {},
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.check_rounded),
                      ),
                    ),
                  ),
                  )
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: _addItem,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.add_rounded),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: AspectRatio(aspectRatio: 1, child: Tooltip(
                    message: 'delete all logic statements',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        _clearItems();
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.delete_forever_outlined),
                      ),
                    ),
                  ),
                  )
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: logicControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(1),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: LogicObj(controller: logicControllers[index], index: index)),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: AspectRatio(aspectRatio: 1,
                          child:Tooltip(
                            message: 'remove this logic statement',
                            waitDuration: const Duration(seconds: 1),
                            child: TextButton(
                              style: squareButtonStyle,
                              onPressed: () {
                                _removeItem(index);
                              },
                              child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Icon(Icons.delete_outline_rounded),
                              ),
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}