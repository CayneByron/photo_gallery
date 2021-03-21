import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:settings_ui/settings_ui.dart';

class ImageInformation extends StatefulWidget {
  @override
  _ImageInformationState createState() => _ImageInformationState();
}

class _ImageInformationState extends State<ImageInformation> {
  Map data = {};
  Uint8List image;
  File file;
  AssetEntity entity;
  AssetPathEntity currentAlbum;
  String title = '';
  String folder = '';
  String id = '';

  @override
  void initState() {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Details',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
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
