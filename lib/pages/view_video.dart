import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';

class ViewVideo extends StatefulWidget {
  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  Map data = {};
  VideoPlayerController videoController;
  bool done = false;
  PhotoViewScaleStateController scaleStateController;
  bool isShowingUI = false;
  AssetEntity entity;
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    isShowingUI = false;
  }

  @override
  void dispose() {
    super.dispose();
    scaleStateController.dispose();
    if (videoController != null) {
      videoController.dispose();
    }
  }

  Future<FlickVideoPlayer> setupVideo() async {
    File videoFile = await entity.file;//File(videoPath);
    if (videoFile.existsSync()) {
      print("The file does exist");
    } else {
      print("No such file");
      return null;
    }
    videoController = VideoPlayerController.file(videoFile);
    await videoController.initialize();
    flickManager = FlickManager(
      videoPlayerController: videoController,
    );
    FlickVideoPlayer fvp = FlickVideoPlayer(
        flickManager: flickManager
    );

    return fvp;
  }

  void listener(PhotoViewControllerValue value) {
    print('LISTENER: $value');
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    entity = data['entity'];

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: FutureBuilder(
                  future: setupVideo(),
                  builder: (BuildContext context, AsyncSnapshot<FlickVideoPlayer> vp) {
                    if (vp.hasData) {
                      videoController.play();
                      return Wrap(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: AspectRatio(
                                  aspectRatio: videoController.value.aspectRatio,
                                  child: vp.data,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
