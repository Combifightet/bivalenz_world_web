import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';


class LogicSentences extends StatefulWidget {
  const LogicSentences({super.key});

  @override
  State<LogicSentences> createState() => LogicSentencesState();
}

class LogicSentencesState extends State<LogicSentences> {
  double uiScale = 1;

  void refresh() => setState(() {});

  void validateAll()  {
    for (int i=0; i<folSentences[folSentenceIndex].length; i++) {
      validate(i);
    }
  }

  void validate(int index, [bool verboose=false]) {
    if (folSentences[folSentenceIndex][index].controller.text.replaceAll(' ', '').isNotEmpty) {
      ExpressionParser p = ExpressionParser();
      if (verboose) {
        debugPrint('verbose: true');
        p.setVerbose(true);
      }
      setState(() {
        try {
          folSentences[folSentenceIndex][index].result = null;
          ExpressionTree tree = p.parse(folSentences[folSentenceIndex][index].controller.text);
          folSentences[folSentenceIndex][index].result = tree.getValue(folWorlds[folWorldIndex], {});
        } on UnsupportedError catch (e) {     // missing varible / constant definition
          if (verboose) debugPrint('Expression parser encountered an error:  (UnsupportedError)\n  $e');
          folSentences[folSentenceIndex][index].lastError = e.toString();
        } on ArgumentError catch (e) {        // malformed expression
          if (verboose) debugPrint('Expression parser encountered an error:  (ArgumentError)\n  $e');
          folSentences[folSentenceIndex][index].lastError = e.toString();
        } on TypeError catch (e) {            // equation does not evalueate to a boolean
          if (verboose) debugPrint('Expression parser encountered an error:  (TypeError)\n  $e');
          folSentences[folSentenceIndex][index].lastError = null;
        } catch (e) {                         // unknown error encountered
          if (verboose) debugPrint('Expression parser encountered an error:\n  $e');
          folSentences[folSentenceIndex][index].lastError = null;
        }
      });
    } else {
      folSentences[folSentenceIndex][index].result = null;
      folSentences[folSentenceIndex][index].lastError = null;
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      AspectRatio(
                        aspectRatio: 1,
                          child: ElevatedButton(
                            onPressed: () => validateAll(),
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5*uiScale),
                                )
                              ),
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 32*uiScale,
                            )
                          ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8*uiScale),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              folSentences[folSentenceIndex].add(
                                SentenceTile(
                                  key: UniqueKey(),
                                  controller: TextEditingController(),
                                )
                              );
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
                          child: Icon(
                            Icons.add,
                            size: 32*uiScale,
                          )
                        )
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            folSentences[folSentenceIndex].clear();
                            folSentences[folSentenceIndex].add(
                              SentenceTile(
                                key: UniqueKey(),
                                controller: TextEditingController(),
                              )
                            );
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
                        child: Icon(
                          Icons.delete_forever,
                          size: 32*uiScale,
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8*uiScale),
              child: Divider(
                height: 4*uiScale,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: folSentences[folSentenceIndex].length,
                itemBuilder: (BuildContext context, int index) {
                  FocusNode focusNode = FocusNode();

                  focusNode.addListener(() {
                    print('has focus: ${focusNode.hasFocus} ($index)');
                    if (focusNode.hasFocus) {
                      activeController = folSentences[folSentenceIndex][index].controller;
                      activeTextField  = focusNode;
                    }
                  });

                  return SizedBox(
                    key: folSentences[folSentenceIndex][index].key,
                    height: 64*uiScale,
                    child: Padding(
                      padding: EdgeInsets.all(8*uiScale),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                              onPressed: folSentences[folSentenceIndex][index].controller.text.replaceAll(' ', '').isEmpty?null:()=>validate(index, kDebugMode),
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5*uiScale),
                                  )
                                ),
                              ),
                              child: folSentences[folSentenceIndex][index].controller.text.replaceAll(' ', '').isEmpty
                                ? SizedBox()
                                : Tooltip(
                                  waitDuration: Durations.extralong1,
                                  // TODO: styling / scaling of tooltip
                                  message: folSentences[folSentenceIndex][index].result==null
                                      ? folSentences[folSentenceIndex][index].lastError ?? 'Failed to parse \'formulaBegin\''
                                      : folSentences[folSentenceIndex][index].result.toString(),
                                  child: Icon(
                                    folSentences[folSentenceIndex][index].result==null
                                      ? folSentences[folSentenceIndex][index].lastError==null
                                        ? Icons.star
                                        : Icons.priority_high
                                      : folSentences[folSentenceIndex][index].result!
                                        ? Icons.check_rounded
                                        : Icons.close_rounded,
                                    color: folSentences[folSentenceIndex][index].result==null
                                      ? null
                                      : folSentences[folSentenceIndex][index].result!
                                        ? greenAccentColor
                                        : redAccentColor,
                                    size: 32*uiScale,
                                  ),
                                )
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8*uiScale),
                              child: Center(
                                child: TextField(
                                  focusNode: focusNode,
                                  controller: folSentences[folSentenceIndex][index].controller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter text...',
                                    hintStyle: TextStyle(
                                      fontSize: 16*uiScale,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Color.alphaBlend(
                                        Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                                        Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12*uiScale, vertical: 4*uiScale),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5*uiScale),
                                    )
                                  ),
                                  style: TextStyle(
                                    fontSize: 16*uiScale,
                                  ),
                                  onChanged: (x) {
                                    print('onChanged: ($x)');
                                    setState(() {
                                      validate(index);
                                    });
                                  },
                                  onSubmitted: (value) {
                                    activeController = null;
                                    activeTextField  = null;
                                    validate(index);
                                  },
                                ),
                              )
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  folSentences[folSentenceIndex].removeWhere((st) => st.key == folSentences[folSentenceIndex][index].key);
                                  if (folSentences[folSentenceIndex].isEmpty) {
                                    folSentences[folSentenceIndex].add(
                                      SentenceTile(
                                        key: UniqueKey(),
                                        controller: TextEditingController(),
                                      )
                                    );
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
                              child: Icon(
                                Icons.delete,
                                size: 32*uiScale,
                              )
                            ),
                          ),
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
    );
  }
}