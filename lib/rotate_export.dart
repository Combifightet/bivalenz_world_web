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
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(constraints.maxWidth, 0, constraints.maxWidth+100*uiScale, 100*uiScale),
                        items: [
                          PopupMenuItem(
                            child: ValueListenableBuilder(
                              valueListenable: themeMode,
                              builder: (BuildContext context, ThemeMode value, Widget? child) {
                                return SwitchListTile(
                                  value: value==ThemeMode.dark,
                                  title: Text('dark mode'),
                                  onChanged: null,
                                );
                              }
                            ),
                            onTap: () {
                              setState(() {
                                if (themeMode.value==ThemeMode.dark) {
                                  themeMode.value = ThemeMode.light;
                                } else {
                                  themeMode.value = ThemeMode.dark;
                                }
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Text('Import files'),
                            onTap: () => print('TODO: implement file import'),
                          ),
                        ]
                      );
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