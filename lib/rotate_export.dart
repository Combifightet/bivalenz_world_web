import 'package:bivalenz_world_web/theme.dart';
import 'package:flutter/material.dart';

class RotateExport extends StatefulWidget {
  const RotateExport({super.key});

  @override
  State<RotateExport> createState() => _RotateExportState();
}

class _RotateExportState extends State<RotateExport> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8*uiScale),
      child: Column(
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
                    size: 28*uiScale,
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
                    size: 28*uiScale,
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}