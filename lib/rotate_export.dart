import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';

class RotateExport extends StatefulWidget {

  const RotateExport({
    super.key,
  });

  @override
  State<RotateExport> createState() => _RotateExportState();
}

class _RotateExportState extends State<RotateExport> {
  double uiScale = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        uiScale = min(constraints.maxHeight/3, constraints.maxWidth)/60;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(6*uiScale),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement import export menue
                      print('open import / export menue');
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5*uiScale),
                        )
                      ),
                    ),
                    child: Icon(Icons.menu_outlined,
                      size: 24*uiScale,
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(2*uiScale),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedTile!=null) {
                        double x = (folWorldSize-1).floorToDouble()/2;
                        double y = (folWorldSize-1).floorToDouble()/2;
                        selectedTile = Offset(
                          (selectedTile!.dy-y+x).floorToDouble(),
                          (-selectedTile!.dx+x+y).floorToDouble()
                        );
                      }
                      folWorlds[folWorldIndex].rotateCCW(folWorldSize/2-0.5, folWorldSize/2-0.5);
                      setState(() {
                        if (folWorldSize%2==0) {
                          invertBoard = !invertBoard;
                        }
                      });
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5*uiScale),
                        )
                      ),
                    ),
                    child: Icon(
                      Icons.rotate_90_degrees_ccw_outlined,
                      size: 32*uiScale,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(2*uiScale),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedTile!=null) {
                        double x = (folWorldSize-1).floorToDouble()/2;
                        double y = (folWorldSize-1).floorToDouble()/2;
                        selectedTile = Offset(
                          (-selectedTile!.dy+y+x).floorToDouble(),
                          (selectedTile!.dx-x+y).floorToDouble()
                        );
                      }
                      folWorlds[folWorldIndex].rotateCW(folWorldSize/2-0.5, folWorldSize/2-0.5);
                      setState(() {
                        if (folWorldSize%2==0) {
                          invertBoard = !invertBoard;
                        }
                      });
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5*uiScale),
                        )
                      ),
                    ),
                    child: Icon(Icons.rotate_90_degrees_cw_outlined,
                      size: 32*uiScale,
                    )
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}