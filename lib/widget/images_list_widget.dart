import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:export_video_frame/export_video_frame.dart';

class ImagesListWidget extends StatelessWidget {
  const ImagesListWidget({
    Key key,
    this.localImages,
    this.switchImage,
    this.selectedImage,
  }) : super(key: key);

  final List<LocalImage> localImages;
  final void Function(LocalImage image, String src) switchImage;
  final LocalImage selectedImage;

  Future<Image> getVideoThumbnail(int index) async {
    if (!localImages[index].isVideo) {
      return null;
    }
    String videoPath = await LocalImageProvider().videoFile(localImages[index].id);
    print(videoPath);
    File videoFile = File(videoPath);
    if (!videoFile.existsSync()) {
      print("Thumbnail: No such file");
      return null;
    }

    print("Thumbnail: The file does exist");
    var file = videoFile; //await ImagePicker.pickVideo(source: ImageSource.gallery);
    var duration = Duration(seconds: 1);
    File image = await ExportVideoFrame.exportImageBySeconds(file, duration, 0);
    return Image.file(image);
  }

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
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(localImages.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, '/view', arguments: {
                            'localImages': localImages,
                            'selectedIndex': index,
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
                                  child: localImages[index].isImage ? Image(
                                      image: DeviceImage(localImages[index], scale: localImages[index].scaleToFit(200, 200)),
                                      fit: BoxFit.fitWidth,
                                  ) : Stack(
                                    children: [
                                      Container(
                                        decoration: new BoxDecoration(color: Colors.white),
                                        alignment: Alignment.center,
                                        child: FutureBuilder(
                                          future: getVideoThumbnail(index),
                                          builder: (BuildContext context, AsyncSnapshot<Image> image) {
                                            if (image.hasData) {
                                              return image.data;  // image is ready
                                            } else {
                                              return new Container();  // placeholder
                                            }
                                          },
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.play_arrow,
                                            color: Colors.white,
                                            size: 40.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
