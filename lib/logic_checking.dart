import 'package:bivalenz_world_web/object_handeling.dart';
import 'package:flutter/material.dart';


//* RegEx
// a=a        ([a-z])=\1            //? true
// ⊤∧⊤        ⊤∧⊤                  //? true
// ¬(⊤∧⊤)     ⊤∧⊥|⊥∧⊤|⊥∧⊥         //? false
// ⊥∨⊥        ⊥∨⊥                  //? true
// ¬(⊥∨⊥)     ⊥∨⊥|⊥∨⊥|⊥∨⊥         //? false
// ⊤→⊤        ⊤→⊤|⊥→⊤|⊥→⊥         //? true
// ⊤→⊥        ⊤→⊥                  //? false
// ⊤↔⊤        ([⊤⊥])↔\1            //? true
// ⊤↔⊥        ⊤↔⊥|⊥↔⊤              //? false
//!   ≠ = ∀ ∃

//* Stärke der Bindungen in Bivalenz World:
// =
// ∧ ∨    (left to right)
// 
// 
// 
// 

//! ∧ ∨

String checkLogicTxt(String logicTxt, List<List<List<LogicObj>>> logicBoard) {

  Offset? idToOffest(String chr) {  // 'a'
    for (int i=0; i<logicBoard.length; i++) {
      for (int j=0; j<logicBoard[i].length; j++) {
        if (logicBoard[i][j].isNotEmpty && logicBoard[i][j][0].id.contains(chr)) {
          return Offset(i.toDouble(), j.toDouble());
        }
      }
    }
    return null;
  }
  Offset? posToOffset(String pos) {         // 'xxx:yyy'
    return Offset(double.parse(pos.substring(0, pos.indexOf(':'))), double.parse(pos.substring(pos.indexOf(':'))));
  }

  Offset? getOffset(String str) {
    if (str.contains(':') && str.length >= 3) {
      return posToOffset(str);
    } else {
      return idToOffest(str);
    }
  }

  String lm(String str){
    Offset? pos = getOffset(str);
    if (pos != null) {
      for (int k=0; k<=pos.dx.toInt(); k++) {
        if (logicBoard[pos.dx.toInt()][k].isNotEmpty) {
          return '$k;${pos.dy.toInt()}';
        }
      }
    }
    return 'error1';
  }
  String rm(String str){
    Offset? pos = getOffset(str);
    if (pos != null) {
      for (int k=logicBoard[pos.dy.toInt()].length-1; k>=pos.dx; k--) {
        if (logicBoard[pos.dy.toInt()][k].isNotEmpty) {
          return '$k:${pos.dy.toInt()}';
        }
      }
    }
    return 'error1';
  }
  String bm(String chr){
    for (int i=0; i<logicBoard.length; i++) {
      for (int j=0; j<logicBoard[i].length; j++) {
        if (logicBoard[i][j].isNotEmpty && logicBoard[i][j][0].id.contains(chr)) {
          for (int k=0; k<=j; k++) {
            if (logicBoard[i][k].isNotEmpty) {
              return '$i;$k';
            }
          }
        }
      }
    }
    return 'error1';
  }
  String fm(String chr){
    for (int i=0; i<logicBoard.length; i++) {
      for (int j=0; j<logicBoard[i].length; j++) {
        if (logicBoard[i][j].isNotEmpty && logicBoard[i][j][0].id.contains(chr)) {
          for (int k=0; k<=j; k++) {
            if (logicBoard[i][k].isNotEmpty) {
              return '$i;$k';
            }
          }
        }
      }
    }
    return 'error1';
  }


  while (logicTxt.contains('lm(')) {
    final int index = logicTxt.lastIndexOf('lm(');
    if (logicTxt[index+4] == ')') {
      final String eval = lm(logicTxt[index+3]);
      if (eval == 'error1') {
        return 'error1';
      }  else {
        logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
      }
    } else {
      return 'error1';
    } 
  }
  while (logicTxt.contains('rm(')) {
    final int index = logicTxt.lastIndexOf('rm(');
    if (logicTxt[index+4] == ')') {
      final String eval = rm(logicTxt[index+3]);
      if (eval == 'error1') {
        return 'error1';
      }  else {
        logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
      }
    } else {
      return 'error1';
    } 
  }
  while (logicTxt.contains('bm(')) {
    final int index = logicTxt.lastIndexOf('bm(');
    if (logicTxt[index+4] == ')') {
      final String eval = bm(logicTxt[index+3]);
      if (eval == 'error1') {
        return 'error1';
      }  else {
        logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
      }
    } else {
      return 'error1';
    } 
  }
  while (logicTxt.contains('fm(')) {
    final int index = logicTxt.lastIndexOf('fm(');
    if (logicTxt[index+4] == ')') {
      final String eval = fm(logicTxt[index+3]);
      if (eval == 'error1') {
        return 'error1';
      }  else {
        logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
      }
    } else {
      return 'error1';
    } 
  }

  debugPrint(logicTxt);

  return '⊤';
  // return '⊥';
  // return 'error0';    // Failed to parrse 'formmulaBegin'.
  // return 'error1';    // Function 'rl' not found in the signature
  // return 'error2';    // The constant symbol [a] is nnot assigned to this world
  // return 'error3';    // Predicate 'Smaler' not found in the signature
  // return 'error4';    // This formula contains an unknown symbol [ab]
}