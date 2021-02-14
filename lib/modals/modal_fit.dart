import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'dart:typed_data';

class ModalFit extends StatelessWidget {
  const ModalFit({
    Key key,
    this.album,
    this.switchAlbum,
    this.images,
    this.assetList,
    this.scaffoldKey,
    this.index,
  }) : super(key: key);

  final AssetPathEntity album;
  final Map images;
  final List<AssetEntity> assetList;
  final scaffoldKey;
  final void Function(AssetPathEntity album) switchAlbum;
  final int index;

  void loadAll() async {
    switchAlbum(album);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Details'),
                leading: Icon(Icons.info),
                onTap: () async {
                  AssetEntity entity = assetList[index];
                  Uint8List fullSizedImage = await entity.originBytes;
                  File file = await entity.file;
                  File originFile = await entity.originFile;
                  Navigator.pushNamed(context, '/info', arguments: {
                    'image': fullSizedImage,
                    'file': file,
                    'currentAlbum': album,
                    'entity': entity,
                  }).then((value) => loadAll());
                },
              ),
              ListTile(
                title: Text('Move'),
                leading: Icon(Icons.content_copy),
                onTap: () async {
                  List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList();
                  albumList.sort((a, b) => a.name.compareTo(b.name));
                  albumList.remove(album);
                  AssetEntity entity = assetList[index];
                  Uint8List fullSizedImage = await entity.originBytes;
                  File file = await entity.file;
                  final newId = await Navigator.pushNamed(context, '/move', arguments: {
                    'image': fullSizedImage,
                    'file': file,
                    'entity': entity,
                    'albumList': albumList,
                    'isMove': true,
                  });
                  loadAll();
                  Navigator.of(context).pop();
                }
              ),
              ListTile(
                title: Text('Copy'),
                leading: Icon(Icons.folder_open),
                onTap: () async {
                  List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList();
                  albumList.sort((a, b) => a.name.compareTo(b.name));
                  albumList.remove(album);
                  AssetEntity entity = assetList[index];
                  Uint8List fullSizedImage = await entity.originBytes;
                  File file = await entity.file;
                  final newId = await Navigator.pushNamed(context, '/move', arguments: {
                    'image': fullSizedImage,
                    'file': file,
                    'entity': entity,
                    'albumList': albumList,
                    'isMove': false,
                  });
                  loadAll();
                  Navigator.of(context).pop();
                }
              ),
              ListTile(
                title: Text('Delete'),
                leading: Icon(Icons.delete),
                onTap: () async {
                  // set up the buttons
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed:  () {
                      loadAll();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Continue"),
                    onPressed:  () async {
                      AssetEntity entity = assetList[index];
                      File file = await entity.file;
                      await file.delete();
                      loadAll();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("AlertDialog"),
                    content: Text("Are you sure? Delete action cannot be undone."),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
                // onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ));
  }
}