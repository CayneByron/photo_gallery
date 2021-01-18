import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/album_sort_order.dart';
import 'package:photo_gallery/pages/image_information.dart';
import 'package:photo_gallery/pages/image_sort_order.dart';
import 'package:photo_gallery/pages/gallery.dart';
import 'package:photo_gallery/pages/view_image.dart';
import 'package:photo_gallery/pages/move_folder.dart';
import 'package:photo_gallery/pages/settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_gallery/pages/view_video.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  onGenerateRoute: (settings) {
    switch (settings.name) {
      case '/view_left':
        return PageTransition(child: FullSizeImage(), type: PageTransitionType.leftToRightWithFade, settings: settings,);
        break;
      case '/view_right':
        return PageTransition(child: FullSizeImage(), type: PageTransitionType.rightToLeftWithFade, settings: settings,);
        break;
      default:
        return null;
    }
  },
  routes: {
    '/': (context) => Gallery(),
    '/view': (context) => FullSizeImage(),
    '/view_video': (context) => ViewVideo(),
    '/info': (context) => ImageInformation(),
    '/settings': (context) => Settings(),
    '/albumSortOrder': (context) => AlbumSortOrder(),
    '/imageSortOrder': (context) => ImageSortOrder(),
    '/rename': (context) => MoveFolder(),
  },
));