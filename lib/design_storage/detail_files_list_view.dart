import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/design_storage/design_app_theme.dart';
import 'package:best_flutter_ui_templates/design_storage/category_list_view.dart';
import 'package:provider/provider.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class DetailFilesListView extends StatefulWidget {
  // static final String path = "lib/src/pages/settings/settings1.dart";
  final String folder_parent_id;
  DetailFilesListView({required this.folder_parent_id});
  @override
  _DetailFilesListViewState createState() => _DetailFilesListViewState();
}

class _DetailFilesListViewState extends State<DetailFilesListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late bool _dark;
  String username = "";
  String user_token = "";
  String profile = "";
  String nama = "";
  String bio = "";
  late List data;
  late File imageFile;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    _dark = false;
    setState(() {});
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

  Future<Response> sendFile(String url, File file) async {
    Dio dio = new Dio();
    var len = await file.length();
    var response = await dio.post(url,
        data: file.openRead(),
        options: Options(headers: {
          Headers.contentLengthHeader: len,
        } // set content-length
            ));
    return response;
  }

  int folders_length = 0;

  //

  @override
  Widget build(BuildContext context) {
    print(widget.folder_parent_id);
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
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
                showInputDialog(context, 'test');
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
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Detail Folder',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DesignHomeScreen(folder_parent_id: "0")));
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xff132137),
                    child: ListTile(
                      onTap: () {
                        //open edit profile
                      },
                      title: Text(
                        "Your Result",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: FutureBuilder(
                      future: Provider.of<ApiFolders>(context, listen: false)
                          .getDetailFolder(widget.folder_parent_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Consumer<ApiFolders>(
                          builder: (context, data, _) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.dataDetail.length,
                                itemBuilder: (context, i) {
                                  return new ListTile(
                                    leading: Icon(
                                      Icons.folder,
                                      color: Color(0xff132137),
                                    ),
                                    onTap: () {
                                      //open edit profile
                                      print(widget.folder_parent_id);
                                    },
                                    title: Text(
                                      data.dataFolders[i].name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showInputDialog(BuildContext context, String message) {
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
            createFolder(namaController.text, widget.folder_parent_id);
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
            'https://192.168.1.28/leap_integra/master/dms/api/files/upload' +
                '?user_token=' +
                user_token,
            {
              'parent_folder': widget.folder_parent_id,
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

  createFolder(String name, String parent_folder) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_token = sharedPreferences.getString("user_token");
    Map data = {'name': name, 'parent_folder': parent_folder};
    var jsonResponse = null;
    var response = await http.post(
        "https://192.168.1.28/leap_integra/master/dms/api/files/createfolder?user_token=" +
            user_token!,
        body: data);
    // var response = await http.post(
    //     "https://192.168.1.28/leap_integra/master/dms/api/files/createfolder?user_token=" +
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
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
