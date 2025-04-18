import 'package:flutter/material.dart';
// import 'dart:math';

// import 'package:logic_expr_tree/logic_expr_tree.dart';
import 'home_page.dart';
import 'theme.dart';


void main() {
  runApp(const MainApp());
}

// TODO: add tooltips for each button
// TODO: y-coordinates are flipped

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // double uiScale = max(min(constraints.maxHeight, constraints.maxWidth/16*9)/6.4, 64)/97;
        return ValueListenableBuilder(
          valueListenable: themeMode,
          builder: (BuildContext context, ThemeMode currentMode, Widget? child) {
            return MaterialApp(
              // debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: currentMode,
              home: HomePage(),
            );
          }
        );
      },
    );
  }
}
