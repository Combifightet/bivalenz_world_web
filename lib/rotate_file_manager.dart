import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// this will only be used if <kIsWeb==true>
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'dart:math';

import 'package:logic_expr_tree/logic_expr_tree.dart';

import 'theme.dart';

class RotateFileManager extends StatefulWidget {

  const RotateFileManager({
    super.key,
  });

  @override
  State<RotateFileManager> createState() => _RotateFileManagerState();
}

class _RotateFileManagerState extends State<RotateFileManager> {
  double uiScale = 1;

  bool _isLoading = false;
  Future<void> _importFile() async {
    if (_isLoading) {return;}
    setState(() {
      _isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wld', 'sen'],
        allowMultiple: true
      );
      
      if (result!=null) {
        for (PlatformFile file in result.files) {
          print('reading in file \'${file.name}\'');
          if (file.extension=='wld') {
            folWorlds.add(FileManager().parseWorld(file.bytes!));
            String? path;
            if (!kIsWeb) {
              path = file.path;
              print('path_ "$path"');
            }
            folWorldNames.add(FileData(
              name: file.name.substring(0, file.name.length-4),
              path: path
            ));
            folWorldIndex = folWorlds.length-1;
            boardHandelerKey.currentState?.refresh();
          } else if (file.extension=='sen') {
            folSentences.add([]);
            String? path;
            if (!kIsWeb) {
              path = file.path;
              print('path_ "$path"');
            }
            folSentenceNames.add(FileData(
              name: file.name.substring(0, file.name.length-4),
              path: path
            ));
            for (String sen in FileManager().parseSentence(file.bytes!)) {
              print('Sentence: \'$sen\'');
              folSentences.last.add(
                SentenceTile(
                  key: UniqueKey(),
                  controller: TextEditingController(text: sen),
                )
              );
            }
            folSentenceIndex = folSentences.length-1;
            folScentenceKey.currentState?.refresh();
            sentenceHandelerKey.currentState?.refresh();
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

  void _download(String name, String data) {
    assert(kIsWeb);
    var blob = html.Blob([data], 'text/json', 'native');

    // ignore: unused_local_variable
    var anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
    )..setAttribute("download", name)..click();
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
                  child: MenuAnchor(
                     builder: (context, controller, child) {
                      return ElevatedButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
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
                        child: Icon(Icons.menu_outlined,
                          size: 24*uiScale,
                        )
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {
                          setState(() {
                            if (themeMode.value==ThemeMode.dark) {
                              themeMode.value = ThemeMode.light;
                            } else {
                              themeMode.value = ThemeMode.dark;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Dark mode'),
                            Padding(
                              padding: EdgeInsets.only(left: 12*uiScale),
                              child: Switch(
                                value: themeMode.value==ThemeMode.dark,
                                onChanged: null
                              ),
                            )
                          ],
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () => _importFile(),
                        child: Text('Import files'),
                      ),
                      SubmenuButton(
                        menuChildren: kIsWeb
                          ? [
                            MenuItemButton(
                              onPressed: () => _download(
                                folWorldNames[folWorldIndex]!=null?'${folWorldNames[folWorldIndex]!.name}.wld':'Unsaved World.wld',
                                folWorlds[folWorldIndex].toString(),
                              ),
                              child: Text('Download World'),
                            ),
                            MenuItemButton(
                              onPressed: () => _download(
                                folSentenceNames[folSentenceIndex]!=null?'${folSentenceNames[folWorldIndex]!.name}.sen':'Untitled Sentences.sen',
                                folSentences[folSentenceIndex].toString(),
                              ),
                              child: Text('Download Sentences'),
                            ),
                          ]
                          : [
                            MenuItemButton(
                              onPressed: () => UnimplementedError(),  // TODO: implement these methods
                              child: Text('Save World'),
                            ),
                            MenuItemButton(
                              onPressed: () => UnimplementedError(),  // TODO: implement these methods
                              child: Text('Save World As...'),
                            ),
                            MenuItemButton(
                              onPressed: () => UnimplementedError(),  // TODO: implement these methods
                              child: Text('Save Sentences'),
                            ),
                            MenuItemButton(
                              onPressed: () => UnimplementedError(),  // TODO: implement these methods
                              child: Text('Save Sentences As...'),
                            ),
                          ], 
                        child: Text(kIsWeb?'Download':'Save')
                      ),
                      MenuItemButton(
                        onPressed: () {
                          List<String> sentences = [];
                          for (SentenceTile sen in folSentences[folSentenceIndex]) {
                            sentences.add(sen.controller.text);
                          }
                          debugPrint(folWorlds[folWorldIndex].toPL1(sentences));
                        },
                        child: Text('PL1 Structure View'),
                      ),
                    ],
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
                        folScentenceKey.currentState?.validateAll();
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
                        folScentenceKey.currentState?.validateAll();
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