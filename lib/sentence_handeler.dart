import 'dart:math';

import 'package:flutter/material.dart';

import 'theme.dart';

class SentenceHandeler extends StatefulWidget {
  const SentenceHandeler({super.key});

  @override
  State<SentenceHandeler> createState() => SentenceHandelerState();
}

class SentenceHandelerState extends State<SentenceHandeler> {
  double uiScale = 1;

  void refresh() => setState(() {});

  void delete(int index) {
    folSentences.removeAt(index);
    folSentenceNames.removeAt(index);
    if(folSentences.isEmpty) {
      folSentences.add([]);
      folSentenceNames.add(null);
    }
    setState(() {
      if (index<=folSentenceIndex) {
        folSentenceIndex = max(0, folSentenceIndex-1);
      }
    });
    folScentenceKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = constraints.maxHeight/42;
        List<Widget> children = [];
        for (int i=0; i<folSentenceNames.length; i++) {
          String str = folSentenceNames[i]!=null?folSentenceNames[i]!.name:'Untitled Sentences';
          final style = TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20*uiScale
          );
          final span = TextSpan(
            text: str,
            style: style,
          );
          final painter = TextPainter(
            text: span,
            maxLines: 1,
            textScaler: MediaQuery.of(context).textScaler,
            textDirection: TextDirection.ltr,
          );
          painter.layout();
          double textWidth = painter.size.width;
          Widget chip = GestureDetector(
            // splashColor: Colors.transparent,
            // hoverColor: Colors.transparent,
            // overlayColor: WidgetStatePropertyAll(Colors.transparent),
            onTap: () {
              if (folSentenceIndex!=i) {
                setState(() {
                  folSentenceIndex = i;
                  folScentenceKey.currentState?.refresh();
                });
              }
            },
            onTertiaryTapUp: (_) => delete(i),
            child: Container(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double chipWidth = (folSentenceIndex==i?52:20)+textWidth;
                  double padding = max(0, constraints.maxWidth-chipWidth)/2;
                  return Chip(
                    color: folSentenceIndex!=i
                      ? null
                      : WidgetStatePropertyAll(
                        Color.alphaBlend(
                          Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                          Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!,
                        ),
                      ),
                    deleteIcon: Center(child: Icon(Icons.close, size: 32*uiScale,)),
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        str,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20*uiScale
                        ),
                      ),
                    ),
                    onDeleted: folSentenceIndex!=i?null:() => delete(i),
                  );
                }
              ),
            ),
          );
          Widget expandedChip = GestureDetector(
            // splashColor: Colors.transparent,
            // hoverColor: Colors.transparent,
            // overlayColor: WidgetStatePropertyAll(Colors.transparent),
            // onTap: () {},
            onTertiaryTapUp: (_) => delete(i),
            child: Chip(
              color: WidgetStatePropertyAll(
                Color.alphaBlend(
                  Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                  Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!,
                ),
              ),
              deleteIcon: Center(child: Icon(Icons.close, size: 32*uiScale,)),
              label: Text(
                str,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20*uiScale
                ),
              ),
              onDeleted: folSentenceIndex!=i?null:() {
                folSentences.removeAt(i);
                folSentenceNames.removeAt(i);
                if(folSentences.isEmpty) {
                  folSentences.add([]);
                  folSentenceNames.add(null);
                }
                setState(() {
                  folSentenceIndex = max(0, i-1);
                });
                folScentenceKey.currentState?.refresh();
              },
            ),
          );
          children.add(folSentenceIndex==i && constraints.maxWidth/folSentences.length<textWidth+52
            ? expandedChip
            : Expanded(child: chip)
          );
        }
        children.add(
          AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  folSentences.add([SentenceTile(
                    key: UniqueKey(),
                    controller: TextEditingController(),
                  )]);
                  folSentenceNames.add(null);
                  folSentenceIndex = folSentences.length-1;
                });
                folScentenceKey.currentState?.refresh();
              },
              icon: Icon(Icons.add, size: 32*uiScale),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero)
              ),
            ),
          )
        );
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      }
    );
  }
}