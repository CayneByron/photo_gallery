import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:mdi/mdi.dart';



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

  MdiIconData getAlphaIcon(String letter) {
    switch(letter) {
      case "A": {  return Mdi.alphaACircleOutline; }
      break;

      case "B": {  return Mdi.alphaBCircleOutline; }
      break;

      case "C": {  return Mdi.alphaCCircleOutline; }
      break;

      case "D": { return Mdi.alphaDCircleOutline; }
      break;

      case "E": { return Mdi.alphaECircleOutline; }
      break;

      case "F": { return Mdi.alphaFCircleOutline; }
      break;

      case "G": { return Mdi.alphaGCircleOutline; }
      break;

      case "H": { return Mdi.alphaHCircleOutline; }
      break;

      case "I": { return Mdi.alphaICircleOutline; }
      break;

      case "J": { return Mdi.alphaJCircleOutline; }
      break;

      case "K": { return Mdi.alphaKCircleOutline; }
      break;

      case "L": { return Mdi.alphaLCircleOutline; }
      break;

      case "M": { return Mdi.alphaMCircleOutline; }
      break;

      case "N": { return Mdi.alphaNCircleOutline; }
      break;

      case "O": { return Mdi.alphaOCircleOutline; }
      break;

      case "P": { return Mdi.alphaPCircleOutline; }
      break;

      case "Q": { return Mdi.alphaQCircleOutline; }
      break;

      case "R": { return Mdi.alphaRCircleOutline; }
      break;

      case "S": { return Mdi.alphaSCircleOutline; }
      break;

      case "T": { return Mdi.alphaTCircleOutline; }
      break;

      case "U": { return Mdi.alphaUCircleOutline; }
      break;

      case "V": { return Mdi.alphaVCircleOutline; }
      break;

      case "W": { return Mdi.alphaWCircleOutline; }
      break;

      case "X": { return Mdi.alphaXCircleOutline; }
      break;

      case "Y": { return Mdi.alphaYCircleOutline; }
      break;

      case "Z": { return Mdi.alphaZCircleOutline; }
      break;

      default: { return Mdi.helpCircle; }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    image = data['image'];
    file = data['file'];
    entity = data['entity'];
    albumList = data['albumList'];
    albumList.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
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
                      leading: Icon(getAlphaIcon(albumList[index].name.toUpperCase()[0])),
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