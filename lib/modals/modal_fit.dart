import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:mime/mime.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({
    Key key,
    this.album,
    this.switchAlbum,
    this.asset,
    this.scaffoldKey,
    this.image,
  }) : super(key: key);

  final AssetPathEntity album;
  final Uint8List image;
  final AssetEntity asset;
  final scaffoldKey;
  final void Function(AssetPathEntity album) switchAlbum;

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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.none,
                      image: MemoryImage(image)
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Details'),
                leading: Icon(Icons.info),
                onTap: () async {
                  AssetEntity entity = asset;
                  Uint8List fullSizedImage = await entity.originBytes;
                  File file = await entity.file;
                  // File originFile = await entity.originFile;
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
                  AssetEntity entity = asset;
                  Uint8List fullSizedImage = await entity.originBytes;
                  File file = await entity.file;
                  await Navigator.pushNamed(context, '/move', arguments: {
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
                  AssetEntity entity = asset;
                  File file = await entity.file;
                  Uint8List fullSizedImage = await entity.originBytes;
                  await Navigator.pushNamed(context, '/move', arguments: {
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
              Visibility(
                visible: (asset.type == AssetType.image),
                child: ListTile(
                    title: Text('Crop'),
                    leading: Icon(Icons.crop),
                    onTap: () async {
                      print('trying to crop');
                      AssetEntity entity = asset;
                      File imageFile = await entity.file;
                      File croppedFile = await ImageCropper.cropImage(
                          sourcePath: imageFile.path,
                          aspectRatioPresets: Platform.isAndroid
                              ? [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ]
                              : [
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio5x3,
                            CropAspectRatioPreset.ratio5x4,
                            CropAspectRatioPreset.ratio7x5,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          androidUiSettings: AndroidUiSettings(
                              toolbarTitle: 'Cropper',
                              toolbarColor: Colors.deepOrange,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false),
                          iosUiSettings: IOSUiSettings(
                            title: 'Cropper',
                          ));
                      if (croppedFile != null) {
                        imageFile.writeAsBytesSync(croppedFile.readAsBytesSync());
                      }
                      loadAll();
                      Navigator.of(context).pop();
                    }
                ),
              ),
              ListTile(
                title: Text('Share'),
                leading: Icon(Icons.share),
                onTap: () async {
                  try {
                    print(lookupMimeType(asset.relativePath + '/' + asset.title));
                    await Share.file('esys image', 'esys.png', image, lookupMimeType(asset.relativePath + '/' + asset.title));
                  } catch (e) {
                    print('error: $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Delete'),
                leading: Icon(Icons.delete),
                onTap: () async {
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
                      AssetEntity entity = asset;
                      File file = await entity.file;
                      await file.delete();
                      loadAll();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                  AlertDialog alert = AlertDialog(
                    title: Text("Delete"),
                    content: Text("Are you sure you want to delete? Action cannot be undone."),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
                // onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ));
  }
}