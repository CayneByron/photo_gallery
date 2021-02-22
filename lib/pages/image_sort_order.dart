import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageSortOrder extends StatefulWidget {
  static const String IMAGE_TITLE_ASC = 'Image title ascending';
  static const String IMAGE_TITLE_DESC = 'Image title descending';
  static const String IMAGE_DATE_ASC = 'Image date ascending';
  static const String IMAGE_DATE_DESC = 'Image date descending';

  @override
  _ImageSortOrderState createState() => _ImageSortOrderState();
}

class _ImageSortOrderState extends State<ImageSortOrder> {
  String sortLabel = ImageSortOrder.IMAGE_DATE_DESC;

  @override
  void initState() {
    super.initState();
    setPreference();
  }

  void setPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageSortOrder = prefs.getString('imageSortOrder');
    print('GET imageSortOrder: ' + imageSortOrder);
    if (imageSortOrder.isNotEmpty) {
      sortLabel = imageSortOrder;
    } else {
      sortLabel = ImageSortOrder.IMAGE_DATE_DESC;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Sort Order')),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: ImageSortOrder.IMAGE_TITLE_ASC,
              trailing: trailingWidget(ImageSortOrder.IMAGE_TITLE_ASC),
              onTap: () {
                setAlbumSortOrder(ImageSortOrder.IMAGE_TITLE_ASC);
              },
            ),
            SettingsTile(
              title: ImageSortOrder.IMAGE_TITLE_DESC,
              trailing: trailingWidget(ImageSortOrder.IMAGE_TITLE_DESC),
              onTap: () {
                setAlbumSortOrder(ImageSortOrder.IMAGE_TITLE_DESC);
              },
            ),
            SettingsTile(
              title: ImageSortOrder.IMAGE_DATE_ASC,
              trailing: trailingWidget(ImageSortOrder.IMAGE_DATE_ASC),
              onTap: () {
                setAlbumSortOrder(ImageSortOrder.IMAGE_DATE_ASC);
              },
            ),
            SettingsTile(
              title: ImageSortOrder.IMAGE_DATE_DESC,
              trailing: trailingWidget(ImageSortOrder.IMAGE_DATE_DESC),
              onTap: () {
                setAlbumSortOrder(ImageSortOrder.IMAGE_DATE_DESC);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(String label) {
    print('trailingWidget label: ' + label);
    print('trailingWidget sortLabel: ' + sortLabel);
    return (sortLabel == label)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void setAlbumSortOrder(String label) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imageSortOrder', label);
    setState(() {
      sortLabel = label;
    });
  }
}