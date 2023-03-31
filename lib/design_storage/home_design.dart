import 'dart:convert';

import 'package:best_flutter_ui_templates/design_storage/category_list_view.dart';
// import 'package:best_flutter_ui_templates/design_storage/search_files_view.dart';
import 'package:best_flutter_ui_templates/design_storage/search_files_view.dart';
import 'package:best_flutter_ui_templates/settings.dart';
// import 'package:best_flutter_ui_templates/design_storage/app_info_screen.dart';
// import 'package:best_flutter_ui_templates/design_storage/popular_list_view.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller.dart';
import '../pages/recent_files_page.dart';
import '../pages/shared_folders_page.dart';
import 'design_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class DesignHomeScreen extends StatefulWidget {
  final String folder_parent_id;
  DesignHomeScreen({required this.folder_parent_id});
  @override
  _DesignHomeScreenState createState() => _DesignHomeScreenState();
}

class _DesignHomeScreenState extends State<DesignHomeScreen> {
  int _selectedIndex = 0;
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  void initState() {
    super.initState();
    checkLoginStatus();
  }

  late SharedPreferences sharedPreferences;
  late String search = '';
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    search = await prefs.getString('search') ?? '';
    if (sharedPreferences.getString("user_token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginView()),
          (Route<dynamic> route) => false);
    }
  }

  final TextEditingController searchController = new TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _status = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    _fabHeight = _initFabHeight;
    _panelHeightOpen = MediaQuery.of(context).size.height * .40;
    // print("folder parent id = " + widget.folder_parent_id);
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
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
              onPressed: () {
                showInputDialog(context, 'test', widget.folder_parent_id);
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.file_upload),
              backgroundColor: Colors.red,
              onPressed: () {
                //file upload
                _selectFile();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(),
                      CategoryListView(
                        folder_parent_id: widget.folder_parent_id,
                      ),
                      // Flexible(
                      // child: Positioned(
                      //   // adjust the position as needed
                      //   child: FloatingActionButton(
                      //     splashColor: Colors.blueGrey,
                      //     onPressed: () {
                      //       // Add button action
                      //     },
                      //     child: Icon(Icons.add),
                      //   ),
                      // ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SlidingUpPanel(
              defaultPanelState: PanelState.CLOSED,
              maxHeight: _panelHeightOpen,
              minHeight: 0,
              controller: panelController,
              panel: StreamBuilder<Widget?>(
                stream: pageController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) return const SizedBox.shrink();
                  return snapshot.data!;
                },
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
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
              icon: Icon(Icons.av_timer),
              label: 'Recent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              label: 'Shared',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 1: Search'),
  ];
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
            .push(MaterialPageRoute(builder: (context) => RecentPage()));
      } else if (_selectedIndex == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SharedFoldersPage()));
      }
      print(_selectedIndex);
    });
  }

  Future<Response> sendForm(
      String url, Map<String, dynamic> data, Map<String, File> files) async {
    Map<String, MultipartFile> fileMap = {};
    for (MapEntry fileEntry in files.entries) {
      File file = fileEntry.value;
      String fileName = path.basename(file.path);
      fileMap[fileEntry.key] = MultipartFile(
          file.openRead(), await file.length(),
          filename: fileName);
    }
    data.addAll(fileMap);
    var formData = FormData.fromMap(data);
    Dio dio = new Dio();
    return await dio.post(url,
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }

  Future<void> uploadFile(String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://localhost/leap_integra/master/dms/api/files/upload' +
            '?user_token=' +
            user_token));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status: ${response.statusCode}');
    }
  }

// Future uploadFiles() async {
//     if (userFile == null) {
//       // return _showSnackbar('Silahkan memilih gambar anda :)');
//     }

