import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/gallery.dart';
import 'package:photo_gallery/pages/full_size_image.dart';
import 'package:page_transition/page_transition.dart';

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
  },
));