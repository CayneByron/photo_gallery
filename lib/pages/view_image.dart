import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_manager/photo_manager.dart';

class FullSizeImage extends StatefulWidget {
  @override
  _FullSizeImageState createState() => _FullSizeImageState();
}

class _FullSizeImageState extends State<FullSizeImage> {
  Map data = {};
  int selectedIndex = 0;
  double swipeXStart = 0.0;
  double swipeXEnd = 0.0;
  PhotoViewController photoController;
  PhotoViewScaleStateController scaleStateController;
  bool isShowingUI = false;
  List<AssetEntity> assetList = [];
  Uint8List image;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    isShowingUI = false;
  }


  void listener(PhotoViewControllerValue value) {
    print('LISTENER: $value');
  }

  void nextSlide() async {
    double difference = swipeXEnd - swipeXStart;
    int nextIndex = 0;
    String route = '/view';
    if (difference > 0) {
      nextIndex = selectedIndex - 1;
      route = '/view_left';
    } else if (difference < 0) {
      nextIndex = selectedIndex + 1;
      route = '/view_right';
    }
    if (nextIndex >= assetList.length || nextIndex < 0 || scaleStateController.scaleState != PhotoViewScaleState.initial) {
      return;
    }

    AssetEntity entity = assetList[nextIndex];
    Uint8List nextImage = await entity.originBytes;

    Navigator.pushReplacementNamed(context, route,
        arguments: {
          'assetList': assetList,
          'image': nextImage,
          'selectedIndex': nextIndex,
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    assetList = data['assetList'];
    assetList = assetList.where((i) => i.type == AssetType.image).toList();
    image = data['image'];
    selectedIndex = data['selectedIndex'];
    photoController = PhotoViewController()..outputStateStream.listen(listener);

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (isShowingUI) {
                    isShowingUI = false;
                    SystemChrome.setEnabledSystemUIOverlays([]);
                  } else {
                    isShowingUI = true;
                    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                  }
                },
                onHorizontalDragStart: (DragStartDetails details) {
                  swipeXStart = details.localPosition.dx;
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  swipeXEnd = details.localPosition.dx;
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  nextSlide();
                },
                child: PhotoView(
                  imageProvider: MemoryImage(image),
                  scaleStateController: scaleStateController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
