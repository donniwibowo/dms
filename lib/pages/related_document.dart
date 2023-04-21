import 'dart:convert';

import 'package:best_flutter_ui_templates/design_storage/models/category.dart';
import 'package:best_flutter_ui_templates/design_storage/models/user.dart';
import 'package:best_flutter_ui_templates/pages/recent_page.dart';
import 'package:best_flutter_ui_templates/pages/shared_folders_page.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:best_flutter_ui_templates/provider/api_user.dart';
import 'package:best_flutter_ui_templates/provider/my_flutter_app_icons.dart';
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
import 'dart:convert';

class RelatedDocument extends StatefulWidget {
  final String name;
  final String file_id;
  final String folder_parent_id;

  RelatedDocument(
      {required this.name, this.file_id = "0", this.folder_parent_id = "0"});
  @override
  _RelatedDocumentState createState() => _RelatedDocumentState();
}

class _RelatedDocumentState extends State<RelatedDocument> {
  int _selectedIndex = 0;
  List<MultiSelectItem<String>> documentList = [];
  ApiFolders serviceAPI = ApiFolders();
  late Future<List<CategoryModel>> listRelatedDocument;

  List<DropdownMenuItem<String>> get getRoleList {
    List<DropdownMenuItem<String>> roleList = [
      DropdownMenuItem(child: Text("View"), value: "view"),
      DropdownMenuItem(child: Text("Edit"), value: "edit"),
    ];
    return roleList;
  }

  Future<List<CategoryModel>>? _fetchDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final response = await http.get(Uri.parse(
        'https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/getrelateddocumentbyuser?user_token=' +
            user_token));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      var user_data =
          List<CategoryModel>.from(json.map((i) => CategoryModel.fromJson(i)));
      return user_data;
    } else {
      throw Exception('Failed to get albums');
    }
  }

  @override
  void initState() {
    super.initState();
    listRelatedDocument = serviceAPI.getRelatedDocument(widget.file_id);
  }

  void reloadData() {
    setState(() {
      listRelatedDocument = serviceAPI.getRelatedDocument(widget.file_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    List<String>? selectedDocument = [];
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
              subtitle: 'Dokument Terkait',
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
                                Text(
                                  'Pengaturan Dokumen',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      var user_token = sharedPreferences
                                          .getString("user_token");

                                      Map data = {
                                        'folder_id': widget.file_id,
                                        'documents': selectedDocument.toString()
                                      };
                                      var jsonResponse = null;
                                      var response = await http.post(
                                          "https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/addrelateddocument?user_token=" +
                                              user_token!,
                                          body: data);

                                      jsonResponse = json.decode(response.body);
                                      reloadData();
                                      setState(() {
                                        selectedDocument = [];
                                      });

                                      const msg = SnackBar(
                                        content: Text(
                                            'Dokumen terkait berhasil ditambahkan'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(msg);
                                    },
                                    icon: Icon(
                                      Icons.save,
                                      color: Colors.blue,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: FutureBuilder<List<CategoryModel>>(
                            future: _fetchDocument(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<CategoryModel>> snapshot) {
                              Widget result;
                              if (snapshot.hasData) {
                                List<CategoryModel>? isiData = snapshot.data!;

                                documentList = isiData
                                    .map((data) => MultiSelectItem<String>(
                                        data.folder_id, data.name))
                                    .toList();

                                result = MultiSelectDialogField(
                                  // buttonIcon: Icon(Icons.file_copy),
                                  title: Text("Pilih Dokumen"),
                                  buttonText: Text(
                                    "Dokumen",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                  items: documentList,
                                  listType: MultiSelectListType.CHIP,
                                  onConfirm: (values) {
                                    selectedDocument = values.cast<String>();
                                  },
                                );
                              } else if (snapshot.hasError) {
                                result = Text('Error: ${snapshot.error}');
                              } else {
                                result = const Text('Awaiting result...');
                              }
                              return result;
                            }),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 20),
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //         top: BorderSide(
                          //             width: 1, color: Colors.grey))),
                          child: Row(
                            children: [
                              Text(
                                "Dokumen Terkait",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Container(
                        child: FutureBuilder<List<CategoryModel>>(
                            future: listRelatedDocument,
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
                                List<CategoryModel>? isiData = snapshot.data!;
                                if (isiData.length > 0) {
                                  return ListView.builder(
                                      padding: EdgeInsets.zero,
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
                                                        child: Icon(
                                                          isiData[index]
                                                                      .format ==
                                                                  'pdf'
                                                              ? MyFlutterApp
                                                                  .file_pdf
                                                              : MyFlutterApp
                                                                  .file_word,
                                                          color: isiData[index]
                                                                      .format ==
                                                                  'pdf'
                                                              ? Colors.red
                                                              : Colors.blue,
                                                        ),
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
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(isiData[index]
                                                                .size),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    child: PopupMenuButton<
                                                            String>(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                    .circular(
                                                                        20)
                                                                .copyWith(
                                                                    topRight:
                                                                        Radius.circular(
                                                                            0))),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        elevation: 10,
                                                        color: Colors
                                                            .grey.shade100,
                                                        itemBuilder:
                                                            (BuildContext context) =>
                                                                <
                                                                    PopupMenuEntry<
                                                                        String>>[
                                                                  PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'download',
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.download,
                                                                              size: 20,
                                                                              color: Colors.green,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              'Download',
                                                                              style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Divider()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // Visibility(child: child)
                                                                  PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'delete',
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.green,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              'Hapus',
                                                                              style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Divider()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                        onSelected:
                                                            (String value) async {
                                                          // Handle menu item selection here
                                                          if (value ==
                                                              'view') {}

                                                          if (value ==
                                                              'delete') {
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
                                                                  widget
                                                                      .file_id,
                                                              'document_id':
                                                                  isiData[index]
                                                                      .folder_id
                                                            };
                                                            var jsonResponse =
                                                                null;
                                                            var response =
                                                                await http.post(
                                                                    "https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/deleterelateddocument?user_token=" +
                                                                        user_token!,
                                                                    body: data);

                                                            jsonResponse = json
                                                                .decode(response
                                                                    .body);
                                                            reloadData();
                                                            const msg =
                                                                SnackBar(
                                                              content: Text(
                                                                  'Dokumen terkait berhasil dihapus'),
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    msg);
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Container(
                                    padding: EdgeInsets.only(left: 3),
                                    child: Text("Tidak ada dokumen terkait"),
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
