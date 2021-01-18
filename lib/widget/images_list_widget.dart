import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagesListWidget extends StatelessWidget {
  const ImagesListWidget({
    Key key,
    this.images,
    this.assetList,
  }) : super(key: key);

  final Map images;
  final List<AssetEntity> assetList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Theme.of(context).canvasColor,
              padding: EdgeInsets.all(0),
              child: Card(
                elevation: 5.0,
                child: Scrollbar(
                  isAlwaysShown: false,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(images.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          print('tap');
                          AssetEntity entity = assetList[index];
                          if (entity.type == AssetType.image) {
                            Uint8List fullSizedImage = await entity.originBytes;
                            Navigator.pushNamed(context, '/view', arguments: {
                              'assetList': assetList,
                              'image': fullSizedImage,
                              'selectedIndex': index,
                            });
                          } else if (entity.type == AssetType.video) {
                            Navigator.pushNamed(context, '/view_video', arguments: {
                              'entity': entity,
                            });
                          }
                        },
                        onLongPress: () async {
                          AssetEntity entity = assetList[index];
                          Uint8List fullSizedImage = await entity.originBytes;
                          File file = await entity.file;
                          Navigator.pushNamed(context, '/info', arguments: {
                            'image': fullSizedImage,
                            'file': file,
                            'entity': entity,
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: assetList[index].type == AssetType.image ? Image(
                                      image: MemoryImage(images[assetList[index].title]),
                                      fit: BoxFit.cover,
                                  ) : assetList[index].type == AssetType.video ? Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image(
                                        image: MemoryImage(images[assetList[index].title]),
                                        fit: BoxFit.cover,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 38.0,
                                        ),
                                      )
                                    ],
                                  ) : null
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
