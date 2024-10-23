import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

class SentenceTile{
  final Key key;
  bool? result;
  final TextEditingController controller;

  SentenceTile({
    required this.key,
    this.result,
    required this.controller,
  });
}

class LogicSentences extends StatefulWidget {
  const LogicSentences({super.key});

  @override
  State<LogicSentences> createState() => _LogicSentencesState();
}

class _LogicSentencesState extends State<LogicSentences> {
  double uiScale = 1;

  List<SentenceTile> sentenceTiles = [
    SentenceTile(
      key: UniqueKey(),
      controller: TextEditingController(),
    )
  ];

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
                                for (int i=0; i<sentenceTiles.length; i++) {
                                  ExpressionParser p = ExpressionParser();
                                  ExpressionTree tree = p.parse(sentenceTiles[i].controller.text);
                                  var result;
                                  try {
                                    result = tree.getValue(folWorlds[folWorldIndex], {});
                                  } catch (e) {
                                    print('Expression parser encountered an error:\n$e');
                                  }
                                  setState(() {
                                    if (result == true) {
                                      sentenceTiles[i].result = true;
                                    } else if (result == false) {
                                      sentenceTiles[i].result = false;
                                    } else {
                                      sentenceTiles[i].result = null;
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(backgroundAccentColor),
                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5*uiScale),
                                  )
                                ),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: foregroundAccentColor,
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
                              sentenceTiles.add(
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
                            sentenceTiles.clear();
                            sentenceTiles.add(
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
                color: backgroundAccentColor
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sentenceTiles.length,
                itemBuilder: (BuildContext context, int index) {
                  FocusNode focusNode = FocusNode();

                  return SizedBox(
                    key: sentenceTiles[index].key,
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
                                ExpressionTree tree = p.parse(sentenceTiles[index].controller.text);
                                var result;
                                try {
                                  result = tree.getValue(folWorlds[folWorldIndex], {});
                                } catch (e) {
                                  print('Expression parser encountered an error:\n$e');
                                }
                                setState(() {
                                  if (result == true) {
                                    sentenceTiles[index].result = true;
                                  } else if (result == false) {
                                    sentenceTiles[index].result = false;
                                  } else {
                                    sentenceTiles[index].result = null;
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(backgroundAccentColor),
                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5*uiScale),
                                  )
                                ),
                              ),
                              child: sentenceTiles[index].controller.text.replaceAll(' ', '').isEmpty
                                ? SizedBox()
                                : Icon(
                                  sentenceTiles[index].result==null
                                    ? Icons.pentagon_rounded
                                    : sentenceTiles[index].result!
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: sentenceTiles[index].result==null
                                    ? foregroundAccentColor
                                    : sentenceTiles[index].result!
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
                                  controller: sentenceTiles[index].controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12*uiScale, vertical: 4*uiScale),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5*uiScale),
                                    )
                                  ),
                                  style: TextStyle(
                                    fontSize: 16*uiScale,
                                    color: foregroundColor
                                  ),
                                  onTap: () {
                                    activeController=sentenceTiles[index].controller;
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
                                        sentenceTiles[index].result = true;
                                      } else if (result == false) {
                                        sentenceTiles[index].result = false;
                                      } else {
                                        sentenceTiles[index].result = null;
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
                                  sentenceTiles.removeWhere((st) => st.key == sentenceTiles[index].key);
                                  if (sentenceTiles.isEmpty) {
                                    sentenceTiles.add(
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