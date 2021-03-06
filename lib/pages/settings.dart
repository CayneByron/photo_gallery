import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/image_sort_order.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:photo_gallery/pages/album_sort_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String albumSortOrder = '';
  String imageSortOrder = '';

  @override
  void initState() {

    super.initState();
    fillSettings();

  }

  void fillSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    albumSortOrder = prefs.getString('albumSortOrder');
    if (albumSortOrder?.isEmpty ?? true) {
      albumSortOrder = AlbumSortOrder.ALBUM_NAME_ASC;
      prefs.setString('albumSortOrder', albumSortOrder);
    }
    imageSortOrder = prefs.getString('imageSortOrder');
    if (imageSortOrder?.isEmpty ?? true) {
      imageSortOrder = ImageSortOrder.IMAGE_DATE_DESC;
      prefs.setString('imageSortOrder', imageSortOrder);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Settings',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            title: '',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: 'Album Sort Order',
                subtitle: albumSortOrder,
                leading: Icon(Icons.photo_album),
                onTap: () {
                  Navigator.pushNamed(context, '/albumSortOrder').then((value) => fillSettings());
                },
              ),
              SettingsTile(
                title: 'Image Sort Order',
                subtitle: imageSortOrder,
                leading: Icon(Icons.photo),
                onTap: () {
                  Navigator.pushNamed(context, '/imageSortOrder').then((value) => fillSettings());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
