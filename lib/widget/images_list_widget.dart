import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_gallery/modals/modal_fit.dart';


class ImagesListWidget extends StatelessWidget {
  const ImagesListWidget({
    Key key,
    this.album,
    this.switchAlbum,
    this.images,
    this.assetList,
    this.scaffoldKey,
  }) : super(key: key);

  final AssetPathEntity album;
  final Map images;
  final List<AssetEntity> assetList;
  final scaffoldKey;
  final void Function(AssetPathEntity album) switchAlbum;

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
                          AssetEntity entity = assetList[index];
                          if (entity.type == AssetType.image) {
                            Uint8List fullSizedImage = await entity.originBytes;
                            Navigator.pushNamed(context, '/view', arguments: {
                              'assetList': assetList,
                              'image': fullSizedImage,
                              'entity': entity,
                            });
                          } else if (entity.type == AssetType.video) {
                            Navigator.pushNamed(context, '/view_video', arguments: {
                              'entity': entity,
                            });
                          }
                        },
                        onLongPress: () async {
                          Uint8List image = await this.assetList[index].thumbData;
                          showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ModalFit(
                              album: this.album,
                              switchAlbum: this.switchAlbum,
                              image: image,
                              asset: this.assetList[index],
                              scaffoldKey: this.scaffoldKey,
                            ),
                          );
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
                                    color: Colors.transparent,
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
                                          color: Colors.black,
                                          size: 38.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 36.0,
                                        ),
                                      ),
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
