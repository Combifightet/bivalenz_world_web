import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';

class ObjectButtons extends StatefulWidget {
  const ObjectButtons({super.key});

  @override
  State<ObjectButtons> createState() => _ObjectButtonsState();
}





//    a     b      c      d      e      f
//   tet   cube  dodec  small  medium large

class _ObjectButtonsState extends State<ObjectButtons> {
  List<Widget> buttons = [];
  
  @override
  void initState() {
    super.initState();

    for (String chr in ['a','b','c','d','e','f']) {
      buttons.add(
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
                borderRadius: BorderRadius.circular(5*uiScale),
              )
            ),
          ),
          child: Text(
            chr,
            style: TextStyle(
              fontSize: 28*uiScale
            ),
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24*uiScale),
      child: GridView.count(
        crossAxisCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4*uiScale,
        crossAxisSpacing: 4*uiScale,
        children: buttons,
      ),
    );
  }
}