import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_gallery/pages/image_sort_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_gallery/Widget/albums_list_widget.dart';
import 'package:photo_gallery/Widget/images_list_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_gallery/pages/album_sort_order.dart';

import 'package:flutter/cupertino.dart';

class Gallery extends StatefulWidget {
@override
_GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String title = 'Photo Gallery';

  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  Map thumbnailsMap = new Map();
  Map imagesMap = new Map();
  AssetPathEntity selectedAlbum;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    PhotoManager.forceOldApi();
    loadAll();
  }

  void loadAll() async {
    List<AssetPathEntity> tempAlbumList = await PhotoManager.getAssetPathList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String albumSortOrder = prefs.getString('albumSortOrder');
    String selectedAlbumName = prefs.getString('selectedAlbum') ?? '';
    tempAlbumList = sortAlbums(tempAlbumList, albumSortOrder);

    for (AssetPathEntity album in tempAlbumList) {
      if (album.isAll) {
        continue;
      }
      albumList.add(album);
      assetList = await album.assetList;
      Uint8List img = await assetList[0].thumbDataWithSize(100, 100);
      thumbnailsMap[album.name] = img;
      if (album.name == selectedAlbumName) {
        selectedAlbum = album;
      }
    }
    if (selectedAlbum != null) {
      switchAlbum(selectedAlbum);
    }
    applySettings();
  }

  void switchAlbum(AssetPathEntity album) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    List<AssetPathEntity> tempAlbumList = await PhotoManager.getAssetPathList();
    for (AssetPathEntity tempAlbum in tempAlbumList) {
      if (tempAlbum.id == album.id) {
        album = tempAlbum;
      }
    }

    album.getAssetListRange(start: 0, end: album.assetCount).then((value) {
      if (value.isEmpty) {
        return;
      }
      if (mounted) {
        return;
      }
    });

    title = album.name;
    imagesMap.clear();
    assetList.clear();
    assetList = await album.assetList;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageSortOrder = prefs.getString('imageSortOrder');
    selectedAlbum = album;
    prefs.setString('selectedAlbum', selectedAlbum.name);
    assetList = sortAssetList(assetList, imageSortOrder);
    for (AssetEntity asset in assetList) {
      if (asset.type == AssetType.audio || asset.type == AssetType.other) {
        continue;
      }
      Uint8List img = await asset.thumbDataWithSize(100, 100);
      imagesMap[asset.title] = img;
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  List<AssetPathEntity> sortAlbums(List<AssetPathEntity> albumList, String albumSortOrder) {
    if (albumSortOrder == AlbumSortOrder.ALBUM_NAME_ASC) {
      albumList.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    } else {
      albumList.sort((a, b) => b.name.toUpperCase().compareTo(a.name.toUpperCase()));
    }

    return albumList;
  }

  List<AssetEntity> sortAssetList(List<AssetEntity> assetList, String imageSortOrder) {
    if (imageSortOrder == ImageSortOrder.IMAGE_TITLE_ASC) {
      assetList.sort((a, b) => a.title.toUpperCase().compareTo(b.title));
    } else if (imageSortOrder == ImageSortOrder.IMAGE_TITLE_DESC) {
      assetList.sort((a, b) => b.title.toUpperCase().compareTo(a.title.toUpperCase()));
    } else if (imageSortOrder == ImageSortOrder.IMAGE_DATE_ASC) {
      assetList.sort((a, b) => a.modifiedDateTime.compareTo(b.modifiedDateTime));
    } else if (imageSortOrder == ImageSortOrder.IMAGE_DATE_DESC) {
      assetList.sort((a, b) => b.modifiedDateTime.compareTo(a.modifiedDateTime));
    }

    return assetList;
  }

  void applySettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String albumSortOrder = prefs.getString('albumSortOrder');
    if (albumSortOrder?.isEmpty ?? true) {
      albumSortOrder = AlbumSortOrder.ALBUM_NAME_ASC;
    }
    sortAlbums(albumList, albumSortOrder);
    String imageSortOrder = prefs.getString('imageSortOrder');
    if (imageSortOrder?.isEmpty ?? true) {
      imageSortOrder = ImageSortOrder.IMAGE_DATE_DESC;
    }
    assetList = sortAssetList(assetList, imageSortOrder);
    print('apply settings');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        actions: [
          Visibility(
            visible: isLoading,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 20.0,
                )
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/settings').then((value) => applySettings());
                },
                child: Icon(
                    Icons.settings
                ),
              )
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlbumsListWidget(
                switchAlbum: switchAlbum,
                albumList: albumList,
                thumbnails: thumbnailsMap,
              ),
              ImagesListWidget(
                album: selectedAlbum,
                switchAlbum: switchAlbum,
                images: imagesMap,
                assetList: assetList,
                scaffoldKey: _scaffoldKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
