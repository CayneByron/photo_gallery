import 'package:flutter/material.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_album.dart';
import 'package:local_image_provider/device_image.dart';

class AlbumsListWidget extends StatelessWidget {
  const AlbumsListWidget({
    Key key,
    this.localImages,
    this.localAlbums,
    this.switchAlbum,
    this.selectedAlbum,
  }) : super(key: key);

  final List<LocalImage> localImages;
  final List<LocalAlbum> localAlbums;
  final void Function(LocalAlbum album) switchAlbum;
  final LocalAlbum selectedAlbum;

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
                itemCount: localAlbums.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      switchAlbum(localAlbums[index]);
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
                                      image: DeviceImage(localAlbums[index].coverImg, scale: localAlbums[index].coverImg.scaleToFit(487, 451)),
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                localAlbums[index].title,
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