import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

class ObjectButtons extends StatefulWidget {
  final double uiScale;
  final void Function() boardRefresher;

  const ObjectButtons({
    super.key,
    required this.boardRefresher,
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
  
  @override
  void initState() {
    super.initState();

    for (String chr in ['a','b','c','d','e','f']) {
      buttons1.add(
        ElevatedButton(
          onPressed: () {
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
          },
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
        )
      );
    }
    for (ObjectType type in [ObjectType.Tet, ObjectType.Cube, ObjectType.Dodec]) {
      buttons2.add(
        ElevatedButton(
          onPressed: () {
            if (selectedTile!=null) {
              int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
              if (index>=0) {
                folWorlds[folWorldIndex].getWorld()[index].type=type;
              } else {
                folWorlds[folWorldIndex].createObj(selectedTile!.dx.round(), selectedTile!.dy.round(), type, ObjectSize.Medium);
              }
            }
          },
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
        )
      );
    }
    for (ObjectSize size in [ObjectSize.Small, ObjectSize.Medium, ObjectSize.Large]) {
      buttons2.add(
        ElevatedButton(
          onPressed: () {
            if (selectedTile!=null) {
              int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
              if (index>=0) {
                folWorlds[folWorldIndex].getWorld()[index].size=size;
                // widget.boardRefresher;   // TODO doesn't work 
              }
            }
          },
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
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24*widget.uiScale*0),  // TODO: fix this so hat it doesnt overflow
      child: AspectRatio(
        aspectRatio: 6/2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buttons1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buttons2,
            )
          ],
        )
        // child: GridView.count(
        //   crossAxisCount: 6,
        //   physics: const NeverScrollableScrollPhysics(),
        //   mainAxisSpacing: 4*widget.uiScale,
        //   crossAxisSpacing: 4*widget.uiScale,
        //   children: buttons,
        // ),
      ),
    );
  }
}