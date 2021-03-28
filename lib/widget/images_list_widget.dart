import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_gallery/modals/modal_fit.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  List<StaggeredTile> getStaggeredTiles() {
    List<StaggeredTile> staggeredTiles = <StaggeredTile>[];
    staggeredTiles.add(StaggeredTile.count(4, 0.5));
    for (int i = 0; i < images.length; i++) {
      staggeredTiles.add(StaggeredTile.count(2, 3));
    }
    return staggeredTiles;
  }

  List<Widget> getTiles(BuildContext context) {
    List<Widget> prefix = <Widget>[];
    prefix.add(Text(album != null ? album.name : '',
      style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 24.0
      ),
    ));
    List<Widget> gallery = List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () async {
          AssetEntity entity = assetList[index];
          if (entity.type == AssetType.image) {
            Uint8List image = await entity.thumbData;
            Navigator.pushNamed(context, '/view', arguments: {
              'assetList': assetList,
              'image': image,
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
          child: AspectRatio(
            aspectRatio: 100 / 141,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
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
                          Icons.circle,
                          color: Color(0x66000000),
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
      );
    });
    return List.from(prefix)..addAll(gallery);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController semicircleController = ScrollController();
    semicircleController.addListener(() {
      if (semicircleController.offset >= semicircleController.position.maxScrollExtent &&
          !semicircleController.position.outOfRange) {
      }
      if (semicircleController.offset <= semicircleController.position.minScrollExtent &&
          !semicircleController.position.outOfRange) {
      }
    });

    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DraggableScrollbar.semicircle(
                    controller: semicircleController,
                    child: StaggeredGridView.count(
                      controller: semicircleController,
                      crossAxisCount: 4,
                      staggeredTiles: getStaggeredTiles(),
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 8.0,
                      children: getTiles(context),
                    ),
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