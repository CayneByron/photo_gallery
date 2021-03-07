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
              color: Colors.white,//Theme.of(context).canvasColor,
              padding: EdgeInsets.all(0),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                  height: 0,
                ),
                itemCount: albumList.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () async {
                      switchAlbum(albumList[index]);
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        child: AspectRatio(
                          aspectRatio: 487 / 700,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.topCenter,
                                      image: MemoryImage(thumbnails[albumList[index].name], scale: 1.0),
                                    )
                                ),
                              ),
                              Container(
                                height: 350.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.white.withOpacity(0.0),
                                          Colors.black.withOpacity(0.5),
                                        ],
                                        stops: [
                                          0.0,
                                          1.0
                                        ]
                                    ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(albumList[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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