import 'dart:js_interop';

import 'package:bivalenz_world_web/object_handeling.dart';
import 'package:flutter/material.dart';


String checkLogicTxt(String logicTxt, List<List<List<LogicObj>>> logicBoard) {
  logicTxt = logicTxt.replaceAll(' ', '');
  int inputLength = logicTxt.length;

  Offset? idToOffest(String chr) {
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

  int getSides(String str) {
    Offset? pos = posToOffset(str);
    if (pos != null && logicBoard[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
      return logicBoard[pos.dy.floor()][pos.dx.floor()][0].sides;
    }
    return -1;
  }

  int getSize(String str) {
    Offset? pos = posToOffset(str);
    if (pos != null && logicBoard[pos.dy.floor()][pos.dx.floor()].isNotEmpty) {
      return logicBoard[pos.dy.floor()][pos.dx.floor()][0].size;
    }
    return -1;
  }


  // [a-m] constants     [n-z] variables
  for (int i=logicTxt.length-1; i>=0; i--) {
    if (logicTxt[i].codeUnitAt(0) >= 97 && logicTxt[i].codeUnitAt(0) <= 109 && logicTxt.substring((i-1).clamp(0, i), (i+2).clamp(0, logicTxt.length)).replaceAll(RegExp(r'[a-zA-Z]'), '').length==logicTxt.substring((i-1).clamp(0, i), (i+2).clamp(0, logicTxt.length)).length-1) {
      Offset? offset = idToOffest(logicTxt[i]);
      if (!offset.isNull) {
        logicTxt = logicTxt.replaceRange(i, i+1, '${offset!.dx}:${offset.dy}');
      } else {
        return 'error2 ${logicTxt[i]}';
      }
    }
  }
  debugPrint(logicTxt);

  // Function evaluation
  while (logicTxt.contains(RegExp(r'\b[a-z]+\(\d+:\d+\)'))) {
    var match = RegExp(r'\b[a-z]+\(\d+:\d+\)').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      switch (substr!.replaceAll(RegExp(r'[^a-z]'), '')) {
        case 'lm':
          logicTxt = logicTxt.replaceAll(substr, lm(substr.replaceAll(RegExp(r'[a-z\(\)]'), '')));   // !\d+:\d+
          break;
        case 'rm':
          logicTxt = logicTxt.replaceAll(substr, rm(substr.replaceAll(RegExp(r'[a-z\(\)]'), '')));
          break;
        case 'fm':
          logicTxt = logicTxt.replaceAll(substr, fm(substr.replaceAll(RegExp(r'[a-z\(\)]'), '')));
          break;
        case 'bm':
          logicTxt = logicTxt.replaceAll(substr, bm(substr.replaceAll(RegExp(r'[a-z\(\)]'), '')));
          break;
        default:
        return 'error1 ${substr.replaceAll(RegExp(r'[^a-z]'), '')}';
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  // = sign evaluation
  while (logicTxt.contains(RegExp(r'\d+:\d+=\d+:\d+'))) {
    var match = RegExp(r'\d+:\d+=\d+:\d+').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      if (substr!.split('=')[0]==substr.split('=')[1]) {
        logicTxt = logicTxt.replaceAll(substr, '⊤');
      } else {
        logicTxt = logicTxt.replaceAll(substr, '⊥');
      }
    }
    debugPrint('Substep:         $logicTxt');
  }
  // ≠ sign evaluation
  while (logicTxt.contains(RegExp(r'\d+:\d+≠\d+:\d+'))) {
    var match = RegExp(r'\d+:\d+≠\d+:\d+').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      if (!(substr!.split('=')[0]==substr.split('≠')[1])) {
        logicTxt = logicTxt.replaceAll(substr, '⊤');
      } else {
        logicTxt = logicTxt.replaceAll(substr, '⊥');
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  // evaluation of predicates with one parameter
  while (logicTxt.contains(RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\)'))) {
    var match = RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\)').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      switch (substr!.replaceAll(RegExp(r'[\d:\(\)]'), '')) {
        case 'Tet':
          if (getSides(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 3) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Cube':
          if (getSides(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 4) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Dodec':
          if (getSides(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 5) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Small':
          if (getSize(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 0) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Medium':
          if (getSize(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 1) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Large':
          if (getSize(substr.replaceAll(RegExp(r'[a-zA-Z\(\)]'), '')) == 2) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        default:
        return 'error3 ${substr.replaceAll(RegExp(r'[\d:\(\)]'), '')}';
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  // evaluation of predicates with one parameter
  while (logicTxt.contains(RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\,\d+:\d+\)'))) {
    var match = RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\,\d+:\d+\)').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      var positions = RegExp(r'\d+:\d+').allMatches(substr!);
      switch (substr.replaceAll(RegExp(r'[\d:\(\),]'), '')) {
        case 'SameShape':
          if (getSides(positions.elementAt(0)[0]!) == getSides(positions.elementAt(1)[0]!)) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'SameSize':
          if (getSize(positions.elementAt(0)[0]!) == getSize(positions.elementAt(1)[0]!)) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'LeftOf':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[0]) < int.parse(positions.elementAt(0)[0]!.split(':')[1])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'RightOf':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[0]) > int.parse(positions.elementAt(1)[0]!.split(':')[0])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'FrontOf':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[1]) > int.parse(positions.elementAt(1)[0]!.split(':')[1])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'BackOf':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[1]) < int.parse(positions.elementAt(1)[0]!.split(':')[1])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'SameRow':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[1]) == int.parse(positions.elementAt(1)[0]!.split(':')[1])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'SameCol':
          if (int.parse(positions.elementAt(0)[0]!.split(':')[0]) == int.parse(positions.elementAt(1)[0]!.split(':')[0])) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Adjoins':
          if (
            ((int.parse(positions.elementAt(0)[0]!.split(':')[0]) == int.parse(positions.elementAt(1)[0]!.split(':')[0])+1)
            ^ (int.parse(positions.elementAt(0)[0]!.split(':')[0]) == int.parse(positions.elementAt(1)[0]!.split(':')[0])-1))
            ^ ((int.parse(positions.elementAt(0)[0]!.split(':')[1]) == int.parse(positions.elementAt(1)[0]!.split(':')[1])+1)
            ^ (int.parse(positions.elementAt(0)[0]!.split(':')[1]) == int.parse(positions.elementAt(1)[0]!.split(':')[1])-1))
          ) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Smaller':
          if (getSize(positions.elementAt(0)[0]!) < getSize(positions.elementAt(1)[0]!)) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        case 'Larger':
          if (getSize(positions.elementAt(0)[0]!) > getSize(positions.elementAt(1)[0]!)) {
            logicTxt = logicTxt.replaceAll(substr, '⊤');
          } else {
            logicTxt = logicTxt.replaceAll(substr, '⊥');
          }
          break;
        default:
        return 'error3 ${substr.replaceAll(RegExp(r'[\d:\(\),]'), '')}';
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  while (logicTxt.contains(RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\,\d+:\d+\,\d+:\d+\)'))) {
    var match = RegExp(r'[A-Z][a-zA-Z]+\(\d+:\d+\,\d+:\d+\,\d+:\d+\)').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      var positions = RegExp(r'\d+:\d+').allMatches(substr!);
      switch (substr.replaceAll(RegExp(r'[\d:\(\),]'), '')) {
        case 'Between':
          if (
            ((int.parse(positions.elementAt(0)[0]!.split(':')[0]) > int.parse(positions.elementAt(1)[0]!.split(':')[0])
            && int.parse(positions.elementAt(0)[0]!.split(':')[0]) < int.parse(positions.elementAt(2)[0]!.split(':')[0]))
            ^ (int.parse(positions.elementAt(0)[0]!.split(':')[0]) < int.parse(positions.elementAt(1)[0]!.split(':')[0])
            && int.parse(positions.elementAt(0)[0]!.split(':')[0]) > int.parse(positions.elementAt(2)[0]!.split(':')[0]))
            && int.parse(positions.elementAt(0)[0]!.split(':')[1]) == int.parse(positions.elementAt(1)[0]!.split(':')[1])
            && int.parse(positions.elementAt(0)[0]!.split(':')[1]) == int.parse(positions.elementAt(2)[0]!.split(':')[1]))
            ^ ((int.parse(positions.elementAt(0)[0]!.split(':')[1]) > int.parse(positions.elementAt(1)[0]!.split(':')[1])
            && int.parse(positions.elementAt(0)[0]!.split(':')[1]) < int.parse(positions.elementAt(2)[0]!.split(':')[1]))
            ^ (int.parse(positions.elementAt(0)[0]!.split(':')[1]) < int.parse(positions.elementAt(1)[0]!.split(':')[1])
            && int.parse(positions.elementAt(0)[0]!.split(':')[1]) > int.parse(positions.elementAt(2)[0]!.split(':')[1]))
            && int.parse(positions.elementAt(0)[0]!.split(':')[0]) == int.parse(positions.elementAt(1)[0]!.split(':')[0])
            && int.parse(positions.elementAt(0)[0]!.split(':')[0]) == int.parse(positions.elementAt(2)[0]!.split(':')[0]))
          ) {
              logicTxt = logicTxt.replaceAll(substr, '⊤');
            } else {
              logicTxt = logicTxt.replaceAll(substr, '⊥');
            }
          break;
        default:
        return 'error3 ${substr.replaceAll(RegExp(r'[\d:\(\),]'), '')}';
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  // Solving of brackets ()
  while (logicTxt.contains(RegExp(r'([^a-zA-Z]|^)\(((\d+:\d+\,*)+|⊥|⊤)\)'))) {
    var match = RegExp(r'([^a-zA-Z]|^)\(((\d+:\d+\,*)+|⊥|⊤)\)').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      if (substr![0] == '(') {
        print('case 1 ((...)');
        logicTxt = logicTxt.replaceAll(substr, substr.substring(1, substr.length-1));
      } else {
        print('case 2 ?(...)');
        logicTxt = logicTxt.replaceAll(substr, substr[0]+substr.substring(2, substr.length-1));
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  // Solving logic operators ∨ ∧ → ↔ ¬
  if (logicTxt.contains(RegExp(r'[⊤⊥][∨∧→↔][⊤⊥]|¬[⊤⊥]'))) {
    var match = RegExp(r'[⊤⊥][∨∧→↔][⊤⊥]|¬[⊤⊥]').firstMatch(logicTxt);
    if (!match.isNull) {
      String? substr = match![0];
      if (substr!.contains(RegExp(r'⊤∨⊤|⊤∨⊥|⊥∨⊤|⊤∧⊤|⊤→⊤|⊥→⊤|⊥→⊥|⊤↔⊤|⊥↔⊥|¬⊥'))) {
        logicTxt = logicTxt.replaceFirst(substr, '⊤');
      } else {
        logicTxt = logicTxt.replaceFirst(substr, '⊥');
      }
    }
    debugPrint('Substep:         $logicTxt');
  }

  if (inputLength == logicTxt.length) {
    debugPrint('Result:          $logicTxt');
    if (logicTxt.length==1) {
      return logicTxt;
    } else {
      return 'error0';
    }
  } else {
    debugPrint('---   Next Iteration   ---');
    return checkLogicTxt(logicTxt, logicBoard);
  }
  

  // return '⊤';
  // return '⊥';
  // return 'error0';    // Failed to parrse 'formmulaBegin'.
  // return 'error1';    // Function 'rl' not found in the signature
  // return 'error2';    // The constant symbol [a] is not assigned to this world
  // return 'error3';    // Predicate 'Smaler' not found in the signature
}