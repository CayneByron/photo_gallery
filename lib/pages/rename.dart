import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

class Rename extends StatefulWidget {
  @override
  _RenameState createState() => _RenameState();
}

class _RenameState extends State<Rename> {
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
    entity = data['entity'];
    TextEditingController renameController = new TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Rename File')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(
          children: [
            Card(
              child: TextField(
                controller: renameController,
                decoration: InputDecoration(
                  hintText: 'New File Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                File file = await entity.file;
                String dir = path.dirname(file.path);
                String extension = path.extension(file.path);
                String newPath = path.join(dir, renameController.text + extension);
                if (await File(newPath).exists()) {
                  final snackBar = SnackBar(
                    content: Text('Filename already in use'),
                    backgroundColor: Colors.red[600],
                    action: SnackBarAction(
                      label: 'Error',
                      onPressed: () {},
                    ),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }
                try {
                  file.copySync(newPath);
                  Navigator.pop(context);
                } catch(e) {
                  final snackBar = SnackBar(
                    content: Text(e.errMsg()),
                    backgroundColor: Colors.red[600],
                    action: SnackBarAction(
                      label: 'Error',
                      onPressed: () {},
                    ),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }

              },
              child: new Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}