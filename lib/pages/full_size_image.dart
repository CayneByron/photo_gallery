import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class FullSizeImage extends StatefulWidget {
  @override
  _FullSizeImageState createState() => _FullSizeImageState();
}

class _FullSizeImageState extends State<FullSizeImage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map data = {};
  int desiredHeight;
  int desiredWidth;
  VideoPlayerController videoController;
  bool done = false;
  List<LocalImage> localImages;
  int currentIndex = 0;
  int selectedIndex = 0;
  double swipeXStart = 0.0;
  double swipeXEnd = 0.0;
  PhotoViewController photoController;
  double scaleCopy;
  PhotoViewScaleStateController scaleStateController;
  bool isShowingUI = false;
  double currentPercentage = 0.0;
  int pageCount = 0;
  int selectedRadio = 0;
  Timer timer;

  @override
  void initState() {
    print('initState');
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    isShowingUI = false;
    pageCount++;
  }

  @override
  void dispose() {
    super.dispose();
    scaleStateController.dispose();
    if (videoController != null) {
      videoController.dispose();
    }
  }

  Future<VideoPlayer> setupVideo() async {
    print('setupVideo');
    String videoPath =
        await LocalImageProvider().videoFile(localImages[selectedIndex].id);
    print(videoPath);
    File videoFile = File(videoPath);
    if (videoFile.existsSync()) {
      print("The file does exist");
    } else {
      print("No such file");
      return null;
    }
    videoController = VideoPlayerController.file(videoFile);
    await videoController.initialize();
    videoController.addListener(onVideoChange);
    VideoPlayer vp = VideoPlayer(videoController);
    return vp;
  }

  void onVideoChange() async {
//    if (await videoController.position >= videoController.value.duration) {
//      done = true;
//    }
    return;
  }

  void listener(PhotoViewControllerValue value) {
    print('LISTENER: $value');
  }

  void nextSlide() {
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
    if (nextIndex >= localImages.length ||
        nextIndex < 0 ||
        scaleStateController.scaleState !=
            PhotoViewScaleState.initial) {
      return;
    }

    Navigator.pushReplacementNamed(context, route,
        arguments: {
          'localImages': localImages,
          'selectedIndex': nextIndex,
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD ');
    print('pageCount: $pageCount');
    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    });

    setState(() {});

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    localImages = data['localImages'];
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
              child: localImages[selectedIndex].isVideo
                  ? Center(
                      child: FutureBuilder(
                          future: setupVideo(),
                          builder: (BuildContext context,
                              AsyncSnapshot<VideoPlayer> vp) {
                            if (vp.hasData) {
                              videoController.play();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onHorizontalDragStart: (DragStartDetails details) {
                                      swipeXStart = details.localPosition.dx;
                                    },
                                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                                      swipeXEnd = details.localPosition.dx;
                                    },
                                    onHorizontalDragEnd: (DragEndDetails details) {
                                      if (!videoController.value.isPlaying) {
                                        nextSlide();
                                      }
                                    },
                                    onTap: () async {
                                      if (videoController.value.isPlaying) {
                                        videoController.pause();
                                      } else {
                                        videoController.play();
                                      }
                                    },
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio:
                                            videoController.value.aspectRatio,
                                        child: vp.data,
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: videoController,
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      //Do Something with the value.
                                      return GestureDetector(
                                        onTapUp: (TapUpDetails details) async {
                                          double totalWidth = MediaQuery.of(context).size.width;
                                          double desiredPercent = details.globalPosition.dx / totalWidth;
                                          int milliseconds = (videoController.value.duration.inMilliseconds * desiredPercent).floor();
                                          videoController.seekTo(Duration(milliseconds: milliseconds ));
                                        },
                                        child: LinearProgressIndicator(
                                          minHeight: 5.0,
                                          value: value.position.inMilliseconds /
                                              value.duration.inMilliseconds,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                              //return vp.data;  // image is ready
                            } else {
                              return new Container(); // placeholder
                            }
                          }),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (isShowingUI) {
                          isShowingUI = false;
                          SystemChrome.setEnabledSystemUIOverlays([]);
                        } else {
                          isShowingUI = true;
                          SystemChrome.setEnabledSystemUIOverlays(
                              SystemUiOverlay.values);
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
                        imageProvider:
                            DeviceImage(localImages[selectedIndex], scale: 1),
                        scaleStateController: scaleStateController,
                        //controller: photoController,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
