import 'package:flutter/material.dart';
import 'dart:math';

// import 'package:logic_expr_tree/logic_expr_tree.dart';

import 'home_page.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double uiScale = max(min(constraints.maxHeight, constraints.maxWidth/16*9)/6.4, 64)/97;
        return MaterialApp(
          home: HomePage(
            uiScale: uiScale,
          ),
        );
      },
    );
    // return const MaterialApp(
    //   home: HomePage(),
    // );
  }
}
