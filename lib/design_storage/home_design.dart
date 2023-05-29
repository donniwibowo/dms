import 'dart:convert';
import 'dart:ffi';

import 'package:best_flutter_ui_templates/design_storage/category_list_view.dart';
import 'package:best_flutter_ui_templates/provider/my_flutter_app_icons.dart';
import 'package:best_flutter_ui_templates/settings.dart';
// import 'package:best_flutter_ui_templates/design_storage/app_info_screen.dart';
// import 'package:best_flutter_ui_templates/design_storage/popular_list_view.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:best_flutter_ui_templates/design_storage/models/category.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import '../pages/recent_page.dart';
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
import 'package:multi_select_flutter/multi_select_flutter.dart';

class HomePageController {
  late void Function() reloadData;
}

class DesignHomeScreen extends StatefulWidget {
  final String folder_parent_id;
  final String keyword;

  DesignHomeScreen({required this.folder_parent_id, this.keyword = ""});
  @override
  _DesignHomeScreenState createState() => _DesignHomeScreenState();
}

class _DesignHomeScreenState extends State<DesignHomeScreen> {
  int _selectedIndex = 0;
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;
  ApiFolders serviceAPI = ApiFolders();

  final HomePageController myController = HomePageController();

  void initState() {
    super.initState();
    checkLoginStatus();
    _fetchUserData();
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
    _panelHeightOpen = MediaQuery.of(context).size.height * .50;

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
              child: const Icon(
                MyFlutterApp.folder_plus,
                size: 20,
              ),
              // backgroundColor: Colors.red,
              onPressed: () {
                showCreateFolderForm(context, 'test', widget.folder_parent_id);
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(
                MyFlutterApp.cloud_upload_alt,
                size: 20,
              ),
              // backgroundColor: Colors.red,
              onPressed: () {
                // file upload
                showFileUploadForm(
                    context, 'Upload File', widget.folder_parent_id);
              },
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
              subtitle: 'Dashboard',
              folder_id: widget.folder_parent_id,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SearchBar(
                        searchPlaceHolder: widget.keyword,
                      ),
                      CategoryListView(
                        folder_parent_id: widget.folder_parent_id,
                        keyword: widget.keyword,
                        controller: myController,
                      ),
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

  List<MultiSelectItem<String>> listUser = [];
  Future<void> _fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_token = sharedPreferences.getString("user_token");
    final response = await http.get(Uri.parse(
        'https://192.168.1.17/leap_integra/master/dms/api/user/getallusers?user_token=' +
            user_token!));
    final jsonResponse = json.decode(response.body);
    final List<dynamic> itemList = jsonResponse['users'];
    listUser = itemList
        .map((data) =>
            MultiSelectItem<String>(data['user_id'], data['fullname']))
        .toList();
  }

  //untuk upload folder
  showCreateFolderForm(
      BuildContext context, String message, String folder_parent_id) {
    final TextEditingController namaController = new TextEditingController();
    final TextEditingController descriptionController =
        new TextEditingController();
    List<String>? selectedItems = [];
    _fetchUserData();
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Buat Folder"),
      content: Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: namaController,
              decoration: InputDecoration(hintText: 'Nama'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Deskripsi'),
            ),
            MultiSelectDialogField(
              buttonIcon: Icon(Icons.people),
              title: Text("Pilih User"),
              buttonText: Text(
                "User Akses",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              items: listUser,
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                selectedItems = values.cast<String>();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Tutup"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Buat"),
          onPressed: () {
            submitFolderData(
              namaController.text,
              descriptionController.text,
              folder_parent_id,
              selectedItems,
            );
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

  submitFolderData(String name, String descriptionController,
      String folder_parent_id, selectedUsers) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_token = sharedPreferences.getString("user_token");
    String user = sharedPreferences.getString("user_id").toString();
    print(selectedUsers);
    print('selected user');
    Map data = {
      'name': name,
      'description': descriptionController,
      'parent_folder': folder_parent_id,
      'users': selectedUsers.toString()
    };
    var jsonResponse = null;
    var response = await http.post(
        "https://192.168.1.17/leap_integra/master/dms/api/files/createfolder?user_token=" +
            user_token!,
        body: data);

    jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        Navigator.pop(context);
        const createFolderMsg = SnackBar(
          content: Text('Folder baru berhasil ditambahkan'),
        );
        ScaffoldMessenger.of(context).showSnackBar(createFolderMsg);

        myController.reloadData();
      } else {
        const createFolderMsg = SnackBar(
          content: Text('Internal server error'),
        );
        ScaffoldMessenger.of(context).showSnackBar(createFolderMsg);
      }
    } else {
      const createFolderMsg = SnackBar(
        content: Text('Internal server error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(createFolderMsg);
    }
    setState(() {});
  }

  //untuk upload file
  showFileUploadForm(
      BuildContext context, String message, String folder_parent_id) {
    final TextEditingController perihalController = new TextEditingController();
    final TextEditingController nomorController = new TextEditingController();
    final TextEditingController descriptionController =
        new TextEditingController();

    List<String>? selectedItems = [];

    AlertDialog alert = AlertDialog(
      title: Text("Upload Dokumen"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: perihalController,
              decoration: InputDecoration(hintText: 'Perihal'),
            ),
            TextField(
              controller: nomorController,
              decoration: InputDecoration(hintText: 'Nomor'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Deskripsi'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Tutup"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Pilih Dokumen"),
          onPressed: () {
            _selectFile(perihalController.text, nomorController.text,
                descriptionController.text, folder_parent_id);
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

  File? _selectedFile;

  _selectFile(String perihalController, String nomorController,
      String descriptionController, String folder_parent_id) async {
    // final result = await FilePicker.platform.pickFiles();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'doc'],
    );

    if (result != null) {
      // Do something with the file
      try {
        _selectedFile = File(result.files.single.path!);
        PlatformFile file_data = result.files.first;
        print(file_data.name);
        print(file_data.size);

        if (file_data.size / 1024 > 1000) {
          const fileUploadFailedMsg = SnackBar(
            content: Text('Batas maksimal ukuran dokumen adalah 1 MB'),
          );
          ScaffoldMessenger.of(context).showSnackBar(fileUploadFailedMsg);
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String user_token = await prefs.getString('user_token') ?? 'unknown';
          var res1 = await sendForm(
              'https://192.168.1.17/leap_integra/master/dms/api/files/upload' +
                  '?user_token=' +
                  user_token,
              {
                'parent_folder': folder_parent_id,
                'perihal': perihalController,
                'nomor': nomorController,
                'description': descriptionController
              },
              {
                'file': _selectedFile!
              });

          if (res1.statusCode == HttpStatus.OK || res1.statusCode == 200) {
            const fileUploadSuccessMsg = SnackBar(
              content: Text('Dokumen berhasil diupload'),
            );
            ScaffoldMessenger.of(context).showSnackBar(fileUploadSuccessMsg);
            myController.reloadData();
          } else {
            const fileUploadFailedMsg = SnackBar(
              content: Text('Gagal mengupload dokumen'),
            );
            ScaffoldMessenger.of(context).showSnackBar(fileUploadFailedMsg);
          }
        }
      } catch (e) {
        print(e);
        const fileUploadFailedMsg = SnackBar(
          content: Text('Gagal mengupload dokumen'),
        );
        ScaffoldMessenger.of(context).showSnackBar(fileUploadFailedMsg);
      }
    } else {
      // User canceled the picker
      // showAlertDialog(context, "Failed Upload.");
    }
  }
}
