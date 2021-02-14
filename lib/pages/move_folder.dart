import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';


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
  bool isMove = true;
  String title = 'Move File';

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
    isMove = data['isMove'];
    title = (isMove ? 'Move File' : 'Copy File');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(title)),
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
                        AssetEntity copy = await PhotoManager.editor.copyAssetToPath(asset: entity, pathEntity: albumList[index]);
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
                          if (isMove) {
                            File file = await entity.file;
                            await file.delete();
                          }
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