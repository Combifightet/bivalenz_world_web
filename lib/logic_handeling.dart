import 'package:flutter/material.dart';

import 'theme.dart';

class LogicElement extends StatelessWidget {
  const LogicElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Card(
                color: backgroundAccentColor,
                elevation: 5,
                child: FittedBox(
                  fit: BoxFit.contain,
                  // child: Text('T', style: TextStyle(fontWeight: FontWeight.bold, color: greenAccentColor)),
                  // child: Text('F', style: TextStyle(fontWeight: FontWeight.bold, color: redAccentColor)),
                  // child: Icon(Icons.star, color: foregroundAccentColor),
                  child: Icon(Icons.close_rounded, color: foregroundAccentColor),
                ),
              )
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundAccentColor,
                  hintText: 'Enter a logic statement',
                  hintStyle: TextStyle(color: foregroundAccentColor.withOpacity(.5)),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: foregroundAccentColor.withOpacity(0.5))) // TODO: Does not yet display the correct coler for the underline of th text field
                ),
                style: const TextStyle(
                  color: foregroundAccentColor,
                ),
                onChanged: (value) {
                  
                },
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: AspectRatio(aspectRatio: 1, child:Tooltip(
              message: 'remove this logic statement',
              waitDuration: const Duration(seconds: 1),
              child: TextButton(
                style: squareButtonStyle,
                onPressed: () {
                  debugPrint('delete this logic statement');
                },
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.delete_outline_rounded),
                ),
              ),
            ),
            )
          )
        ],
      )
    );
  }
}