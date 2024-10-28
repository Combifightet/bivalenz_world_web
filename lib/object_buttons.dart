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
  State<ObjectButtons> createState() => ObjectButtonsState();
}





//    a     b      c      d      e      f
//   tet   cube  dodec  small  medium large

class ObjectButtonsState extends State<ObjectButtons> {
  double uiScale = 1;

  void refresh() => setState(() {});
    
  void _addConst(String chr) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        if (folWorlds[folWorldIndex].getWorld()[index].hasConst(chr)) {
          folWorlds[folWorldIndex].getWorld()[index].removeConst(chr);
        } else if (!folWorlds[folWorldIndex].getConsts().contains(chr)) {
          folWorlds[folWorldIndex].getWorld()[index].addConst(chr);
        }
      }
    }
    refresh();
  }

  void _createObj(ObjectType type) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        if (folWorlds[folWorldIndex].getWorld()[index].type==type) {
          folWorlds[folWorldIndex].clear(selectedTile!.dx.round(), selectedTile!.dy.round());
        } else {
          folWorlds[folWorldIndex].getWorld()[index].type=type;
        }
      } else {
        folWorlds[folWorldIndex].createObj(selectedTile!.dx.round(), selectedTile!.dy.round(), type, ObjectSize.Medium);
      }
    }
    refresh();
  }

  void _modifySize(ObjectSize size) {
    if (selectedTile!=null) {
      int index = folWorlds[folWorldIndex].getWorld().indexWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round());
      if (index>=0) {
        folWorlds[folWorldIndex].getWorld()[index].size=size;
      }
    }
    refresh();
  }

  List<Widget> buttons1(double uiScale) {
    List<Widget> buttons = [];

    for (String chr in ['a','b','c','d','e','f']) {
      buttons.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*uiScale),
            child: ElevatedButton(
              onPressed: folWorlds[folWorldIndex].getConsts().contains(chr)
              && (selectedTile==null || !folWorlds[folWorldIndex].getWorld().firstWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round(), orElse: () => LogicObj(-1, -1, ObjectType.Cube, ObjectSize.Medium)).getConsts().contains(chr))
                ? null
                : () => _addConst(chr),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*uiScale),
                  )
                ),
                backgroundColor: selectedTile==null || !folWorlds[folWorldIndex].getWorld().firstWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round(), orElse: () => LogicObj(-1, -1, ObjectType.Cube, ObjectSize.Medium)).getConsts().contains(chr)
                  ? null
                  : WidgetStatePropertyAll(
                    Color.alphaBlend(
                      Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                      Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!,
                    )
                  ),
              ),
              child: Text(
                chr,
                style: TextStyle(
                  fontSize: 42*uiScale
                ),
              )
            ),
          ),
        )
      );
    }
    return buttons;
  }

  List<Widget> buttons2(double uiScale) {
    List<Widget> buttons = [];
    for (ObjectType type in [ObjectType.Cube, ObjectType.Tet, ObjectType.Dodec]) {
      buttons.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*uiScale),
            child: ElevatedButton(
              onPressed: () => _createObj(type),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*uiScale),
                  )
                ),
                backgroundColor: selectedTile==null || !(folWorlds[folWorldIndex].getWorld().any((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round()) && folWorlds[folWorldIndex].getWorld().firstWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round()).type==type)
                  ? null
                  : WidgetStatePropertyAll(
                    Color.alphaBlend(
                      Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                      Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!,
                    )
                  ),
              ),
              child: type==ObjectType.Tet
                ? Transform.rotate(
                    angle: -90*pi/180,
                    child: Icon(Icons.play_arrow_rounded, color: redAccentColor, size: 56*uiScale)
                  )
                : type==ObjectType.Cube
                  ? Icon(Icons.square_rounded, color: blueAccentColor, size: 56*uiScale)
                  : Icon(Icons.pentagon_rounded, color: yellowAccentColor, size: 56*uiScale),
            ),
          ),
        )
      );
    }
    for (ObjectSize size in [ObjectSize.Small, ObjectSize.Medium, ObjectSize.Large]) {
      buttons.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2*uiScale),
            child: ElevatedButton(
              onPressed: () => _modifySize(size),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5*uiScale),
                  )
                ),
                backgroundColor: selectedTile==null || !(folWorlds[folWorldIndex].getWorld().any((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round()) && folWorlds[folWorldIndex].getWorld().firstWhere((obj) => obj.getX()==selectedTile!.dx.round() && obj.getY()==selectedTile!.dy.round()).size==size)
                  ? null
                  : WidgetStatePropertyAll(
                    Color.alphaBlend(
                      Theme.of(context).elevatedButtonTheme.style!.overlayColor!.resolve({WidgetState.pressed})!,
                      Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({WidgetState.pressed})!,
                    )
                  ),
              ),
              child: Icon(
                Icons.circle_rounded,
                size: (size.index+2)*14*uiScale,
              )
            ),
          ),
        )
      );
    }
    return buttons;
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6/2,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          uiScale = min(constraints.maxHeight, constraints.maxWidth/3)/130;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buttons1(uiScale),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buttons2(uiScale),
                ),
              )
            ],
          );
        }
      )
    );
  }
}