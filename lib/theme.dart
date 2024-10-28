import 'package:logic_expr_tree/logic_expr_tree.dart';
import 'package:flutter/material.dart';

import 'logic_sentences.dart';
import 'object_buttons.dart';

//-- GLOBAL VARIABLES --\\

int folWorldIndex = 0;
int folSentenceIndex = 0;
const int folWorldSize = 8;
List<FolWorld> folWorlds = [FolWorld()];
List<String?> folWorldNames = [null];
List<List<SentenceTile>> folSentences = [[SentenceTile(
  key: UniqueKey(),
  controller: TextEditingController(),
)]];
List<String?> folSentenceNames = [''];
final GlobalKey<LogicSentencesState> folScentenceKey = GlobalKey();
final GlobalKey<ObjectButtonsState> objecButtonsKey = GlobalKey();
Offset? selectedTile;
TextEditingController? activeController;
FocusNode? activeTextField;


//----- COLOR DATA -----\\

const Color backgroundColor       = Color(0xff242836);
const Color backgroundAccentColor = Color(0xff2f3545);

const Color foregroundColor       = Color(0xfff5f9ff);
const Color foregroundAccentColor = Color(0xffe4ecfa);

const Color boardDarkLightColor   = Color(0xff373c44);
const Color boardDarkDarkColor    = Color(0xff1b1e25);
const Color boardLightLightColor  = Color(0xfffcfcf0);
const Color boardLightDarkColor   = Color(0xffd1d0cb);
bool invertBoard = true;

const Color redAccentColor    = Color(0xffe06c75);
const Color blueAccentColor   = Color(0xff61afef);
const Color yellowAccentColor = Color(0xffe5c07b);

const Color greenAccentColor  = Color(0xff98c379);
const Color orangeAccentColor = Color(0xffd19a66);
const Color cyanAccentColor   = Color(0xff56b6c2);
const Color purpleAccentColor = Color(0xffc678dd);



final int _primaryColor = (cyanAccentColor.a.toInt() << 24) | (cyanAccentColor.r.toInt() << 16) | (cyanAccentColor.g.toInt() << 8) | cyanAccentColor.b.toInt();
final MaterialColor pSwatch = MaterialColor(_primaryColor, <int, Color>{
    50:  Color(0xffF0F8FA),
    100: Color(0xffD2EBEF),
    200: Color(0xffB4DEE4),
    300: Color(0xff96D1D9),
    400: Color(0xff78C4CE),
    500: cyanAccentColor,
    600: Color(0xff41A7B4),
    700: Color(0xff368B96),
    800: Color(0xff2B6F78),
    900: Color(0xff20535A),
});


//----- THEME DATA -----\\

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: pSwatch,
  scaffoldBackgroundColor: foregroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor;
        } else {
          return foregroundAccentColor;
        }
      }),
      foregroundColor: WidgetStatePropertyAll(backgroundAccentColor),
      iconColor: WidgetStatePropertyAll(backgroundAccentColor),
      overlayColor: WidgetStatePropertyAll(cyanAccentColor.withAlpha(50)),
    )
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: cyanAccentColor,
    selectionColor: cyanAccentColor.withAlpha(100),
    selectionHandleColor: cyanAccentColor
  ),
  textTheme: TextTheme().apply(
    bodyColor: backgroundAccentColor,
    displayColor: backgroundAccentColor,
  ),
  dividerColor: foregroundAccentColor,
  disabledColor: backgroundAccentColor,
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(backgroundAccentColor),
    trackColor: WidgetStatePropertyAll(foregroundColor),
    trackOutlineColor: WidgetStatePropertyAll(foregroundAccentColor),
    trackOutlineWidth: WidgetStatePropertyAll(0),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: backgroundAccentColor,
    textColor: backgroundAccentColor,
    tileColor: foregroundAccentColor,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: foregroundAccentColor
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: cyanAccentColor,
  scaffoldBackgroundColor: backgroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return backgroundColor;
        } else {
          return backgroundAccentColor;
        }
      }),
      foregroundColor: WidgetStatePropertyAll(foregroundAccentColor),
      iconColor: WidgetStatePropertyAll(foregroundAccentColor),
      overlayColor: WidgetStatePropertyAll(cyanAccentColor.withAlpha(50)),
    )
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: cyanAccentColor,
    selectionColor: cyanAccentColor.withAlpha(100),
    selectionHandleColor: cyanAccentColor
  ),
  textTheme: TextTheme().apply(
    bodyColor: foregroundAccentColor,
    displayColor: foregroundAccentColor,
  ),
  dividerColor: backgroundAccentColor,
  disabledColor: foregroundAccentColor,
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(foregroundAccentColor),
    trackColor: WidgetStatePropertyAll(backgroundColor),
    trackOutlineColor: WidgetStatePropertyAll(backgroundAccentColor),
    trackOutlineWidth: WidgetStatePropertyAll(0),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: foregroundAccentColor,
    textColor: foregroundAccentColor,
    tileColor: backgroundAccentColor,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: backgroundAccentColor
  )
);


//--  UTILITY CLASS --//

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
