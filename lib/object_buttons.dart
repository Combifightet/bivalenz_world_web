import 'package:flutter/material.dart';

import 'object_handeling.dart';
import 'theme.dart';

class OptionButtons extends StatefulWidget {
  const OptionButtons({super.key});

  @override
  State<OptionButtons> createState() => OptionButtonsState();
}

class OptionButtonsState extends State<OptionButtons> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'a\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('a');
                        });
                      },
                        child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Text('a')
                        ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'b\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('b');
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('b')
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'c\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('c');
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('c')
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'d\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('d');
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('d')
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'e\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('e');
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('e')
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set id \'f\'',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.addId('f');
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('f')
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set shape triangle',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSides(3);
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.change_history_rounded, color: redAccentColor,),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set shape square',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSides(4);
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.crop_square, color: blueAccentColor,)
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set shape pentagon',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSides(5);
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.star, color: yellowAccentColor,),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set size small',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSize(0);
                        });
                      },
                      child: const FractionallySizedBox(
                        widthFactor: 1/3,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.circle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set size medium',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSize(1);
                        });
                      },
                      child: const FractionallySizedBox(
                        widthFactor: 2/3,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.circle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'set size big',
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: squareButtonStyle,
                      onPressed: () {
                        setState(() {
                          mainBoard.setSize(2);
                        });
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.circle),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}
