import 'package:flutter/material.dart';

import 'theme.dart';

class LogicObj extends StatelessWidget {
  LogicObj({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              color: backgroundAccentColor,
              elevation: 5,
              child: FittedBox(
                fit: BoxFit.contain,
                // child: Text('T', style: TextStyle(fontWeight: FontWeight.bold, color: greenAccentColor)),
                // child: Text('F', style: TextStyle(fontWeight: FontWeight.bold, color: redAccentColor)),
                // child: Icon(Icons.star, color: foregroundAccentColor),
                child: Icon(Icons.close_rounded, color: foregroundAccentColor),
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
                border: UnderlineInputBorder(borderSide: BorderSide(color: foregroundAccentColor.withOpacity(0.5))) // TODO: Does not yet display the correct coler for the underline of the text field
              ),
              style: const TextStyle(
                color: foregroundAccentColor,
              ),
              controller: _controller,
              onChanged: (value) {
                int cursorOffset = _controller.selection.baseOffset;
                String formattedInput = value.replaceAll('!', '¬');             // logical not
                cursorOffset -= RegExp('->').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('->', '→');          // logical implication
                cursorOffset -= 2 * RegExp('<=>').allMatches(formattedInput.substring(0, cursorOffset.clamp(0, value.length))).length;
                formattedInput = formattedInput.replaceAll('<=>', '⇔');        // logical equivalence
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
                
                if (cursorOffset != 0 && formattedInput[cursorOffset-1] == '(') {
                  if (cursorOffset == value.length) {
                    formattedInput = '$formattedInput)';
                  } else {
                    if (formattedInput[cursorOffset] != ')') {
                      formattedInput = '${formattedInput.substring(0, cursorOffset)})${formattedInput.substring(cursorOffset)}';
                    }
                  }
                }

                _controller.value = TextEditingValue(
                  text: formattedInput,
                  selection: TextSelection.collapsed(offset: cursorOffset.clamp(0, value.length)),
                );
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

class LogicObjListState extends State<LogicObjList> {
  final List<LogicObj> logicObjs = [LogicObj(key: UniqueKey())];

  void _addItem() {
    setState(() {
      logicObjs.add(LogicObj(key: UniqueKey()));
    });
  }

  void _removeItem(index) {
    setState(() {
      logicObjs.removeAt(index);
    });
  }

  void _clearItems() {
    setState(() {
      logicObjs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: 50,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: AspectRatio(aspectRatio: 1, child:Tooltip(
                    message: 'verify all logic statements',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        debugPrint('verifyed all logic statements');
                      },
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
                  child: AspectRatio(aspectRatio: 1, child:Tooltip(
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
            itemCount: logicObjs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(1),
                // child: logicObjs[index],
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: logicObjs[index]),
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