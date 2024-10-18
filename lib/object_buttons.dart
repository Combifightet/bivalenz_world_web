import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

class ObjectButtons extends StatefulWidget {
  final double uiScale;

  const ObjectButtons({
    super.key,
    this.uiScale=1,
  });

  @override
  State<ObjectButtons> createState() => _ObjectButtonsState();
}





//    a     b      c      d      e      f
//   tet   cube  dodec  small  medium large

class _ObjectButtonsState extends State<ObjectButtons> {
  List<Widget> buttons1 = [];
  List<Widget> buttons2 = [];
  
  void _addConst(String chr) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        if (folWorlds[folWorldIndex].getWorld()[index].hasConst(chr)) {
          folWorlds[folWorldIndex].getWorld()[index].removeConst(chr);
        } else {
          folWorlds[folWorldIndex].getWorld()[index].addConst(chr);
        }
      }
    }
  }

  void _createObj(ObjectType type) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        folWorlds[folWorldIndex].getWorld()[index].type=type;
      } else {
        folWorlds[folWorldIndex].createObj(selectedTile!.dx.round(), selectedTile!.dy.round(), type, ObjectSize.Medium);
      }
    }
  }

  void _modifySize(ObjectSize size) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        folWorlds[folWorldIndex].getWorld()[index].size=size;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    for (String chr in ['a','b','c','d','e','f']) {
      buttons1.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*widget.uiScale),
            child: ElevatedButton(
              onPressed: () => _addConst(chr),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*widget.uiScale),
                  )
                ),
              ),
              child: Text(
                chr,
                style: TextStyle(
                  fontSize: 42*widget.uiScale
                ),
              )
            ),
          ),
        )
      );
    }
    for (ObjectType type in [ObjectType.Tet, ObjectType.Cube, ObjectType.Dodec]) {
      buttons2.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*widget.uiScale),
            child: ElevatedButton(
              onPressed: () => _createObj(type),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*widget.uiScale),
                  )
                ),
              ),
              child: type==ObjectType.Tet
                ? Transform.rotate(
                    angle: -90*pi/180,
                    child: Icon(Icons.play_arrow_rounded, color: redAccentColor, size: 56*widget.uiScale)
                  )
                : type==ObjectType.Cube
                  ? Icon(Icons.square_rounded, color: blueAccentColor, size: 56*widget.uiScale)
                  : Icon(Icons.pentagon_rounded, color: yellowAccentColor, size: 56*widget.uiScale),
            ),
          ),
        )
      );
    }
    for (ObjectSize size in [ObjectSize.Small, ObjectSize.Medium, ObjectSize.Large]) {
      buttons2.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*widget.uiScale),
            child: ElevatedButton(
              onPressed: () => _modifySize(size),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*widget.uiScale),
                  )
                ),
              ),
              child: Icon(
                Icons.circle_rounded,
                size: (size.index+2)*14*widget.uiScale,
              )
            ),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6/2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons1,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons2,
            ),
          )
        ],
      )
    );
  }
}