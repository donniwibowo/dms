import 'dart:convert';

import 'package:best_flutter_ui_templates/design_storage/models/user.dart';
import 'package:best_flutter_ui_templates/helpers/constants.dart';
import 'package:best_flutter_ui_templates/helpers/create_options.dart';
import 'package:best_flutter_ui_templates/multiple_search_selection.dart';
import 'package:best_flutter_ui_templates/pages/recent_page.dart';
import 'package:best_flutter_ui_templates/pages/shared_folders_page.dart';
import 'package:best_flutter_ui_templates/provider/api_user.dart';
import 'package:best_flutter_ui_templates/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import '../design_storage/design_app_theme.dart';
import '../design_storage/recent_activities_list_view.dart';
import '../design_storage/recent_files_list_view.dart';
import '../design_storage/shared_folders_list_view.dart';
import 'package:http/http.dart' as http;

class ManageUser extends StatefulWidget {
  final String name;
  final String file_id;
  final String folder_parent_id;

  ManageUser(
      {required this.name, this.file_id = "0", this.folder_parent_id = "0"});
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<MultiSelectItem<String>> userList = [];
  ApiUser serviceAPI = ApiUser();
  late Future<List<UserModel>> listUserAccess;

  Future<void> getUserList(String folder_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final response = await http.get(Uri.parse(
        'https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/getuseraccessbyfolder?user_token=' +
            user_token +
            '&folder_id=' +
            folder_id));
    final jsonResponse = json.decode(response.body);
    final List<dynamic> itemList = jsonResponse['users'];
    userList = itemList
        .map((data) =>
            MultiSelectItem<String>(data['user_id'], data['fullname']))
        .toList();
  }

  String selectedRole = "view";
  List<DropdownMenuItem<String>> get getRoleList {
    List<DropdownMenuItem<String>> roleList = [
      DropdownMenuItem(child: Text("View"), value: "view"),
      DropdownMenuItem(child: Text("Edit"), value: "edit"),
    ];
    return roleList;
  }

  @override
  void initState() {
    super.initState();

    getUserList(widget.folder_parent_id);
    listUserAccess = serviceAPI.getUserAccessByFile(widget.file_id);
  }

  void reloadData() {
    setState(() {
      listUserAccess = serviceAPI.getUserAccessByFile(widget.file_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    List<String>? selectedUser = [];

    setState(() {
      getUserList(widget.folder_parent_id);
    });

    return Container(
      color: DesignAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          distance: 60,
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          closeButtonStyle: const ExpandableFabCloseButtonStyle(
            backgroundColor: Colors.red,
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.folder_outlined),
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.file_upload),
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            TopHeader(
              title: 'DMS',
              subtitle: 'User Akses',
              folder_id: widget.file_id,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 18, right: 18),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Manage User Access'),
                                ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      var user_token = sharedPreferences
                                          .getString("user_token");

                                      Map data = {
                                        'folder_id': widget.file_id,
                                        'role': selectedRole,
                                        'users': selectedUser.toString()
                                      };
                                      var jsonResponse = null;
                                      var response = await http.post(
                                          "https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/manageuseraccess?user_token=" +
                                              user_token!,
                                          body: data);

                                      jsonResponse = json.decode(response.body);
                                      reloadData();
                                      setState(() {
                                        selectedUser = [];
                                      });
                                    },
                                    child: Text("Send"))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DecoratedBox(
                                decoration: BoxDecoration(
                                  // color: Colors
                                  //     .grey, //background color of dropdown button
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                ), //border of dropdown button

                                child: Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: DropdownButton(
                                      value: selectedRole,
                                      items: getRoleList,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedRole = newValue!;
                                          print(newValue);
                                        });
                                      },
                                      icon: Padding(
                                          //Icon at tail, arrow bottom is default icon
                                          padding: EdgeInsets.only(left: 20),
                                          child: Icon(
                                            Icons.arrow_circle_down_sharp,
                                            color: Colors.black,
                                          )),
                                      iconEnabledColor:
                                          Colors.white, //Icon color
                                      style: TextStyle(
                                          //te
                                          color: Colors.black, //Font color
                                          fontSize:
                                              18 //font size on dropdown button
                                          ),

                                      // dropdownColor: Colors
                                      //     .redAccent, //dropdown background color
                                      underline: Container(), //remove underline
                                      isExpanded:
                                          true, //make true to make width 100%
                                    )))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: FutureBuilder(
                            // future: listUser,
                            builder: (context, snapshot) {
                          return MultiSelectDialogField(
                            buttonIcon: Icon(Icons.people),
                            title: Text("Pilih User"),
                            buttonText: Text(
                              "User",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            items: userList,
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (values) {
                              selectedUser = values.cast<String>();
                            },
                          );
                        }),
                      ),
                      Container(
                        child: FutureBuilder<List<UserModel>>(
                            future: listUserAccess,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Container(
                                  padding: EdgeInsets.only(left: 18, top: 15),
                                  child: Text("Please wait.."),
                                );
                              }
                              if (snapshot.hasError) {
                                return Container(
                                  padding: EdgeInsets.only(left: 18, top: 15),
                                  child: Text(snapshot.error.toString()),
                                );
                              }

                              if (snapshot.hasData) {
                                List<UserModel>? isiData = snapshot.data!;
                                if (isiData.length > 0) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: isiData.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            Icon(Icons.people),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              isiData[index]
                                                                  .fullname,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(isiData[index]
                                                                .email),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(isiData[index]
                                                                .role),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              sharedPreferences =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          var user_token =
                                                              sharedPreferences
                                                                  .getString(
                                                                      "user_token");

                                                          Map data = {
                                                            'folder_id':
                                                                widget.file_id,
                                                            'user_id':
                                                                isiData[index]
                                                                    .user_id
                                                          };
                                                          var jsonResponse =
                                                              null;
                                                          var response =
                                                              await http.post(
                                                                  "https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/deleteuseraccess?user_token=" +
                                                                      user_token!,
                                                                  body: data);

                                                          jsonResponse = json
                                                              .decode(response
                                                                  .body);

                                                          print(jsonResponse);

                                                          reloadData();
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.red,
                                                        )),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Container(
                                    padding: EdgeInsets.only(left: 18, top: 15),
                                    child: Text(""),
                                  );
                                }
                              }

                              return Container(
                                padding: EdgeInsets.only(left: 18, top: 15),
                                child: Text(""),
                              );
                            }),
                      )
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
