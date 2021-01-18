import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

class MoveFolder extends StatefulWidget {
  @override
  _MoveFolderState createState() => _MoveFolderState();
}

class _MoveFolderState extends State<MoveFolder> {
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
                        Uint8List bytes = await entity.originBytes;
                        File originFile = await entity.originFile;
                        final newFile = await originFile.copy(originFile.path + 'ZZZZ_abcdefg123456789.jpg');
                        print(newFile.path);
                        // File newFile = await originFile.rename(originFile.path + 'ZZZZ_abcdefg123456789.jpg');
                        // newFile.writeAsBytes(bytes);

                        // bool success = await PhotoManager.editor.android.moveAssetToAnother(entity: entity, target: albumList[index]);
                        // print('success: ' + success.toString());
                        // Navigator.pop(context);
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