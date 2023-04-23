import 'package:flutter/material.dart';

// const Color backgroundColor = Color(0xff23272e);
const Color backgroundColor = Color(0xff242836);
// const Color backgroundAccentColor = Color(0xff2c313c);
const Color backgroundAccentColor = Color(0xff2f3545);

// const Color foregroundColor = Color(0xffabb2bf);
const Color foregroundColor = Color(0xfff5f9ff);
// const Color foregroundAccentColor = Color(0xff7f848e);
const Color foregroundAccentColor = Color(0xffe4ecfa);

const Color redAccentColor = Color(0xffe06c75);
const Color blueAccentColor = Color(0xff61afef);
const Color yellowAccentColor = Color(0xffe5c07b);

const Color greenAccentColor = Color(0xff98c379);
const Color orangeAccentColor = Color(0xffd19a66);
const Color cyanAccentColor = Color(0xff56b6c2);
const Color purpleAccentColor = Color(0xffc678dd);

ButtonStyle squareButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return foregroundAccentColor;
    }
      return backgroundAccentColor;
    }),
  foregroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return backgroundAccentColor;
    }
      return foregroundAccentColor;
  }),
  overlayColor: MaterialStateProperty.all(foregroundAccentColor.withAlpha(20)),
  elevation: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return 0;
    }
      return 5;
  }),
  textStyle: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return const TextStyle(color: backgroundAccentColor, fontWeight: FontWeight.bold);
    }
      return const TextStyle(color: foregroundAccentColor, fontWeight: FontWeight.bold);
  }),
  iconColor: MaterialStateProperty.all(foregroundAccentColor),
  iconSize: MaterialStateProperty.all(30),

);