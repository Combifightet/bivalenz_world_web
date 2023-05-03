import 'package:flutter/material.dart';

import 'theme.dart';

class LogicElement extends StatelessWidget {
  const LogicElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: AspectRatio(aspectRatio: 1, child: Container(color: Colors.red))
          )
        ],
      )
    );
  }
}