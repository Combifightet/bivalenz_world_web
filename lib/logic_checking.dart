import 'dart:js_interop';

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
          return Offset(j.toDouble(), i.toDouble());
        }
      }
    }
    return null;
  }
  Offset? posToOffset(String pos) {         // 'xxx:yyy'
    return Offset(
      double.parse(pos.substring(0, pos.indexOf(':'))),
      double.parse(pos.substring(pos.indexOf(':')+1)));
  }


  String lm(String str){
    Offset? pos = posToOffset(str);
    if (pos != null) {
      for (int i=0; i<=pos.dx.floor(); i++) {
        if (logicBoard[pos.dy.floor()][i].isNotEmpty) {
          return '$i:${pos.dy.floor()}';
        }
      }
    }
    return 'error1';
  }
  String rm(String str){
    Offset? pos = posToOffset(str);
    if (pos != null) {
      for (int i=logicBoard[pos.dy.floor()].length-1; i>=pos.dx.floor(); i--) {
        if (logicBoard[pos.dy.floor()][i].isNotEmpty) {
          return '$i:${pos.dy.floor()}';
        }
      }
    }
    return 'error1';
  }
  String bm(String str){
    Offset? pos = posToOffset(str);
    if (pos != null) {
      for (int i=0; i<=logicBoard.length-1; i++) {
        if (logicBoard[i][pos.dx.floor()].isNotEmpty) {
          return '${pos.dx.floor()}:$i';
        }
      }
    }
    return 'error1';
  }
  String fm(String str){
    Offset? pos = posToOffset(str);
    if (pos != null) {
      for (int i=logicBoard.length-1; i>=0; i--) {
        if (logicBoard[i][pos.dx.floor()].isNotEmpty) {
          return '${pos.dx.floor()}:$i';
        }
      }
    }
    return 'error1';
  }

  // [a-m] constants     [n-z] variables
  logicTxt.replaceAll(' ', '');
  
  for (int i=logicTxt.length-1; i>=0; i--) {
    if (logicTxt[i].codeUnitAt(0) >= 97 && logicTxt[i].codeUnitAt(0) <= 109 && logicTxt.substring((i-1).clamp(0, i), (i+2).clamp(0, logicTxt.length)).replaceAll(RegExp(r'[a-zA-Z]'), '').length==logicTxt.substring((i-1).clamp(0, i), (i+2).clamp(0, logicTxt.length)).length-1) {
      var offset = idToOffest(logicTxt[i]);
      logicTxt = logicTxt.replaceRange(i, i+1, '${offset!.dx}:${offset.dy}');
    }
  }
  debugPrint(logicTxt);


  while (logicTxt.contains(RegExp(r'(lm\(|rm\(|fm\(|bm\()\d+:\d+\)'))) {
    int index = logicTxt.lastIndexOf(RegExp(r'(lm\(|rm\(|fm\(|bm\()\d+:\d+\)'));
    var match = RegExp(r'(lm\(|rm\(|fm\(|bm\()\d+:\d+\)').firstMatch(logicTxt);
    print('Match: $match');
    // print(match!.substring(0, 2));
    // print(match.substring(3,match.length-1));
    if (!match.isNull) {
      print('True');
      String? substr = match![0];
      switch (substr!.substring(0, 2)) {
        case 'lm':
          print('Case lm');
          print(lm(substr.substring(3,substr.length-1)));
          logicTxt = logicTxt.replaceAll(substr, lm(substr.substring(3,substr.length-1)));
          break;
        case 'rm':
          print('Case rm');
          print(rm(substr.substring(3,substr.length-1)));
          logicTxt = logicTxt.replaceAll(substr, rm(substr.substring(3,substr.length-1)));
          break;
        case 'fm':
          print('Case fm');
          print(fm(substr.substring(3,substr.length-1)));
          logicTxt = logicTxt.replaceAll(substr, fm(substr.substring(3,substr.length-1)));
          break;
        case 'bm':
          print('Case bm');
          print(bm(substr.substring(3,substr.length-1)));
          logicTxt = logicTxt.replaceAll(substr, bm(substr.substring(3,substr.length-1)));
          break;
        default:
        return 'error1';
      }
    }
    print('Substep:         $logicTxt');
  }


  // while (logicTxt.contains('lm(')) {
  //   final int index = logicTxt.lastIndexOf('lm(');
  //   print('Substring: ${logicTxt.substring(index+3, logicTxt.length)}');
  //   if (logicTxt[index+4] == ')') {
  //     final String eval = lm(logicTxt[index+3]);
  //     if (eval == 'error1') {
  //       return 'error1';
  //     }  else {
  //       logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
  //     }
  //   } else {
  //     return 'error1';
  //   } 
  // }
  // while (logicTxt.contains('rm(')) {
  //   final int index = logicTxt.lastIndexOf('rm(');
  //   if (logicTxt[index+4] == ')') {
  //     final String eval = rm(logicTxt[index+3]);
  //     if (eval == 'error1') {
  //       return 'error1';
  //     }  else {
  //       logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
  //     }
  //   } else {
  //     return 'error1';
  //   } 
  // }
  // while (logicTxt.contains('bm(')) {
  //   final int index = logicTxt.lastIndexOf('bm(');
  //   if (logicTxt[index+4] == ')') {
  //     final String eval = bm(logicTxt[index+3]);
  //     if (eval == 'error1') {
  //       return 'error1';
  //     }  else {
  //       logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
  //     }
  //   } else {
  //     return 'error1';
  //   } 
  // }
  // while (logicTxt.contains('fm(')) {
  //   final int index = logicTxt.lastIndexOf('fm(');
  //   if (logicTxt[index+4] == ')') {
  //     final String eval = fm(logicTxt[index+3]);
  //     if (eval == 'error1') {
  //       return 'error1';
  //     }  else {
  //       logicTxt = logicTxt.substring(0, index) + eval + logicTxt.substring(index+5);
  //     }
  //   } else {
  //     return 'error1';
  //   } 
  // }

  debugPrint('Result: $logicTxt');

  return '⊤';
  // return '⊥';
  // return 'error0';    // Failed to parrse 'formmulaBegin'.
  // return 'error1';    // Function 'rl' not found in the signature
  // return 'error2';    // The constant symbol [a] is nnot assigned to this world
  // return 'error3';    // Predicate 'Smaler' not found in the signature
  // return 'error4';    // This formula contains an unknown symbol [ab]
}