//    try{
//      var image = userFile;
//      print('upload started');
//      //upload image
//      //scenario  one - upload image as poart of formdata
//      var res1 = await sendForm('https://localhost/leap_integra/master/dms/api/files/upload',
//          {'parent_folder': 0, 'perihal': 'test', 'nomor': 'test123', 'description': 'test', 'related_document_ids': 'test','user_access':'[]'}, {'file': userFile});
//      print("res-1 $res1");
//      setState(() {
//        userFile = image;
//      });
//      if (res1.statusCode == HttpStatus.OK||res1.statusCode == 200) {
//        showAlertDialog(context, "File Uploaded.");
//      } else {
//        showAlertDialog(context, "Failed Upload.");
//      }
//    }
//    catch (e) {
//    }
//   }
  File? _selectedFile;

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Do something with the file
      try {
        _selectedFile = File(result.files.single.path!);
        print('upload started');
        //upload image
        //scenario  one - upload image as poart of formdata
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String user_token = await prefs.getString('user_token') ?? 'unknown';
        var res1 = await sendForm(
            'https://192.168.1.119/leap_integra/master/dms/api/files/upload' +
                '?user_token=' +
                user_token,
            {
              'parent_folder': 0,
              'perihal': 'test',
              'nomor': 'test123',
              'description': 'test',
              'related_document_ids': 'test',
              'user_access': '[]'
            },
            {
              'file': _selectedFile!
            });
        print("res-1 $res1");
        print('data masuk upload');
        print('data masuk upload');
        if (res1.statusCode == HttpStatus.OK || res1.statusCode == 200) {
          showAlertDialog(context, "File Uploaded.");
        } else {
          showAlertDialog(context, "Failed Upload.");
        }
      } catch (e) {
        print('error message');
        showAlertDialog(context, "Failed Upload (Error).");
        print(e);
      }
    } else {
      // User canceled the picker
      showAlertDialog(context, "Failed Upload.");
    }
    setState(() {});
  }

  createFolder(String name, String folder_parent_id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_token = sharedPreferences.getString("user_token");
    Map data = {'name': name, 'parent_folder': folder_parent_id};
    var jsonResponse = null;
    var response = await http.post(
        "https://192.168.1.119/leap_integra/master/dms/api/files/createfolder?user_token=" +
            user_token!,
        body: data);
    // var response = await http.post(
    //     "https://192.168.1.119/leap_integra/master/dms/api/files/createfolder?user_token=" +
    //         user_token!,
    //     body: data);
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        showAlertDialog(context, "Folder Uploaded.");
      }
    } else {
      showAlertDialog(context, "E-mail atau Kata Sandi Salah.");
    }
    setState(() {});
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showViewDialog(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("View"),
      content: Text('Test'),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showInputDialog(
      BuildContext context, String message, String folder_parent_id) {
    final TextEditingController namaController = new TextEditingController();
    final TextEditingController descriptionController =
        new TextEditingController();
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Create Folder"),
      content: TextField(
        controller: namaController,
        decoration: InputDecoration(hintText: 'Enter some text'),
      ),
      actions: [
        TextButton(
          child: Text("Create"),
          onPressed: () {
            createFolder(namaController.text, folder_parent_id);
            Navigator.pop(context);
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        CategoryListView(),
      ],
    );
  }

  // Widget getPopularCourseUI() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'Folders',
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w600,
  //             fontSize: 22,
  //             letterSpacing: 0.27,
  //             color: DesignAppTheme.darkerText,
  //           ),
  //         ),
  //         Flexible(
  //           child: PopularCourseListView(
  //             callBack: () {
  //               moveTo();
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // void moveTo() {
  //   Navigator.push<dynamic>(
  //     context,
  //     MaterialPageRoute<dynamic>(
  //       builder: (BuildContext context) => CategoryListView(search:searchController.text),
  //     ),
  //   );
  // }

  Widget getSearchBarUI() {
    final TextEditingController searchController = TextEditingController();
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: TextFormField(
                    controller: searchController,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: DesignAppTheme.nearlyBlue,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: search,
                      labelText: 'Cari dokumen di sini',
                      // border: InputBorder.none,
                      helperStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: HexColor('#B9BABC'),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: HexColor('#B9BABC'),
                      ),
                    ),
                    onEditingComplete: () {},
                  ),
                ),
              ),
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchFilesListView(
                                keyword: searchController.text)));
                        // savedSearch(searchController.text);
                        // print('ini ketikan');
                        // print(searchController.text);
                        // print(sharedPreferences.getString("search") );
                        // setState(() {});
                      },
                      child: Icon(Icons.search))),
              // Container(
              //     child:
              //         ElevatedButton(onPressed: () {}, child: Icon(Icons.add))),
            ]));
  }

  savedSearch(String search) async {
    sharedPreferences.setString("search", search);
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   'save/share your folder',
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w400,
                //     fontSize: 14,
                //     letterSpacing: 0.2,
                //     color: DesignAppTheme.grey,
                //   ),
                // ),
                Text(
                  'DMS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignAppTheme.darkerText,
                  ),
                ),
                Text(
                  'Kelola Dokumen Anda',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignAppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
            child: Container(
              width: 60,
              height: 60,
              child: Image.asset('assets/design_storage/userImage.png'),
            ),
          )
        ],
      ),
    );
  }
}
