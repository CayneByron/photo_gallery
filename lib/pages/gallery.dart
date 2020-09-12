import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_image_provider/local_image_provider.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_album.dart';
import 'package:photo_gallery/Widget/albums_list_widget.dart';
import 'package:photo_gallery/Widget/images_list_widget.dart';

class Gallery extends StatefulWidget {
@override
_GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;

  LocalImageProvider localImageProvider = LocalImageProvider();
  List<LocalImage> localImages = [];
  List<LocalAlbum> localAlbums = [];
  LocalImage selectedImg;
  LocalAlbum selectedAlbum;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool hasPermission = false;
    List<LocalImage> images = [];
    List<LocalAlbum> albums = [];

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      hasPermission = await localImageProvider.hasPermission;
      if (hasPermission) {
        print('Already granted, initialize will not ask');
      }
      hasPermission = await localImageProvider.initialize();
      if (hasPermission) {
        await localImageProvider.cleanup();
        albums = await localImageProvider.findAlbums(LocalAlbumType.all);
      }
    } on PlatformException catch (e) {
      print('Local image provider failed: $e');
    }

    if (!mounted) return;

    setState(() {
      localImages.addAll(images);
      localImages.sort((a, b) => a.creationDate.compareTo(b.creationDate));
      localAlbums.addAll(albums);
      localAlbums.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void switchAlbum(LocalAlbum album) async {
    List<LocalImage> albumImages =
    await localImageProvider.findImagesInAlbum(album.id, 10000);
    setState(() {
      localImages.clear();
      localImages.addAll(albumImages);
      selectedAlbum = album;
    });
    switchImage(album.coverImg, 'Album');
  }

  void switchImage(LocalImage image, String src) {
    setState(() {
      selectedImg = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: SafeArea(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlbumsListWidget(
                localImages: localImages,
                localAlbums: localAlbums,
                switchAlbum: switchAlbum,
                selectedAlbum: selectedAlbum,
              ),
              ImagesListWidget(
                localImages: localImages,
                switchImage: switchImage,
                selectedImage: selectedImg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
