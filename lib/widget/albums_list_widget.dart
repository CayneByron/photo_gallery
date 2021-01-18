import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

import 'dart:async';
import 'package:async/async.dart';


class AlbumsListWidget extends StatelessWidget {
  const AlbumsListWidget({
    Key key,
    this.switchAlbum,
    this.albumList,
    this.thumbnails,
  }) : super(key: key);

  final void Function(AssetPathEntity album) switchAlbum;
  final List<AssetPathEntity> albumList;
  final Map thumbnails;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Theme.of(context).canvasColor,
              padding: EdgeInsets.all(0),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                  height: 0,
                ),
                itemCount: albumList.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      switchAlbum(albumList[index]);
                    },
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: MemoryImage(thumbnails[albumList[index].name], scale: 1.0),
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                albumList[index].name,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),
        ],
      ),
    );
  }
}