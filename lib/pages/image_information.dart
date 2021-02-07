import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:path/path.dart' as path;

class ImageInformation extends StatefulWidget {
  @override
  _ImageInformationState createState() => _ImageInformationState();
}

class _ImageInformationState extends State<ImageInformation> {
  Map data = {};
  // List<AssetEntity> assetList = [];
  Uint8List image;
  File file;
  AssetEntity entity;
  AssetPathEntity currentAlbum;
  String title = '';
  String folder = '';
  String id = '';

  @override
  void initState() {
    print('IMAGE INFORMATION');
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    image = data['image'];
    file = data['file'];
    currentAlbum = data['currentAlbum'];
    entity = (entity == null) ? data['entity'] : entity;

    void updateInfo() async {
      List<AssetPathEntity> tempAlbumList = await PhotoManager.getAssetPathList();
      for (AssetPathEntity album in tempAlbumList) {
        if (album.name == entity.relativePath.split("/")[entity.relativePath.split("/").length-2]) {
          List<AssetEntity> newAssetList = await album.assetList;
          for (AssetEntity newAsset in newAssetList) {
            if (newAsset.id == entity.id) {
              setState(() {
                entity = newAsset;
              });
            }
          }
        }
      }
    }

    void foo(Object value) async {
      print('foo');
      print(value);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Image.memory(image),
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  child: new Text('Move'),
                  onPressed: () async {
                    List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList();
                    albumList.sort((a, b) => a.name.compareTo(b.name));
                    albumList.remove(currentAlbum);
                    final newId = await Navigator.pushNamed(context, '/move', arguments: {
                      'image': image,
                      'file': file,
                      'entity': entity,
                      'albumList': albumList
                    });
                    print('result:');
                    print(newId);
                    List<AssetPathEntity> tempAlbumList = await PhotoManager.getAssetPathList();
                    for (AssetPathEntity album in tempAlbumList) {
                      List<AssetEntity> newAssetList = await album.assetList;
                      for (AssetEntity newAsset in newAssetList) {
                        if (newAsset.id == newId) {
                          setState(() {
                            entity = newAsset;
                          });
                        }
                      }
                    }
                  },
                ),
                RaisedButton(
                  child: new Text('Rename'),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/rename', arguments: {
                      'entity': entity,
                    }).then((value) => updateInfo());
                  },
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: SettingsList(
                sections: [
                  SettingsSection(
                    title: '',
                    tiles: [
                      SettingsTile(
                        title: 'Title',
                        subtitle: entity.title,
                        leading: Icon(Icons.language),
                        onTap: () async {

                        },
                      ),
                      SettingsTile(
                        title: 'Folder',
                        subtitle: entity.relativePath.split("/")[entity.relativePath.split("/").length-2],
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Id',
                        subtitle: entity.id,
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Size',
                        subtitle: entity.size.width.floor().toString() + 'x' + entity.size.height.floor().toString() + ' pixels',
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Created Date',
                        subtitle: entity.createDateTime.toIso8601String().replaceAll('T', ' '),
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Last Modified Date',
                        subtitle: entity.modifiedDateTime.toIso8601String().replaceAll('T', ' '),
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Path',
                        subtitle: entity.relativePath,
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                      SettingsTile(
                        title: 'Type',
                        subtitle: entity.type.toString(),
                        leading: Icon(Icons.language),
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
