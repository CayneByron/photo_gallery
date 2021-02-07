import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;

class MoveFolder extends StatefulWidget {
  @override
  _MoveFolderState createState() => _MoveFolderState();
}

class _MoveFolderState extends State<MoveFolder> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController fileNameController = new TextEditingController();
  Map data = {};
  List<AssetEntity> assetList = [];
  Uint8List image;
  File file;
  AssetEntity entity;
  List<AssetPathEntity> albumList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    image = data['image'];
    file = data['file'];
    entity = data['entity'];
    albumList = data['albumList'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Move File')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(
          children: [
            ListView.builder(
              itemCount: albumList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index)  {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 4.0
                  ),
                  child: Card(
                    child: ListTile(
                      onTap: () async {
                        print('Found ${albumList[index]}');
                        print('old id: ' + entity.id);
                        AssetEntity copy = await PhotoManager.editor.copyAssetToPath(asset: entity, pathEntity: albumList[index]);
                        print(copy);
                        if (copy == null) {
                          final snackBar = SnackBar(
                            content: Text('Cannot move asset to ${albumList[index].name}'),
                            backgroundColor: Colors.red[600],
                            action: SnackBarAction(
                              label: 'Error',
                              onPressed: () {},
                            ),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        } else {
                          print('new id: ' + copy.id);
                          File file = await entity.file;
                          await file.delete();
                          Navigator.pop(context, copy.id);
                        }
                      },
                      title: Text(albumList[index].name),
                      leading: Icon(Icons.local_shipping),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}