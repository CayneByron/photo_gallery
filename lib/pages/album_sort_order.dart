import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumSortOrder extends StatefulWidget {
  static const String ALBUM_NAME_ASC = 'Album name ascending';
  static const String ALBUM_NAME_DESC = 'Album name descending';

  @override
  _AlbumSortOrderState createState() => _AlbumSortOrderState();
}

class _AlbumSortOrderState extends State<AlbumSortOrder> {
  String sortLabel = AlbumSortOrder.ALBUM_NAME_ASC;

  @override
  void initState() {
    super.initState();
    setPreference();
  }

  void setPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String albumSortOrder = prefs.getString('albumSortOrder');
    if (albumSortOrder.isNotEmpty) {
      sortLabel = albumSortOrder;
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
        title: Text('Album Sort Order',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: AlbumSortOrder.ALBUM_NAME_ASC,
              trailing: trailingWidget(AlbumSortOrder.ALBUM_NAME_ASC),
              onTap: () {
                setAlbumSortOrder(AlbumSortOrder.ALBUM_NAME_ASC);
              },
            ),
            SettingsTile(
              title: AlbumSortOrder.ALBUM_NAME_DESC,
              trailing: trailingWidget(AlbumSortOrder.ALBUM_NAME_DESC),
              onTap: () {
                setAlbumSortOrder(AlbumSortOrder.ALBUM_NAME_DESC);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(String label) {
    return (sortLabel == label)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void setAlbumSortOrder(String label) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('albumSortOrder', label);
    setState(() {
      sortLabel = label;
    });
  }
}