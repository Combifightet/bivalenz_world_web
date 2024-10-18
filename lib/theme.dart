import 'package:logic_expr_tree/logic_expr_tree.dart';
import 'package:flutter/material.dart';

//-- GLOBAL VARIABLES --\\

int folWorldIndex = 0;
const int folWorldSize = 8;
List<FolWorld> folWorlds = [FolWorld()];
Offset? selectedTile;


//----- COLOR DATA -----\\

const Color backgroundColor       = Color(0xff242836);
const Color backgroundAccentColor = Color(0xff2f3545);

const Color foregroundColor       = Color(0xfff5f9ff);
const Color foregroundAccentColor = Color(0xffe4ecfa);

const Color boardLightColor   = Color(0xff373c44);
const Color boardDarkColor    = Color(0xff1b1e25);
bool invertBoard = false;

const Color redAccentColor    = Color(0xffe06c75);
const Color blueAccentColor   = Color(0xff61afef);
const Color yellowAccentColor = Color(0xffe5c07b);

const Color greenAccentColor  = Color(0xff98c379);
const Color orangeAccentColor = Color(0xffd19a66);
const Color cyanAccentColor   = Color(0xff56b6c2);
const Color purpleAccentColor = Color(0xffc678dd);


//----- THEME DATA -----\\

// TODO: Reimplement theme
