import 'dart:ffi';

import 'package:flutter/material.dart';

import 'grid_snap.dart';



class LogicObj {
  final List<Char> id;
  final Offset pos;
  final int size;
  final int sides;    // shape

  const LogicObj({
    required this.id,
    required this.pos,
    this.size = 1,
    this.sides = 4,
  });
}

class LogicBoard {
  List<List<List<LogicObj>>> board = [
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []],
  [[], [], [], [], [], [], [], []]];

  void addObj(LogicObj logicObj) {
    if(board[logicObj.pos.dx.floor()][logicObj.pos.dy.floor()].isEmpty) {
      board[logicObj.pos.dx.floor()][logicObj.pos.dy.floor()].add(logicObj);
    }
  }
}