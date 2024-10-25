import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:bivalenz_world_web/theme.dart';
import 'package:logic_expr_tree/logic_expr_tree.dart';


class RotateImport extends StatefulWidget {

  const RotateImport({
    super.key,
  });

  @override
  State<RotateImport> createState() => _RotateImportState();
}

class _RotateImportState extends State<RotateImport> {
  double uiScale = 1;

  bool _isLoading = false;
  Future<void> _importFile() async {
    print('_importFile()');
    if (_isLoading) {return;}
    setState(() {
      _isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wld', 'sen'],
      );
      
      if (result!=null) {
        String jsonString = Utf8Decoder().convert(result.files.first.bytes!);
        final dynamic jsonData = json.decode(jsonString);
        print(result.files.first.name);
        print(result.files.first.extension);
        // print(jsonString);
        print(jsonData[0]);
        if (result.files[0].extension=='wld') {
          FolWorld world = FolWorld();
          for(dynamic wld in jsonData) {
            world.createObj(
              wld['Tags'][0],
              wld['Tags'][1],
              wld['Predicates'][0]=='Tet'
                ? ObjectType.Tet
                : wld['Predicates'][0]=='Cube'
                  ? ObjectType.Cube
                  : ObjectType.Dodec,
              wld['Predicates'][1]=='Small'
                ? ObjectSize.Small
                : wld['Predicates'][1]=='Medium'
                  ? ObjectSize.Medium
                  : ObjectSize.Large,
              wld['Consts']
            );
          }
          print(world);
        } else if (result.files[0].extension=='sen') {
          for (String sen in jsonData) {
            print('Sentence: \'$sen\'');
          }
        }
      }
    } on Exception catch (e) {
      print('Error picking file: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                            onTap: () {
                              print('TODO: implement file import');
                              _importFile();
                            },
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