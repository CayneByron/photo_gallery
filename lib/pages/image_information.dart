import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:settings_ui/settings_ui.dart';

class ImageInformation extends StatefulWidget {
  @override
  _ImageInformationState createState() => _ImageInformationState();
}

class _ImageInformationState extends State<ImageInformation> {
  Map data = {};
  List<AssetEntity> assetList = [];
  Uint8List image;
  File file;
  AssetEntity entity;

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
    entity = data['entity'];

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
            Expanded(
              flex: 3,
              child: SettingsList(
                // backgroundColor: Colors.orange,
                sections: [
                  SettingsSection(
                    title: '',
                    // titleTextStyle: TextStyle(fontSize: 30),
                    tiles: [
                      SettingsTile(
                        title: 'Title',
                        subtitle: entity.title,
                        leading: Icon(Icons.language),
                        onTap: () async {
                          List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList();
                          albumList.sort((a, b) => a.name.compareTo(b.name));
                          Navigator.pushNamed(context, '/rename', arguments: {
                            'image': image,
                            'file': file,
                            'entity': entity,
                            'albumList': albumList
                          }).then((value) => {});
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
                  // SettingsSection(
                  //   title: 'File',
                  //   tiles: [
                  //     SettingsTile(
                  //       title: 'Type',
                  //       subtitle: file.runtimeType.toString(),
                  //       leading: Icon(Icons.language),
                  //       onTap: () {
                  //       },
                  //     ),
                  //     SettingsTile(
                  //       title: 'URI',
                  //       subtitle: file.uri.toString(),
                  //       leading: Icon(Icons.language),
                  //       onTap: () {
                  //       },
                  //     ),
                  //     SettingsTile(
                  //       title: 'Path',
                  //       subtitle: file.path,
                  //       leading: Icon(Icons.language),
                  //       onTap: () {
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
