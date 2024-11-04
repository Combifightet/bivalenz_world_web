import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

import 'theme.dart';

class BoardHandeler extends StatefulWidget {
  const BoardHandeler({super.key});

  @override
  State<BoardHandeler> createState() => BoardHandelerState();
}

class BoardHandelerState extends State<BoardHandeler> {
  double uiScale = 1;

  void refresh() => setState(() {});

  void delete(int index) {
    folWorlds.removeAt(index);
    folWorldNames.removeAt(index);
    if(folWorlds.isEmpty) {
      folWorlds.add(FolWorld());
      folWorldNames.add(null);
    }
    setState(() {
      if (index<=folWorldIndex) {
          folWorldIndex = max(0, folWorldIndex-1);
      }
    });
    objecButtonsKey.currentState?.refresh();
    folScentenceKey.currentState?.validateAll();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = constraints.maxHeight/42;
        List<Widget> children = [];
        for (int i=0; i<folWorldNames.length; i++) {
          String str = folWorldNames[i]!=null?folWorldNames[i]!.name:'Unsaved World';
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
          double chipWidth = (folWorldIndex==i?34+30*uiScale:34)+textWidth;
          Widget chip = GestureDetector(
            onTap: () {
              if (folWorldIndex!=i) {
                setState(() {
                  folWorldIndex = i;
                  objecButtonsKey.currentState?.refresh();
                  folScentenceKey.currentState?.validateAll();
                });
              }
            },
            onTertiaryTapUp: (_) => delete(i),
            child: Container(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double padding = max(0, constraints.maxWidth-chipWidth)/2;
                  return Chip(
                    color: folWorldIndex!=i
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
                    onDeleted: folWorldIndex!=i?null:() => delete(i),
                  );
                }
              ),
            ),
          );
          Widget expandedChip = GestureDetector(
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
              onDeleted: folWorldIndex!=i?null:() {
                folWorlds.removeAt(i);
                folWorldNames.removeAt(i);
                if(folWorlds.isEmpty) {
                  folWorlds.add(FolWorld());
                  folWorldNames.add(null);
                }
                setState(() {
                  folWorldIndex = max(0, i-1);
                });
                objecButtonsKey.currentState?.refresh();
                folScentenceKey.currentState?.validateAll();
              },
            ),
          );
          children.add(folWorldIndex==i && constraints.maxWidth/folWorlds.length<chipWidth+20*uiScale
            ? expandedChip
            : Expanded(child: chip)
          );
        }
        children.add(
          AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              onPressed: () {
                folWorlds.add(FolWorld());
                folWorldNames.add(null);
                folWorldIndex = folWorlds.length-1;
                refresh();
                objecButtonsKey.currentState?.refresh();
                folScentenceKey.currentState?.validateAll();
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