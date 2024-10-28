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
                        // child: Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                for (int i=0; i<folSentences[folSentenceIndex].length; i++) {
                                  ExpressionParser p = ExpressionParser();
                                  ExpressionTree tree = p.parse(folSentences[folSentenceIndex][i].controller.text);
                                  // ignore: prefer_typing_uninitialized_variables
                                  var result;
                                  try {
                                    result = tree.getValue(folWorlds[folWorldIndex], {});
                                  } catch (e) {
                                    print('Expression parser encountered an error:\n$e');
                                  }
                                  setState(() {
                                    if (result == true) {
                                      folSentences[folSentenceIndex][i].result = true;
                                    } else if (result == false) {
                                      folSentences[folSentenceIndex][i].result = false;
                                    } else {
                                      folSentences[folSentenceIndex][i].result = null;
                                    }
                                  });
                                }
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
                                Icons.check_rounded,
                                size: 32*uiScale,
                              )
                            ),
                        // )
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
                              onPressed: () {
                                ExpressionParser p = ExpressionParser();
                                print('verbose: $kDebugMode');
                                if (kDebugMode) {
                                  p.setVerbose(true);
                                }
                                ExpressionTree tree = p.parse(folSentences[folSentenceIndex][index].controller.text);
                                // ignore: prefer_typing_uninitialized_variables
                                var result;
                                try {
                                  result = tree.getValue(folWorlds[folWorldIndex], {});
                                } catch (e) {
                                  print('Expression parser encountered an error:\n$e');
                                }
                                setState(() {
                                  if (result == true) {
                                    folSentences[folSentenceIndex][index].result = true;
                                  } else if (result == false) {
                                    folSentences[folSentenceIndex][index].result = false;
                                  } else {
                                    folSentences[folSentenceIndex][index].result = null;
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
                              child: folSentences[folSentenceIndex][index].controller.text.replaceAll(' ', '').isEmpty
                                ? SizedBox()
                                : Icon(
                                  folSentences[folSentenceIndex][index].result==null
                                    // TODO: add plus sign with error messages
                                    // star only for not beeing able to parse formula
                                    ? Icons.star
                                    : folSentences[folSentenceIndex][index].result!
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: folSentences[folSentenceIndex][index].result==null
                                    ? null
                                    : folSentences[folSentenceIndex][index].result!
                                      ? greenAccentColor
                                      : redAccentColor,
                                  size: 32*uiScale,
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
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12*uiScale, vertical: 4*uiScale),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5*uiScale),
                                    )
                                  ),
                                  style: TextStyle(
                                    fontSize: 16*uiScale,
                                  ),
                                  onTap: () {
                                    activeController=folSentences[folSentenceIndex][index].controller;
                                    activeTextField =focusNode;
                                  },
                                  onSubmitted: (value) {
                                    print('submitted');
                                    activeController=null;
                                    activeTextField =null;
                                    ExpressionParser p = ExpressionParser();
                                    ExpressionTree tree = p.parse(value);
                                    var result;
                                    try {
                                      result = tree.getValue(folWorlds[folWorldIndex], {});
                                    } catch (e) {
                                      print('Expression parser encountered an error:\n$e');
                                    }
                                    setState(() {
                                      if (result == true) {
                                        folSentences[folSentenceIndex][index].result = true;
                                      } else if (result == false) {
                                        folSentences[folSentenceIndex][index].result = false;
                                      } else {
                                        folSentences[folSentenceIndex][index].result = null;
                                      }
                                    });
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