import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

import 'theme.dart';

class BoardHandeler extends StatefulWidget {
  const BoardHandeler({super.key});

  @override
  State<BoardHandeler> createState() => _BoardHandelerState();
}

class _BoardHandelerState extends State<BoardHandeler> {
  double uiScale = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = constraints.maxHeight/42;
        List<Widget> children = [];
        for (int i=0; i<folWorldNames.length; i++) {
          String str = folWorldNames[i]??'Unsaved World';
          children.add(
            Chip(
              deleteIcon: folWorldIndex!=i?null:Icon(Icons.close, size: 32*uiScale,),
              label: Text(
                str,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20*uiScale
                ),
              ),
              onDeleted: () {
                folWorlds.removeAt(i);
                folWorldNames.removeAt(i);
                if(folWorlds.isEmpty) {
                  folWorlds.add(FolWorld());
                  folWorldNames.add(null);
                }
                folWorldIndex = max(0, i-1);
              },
              padding: EdgeInsets.zero,
            )
          );
        }
        children.add(
          AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              onPressed: () => print('TODO: create new world'),
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