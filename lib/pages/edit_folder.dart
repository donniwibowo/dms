import 'dart:convert';

import 'package:best_flutter_ui_templates/pages/recent_page.dart';
import 'package:best_flutter_ui_templates/pages/shared_folders_page.dart';
import 'package:best_flutter_ui_templates/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import '../design_storage/design_app_theme.dart';
import '../design_storage/recent_activities_list_view.dart';
import '../design_storage/recent_files_list_view.dart';
import '../design_storage/shared_folders_list_view.dart';
import 'package:http/http.dart' as http;

class EditFolder extends StatefulWidget {
  final String folder_parent_id;
  final String folder_id;
  final String name;
  final String description;

  EditFolder(
      {required this.folder_parent_id,
      required this.folder_id,
      required this.name,
      required this.description});
  @override
  _EditFolderState createState() => _EditFolderState();
}

class _EditFolderState extends State<EditFolder> {
  int _selectedIndex = 0;
  TextEditingController _controller_name = new TextEditingController();
  TextEditingController _controller_description = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller_name.text = widget.name;
    _controller_description.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Container(
      color: DesignAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            TopHeaderEditPage(
              title: 'DMS',
              subtitle: 'Edit Folder',
              folder_id: widget.folder_id,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _controller_name,
                        decoration: new InputDecoration(
                            hintText: "Masukan Nama Folder",
                            labelText: "Nama Folder",
                            icon: Icon(Icons.people)),
                      ),
                      TextFormField(
                        controller: _controller_description,
                        decoration: new InputDecoration(
                            hintText: "Masukan Deskripsi Folder",
                            labelText: "Deskripsi",
                            icon: Icon(Icons.description)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              var user_token =
                                  sharedPreferences.getString("user_token");

                              Map data = {
                                'folder_id': widget.folder_id,
                                'name': _controller_name.text,
                                'description': _controller_description.text
                              };
                              var jsonResponse = null;
                              var response = await http.post(
                                  "http://34.101.208.151/agutask/dms/api/files/editfolder?user_token=" +
                                      user_token!,
                                  body: data);

                              jsonResponse = json.decode(response.body);
                              if (jsonResponse['status'] == 200) {
                                const snackBarMsg = SnackBar(
                                  content: Text("Folder berhasil diubah"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarMsg);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DesignHomeScreen(
                                          folder_parent_id:
                                              widget.folder_parent_id,
                                        )));
                              } else {
                                print(jsonResponse);
                                const snackBarMsg = SnackBar(
                                  content: Text("Gagal mengubah data"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarMsg);
                              }
                            },
                            icon: Icon(
                              // <-- Icon
                              Icons.save,
                              // size: 24.0,
                            ),
                            label: Text('Simpan'), // <-- Text
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              label: 'Shared',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.av_timer),
              label: 'Recent',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DesignHomeScreen(
                  folder_parent_id: "0",
                )));
      } else if (_selectedIndex == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SharedFoldersPage()));
      } else if (_selectedIndex == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RecentPage()));
      }
      print(_selectedIndex);
    });
  }
}
