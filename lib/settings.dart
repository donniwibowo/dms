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

class Settings extends StatefulWidget {
  // static final String path = "lib/src/pages/settings/settings1.dart";

  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<Settings> {
  late bool _dark;
  String username = "";
  String email = "";
  String phone = "";
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
    super.initState();
    _dark = false;
    setState(() {
      checkLoginStatus();
      getFromSharedPreferences();
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

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("fullname")!;
        user_token = prefs.getString("user_token")!;
        email = prefs.getString("email")!;
        phone = prefs.getString("phone")!;
        // print(username);
      });
    }

    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiuser/" + username);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(response.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          data = content['values'];
        });
      }
    } else {
      print(response.body);
    }
    nama = data[0]['nama'];
    bio = data[0]['biodata'];
    profile = 'https://discoverkorea.site/uploads/profile/' +
        data[0]['profile_picture'];
    print('profil url ' + '$profile');
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("user_token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => DesignHomeScreen(
                    folder_parent_id: "0",
                  )),
          (Route<dynamic> route) => false);
    }
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        // backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Pengaturan',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginView()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              // padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: [
                                  Image.asset(
                                      'assets/design_storage/userImage.png'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 10, 25, 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffc9ccff),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "PROFILE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '$email',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                title: Text(
                                  'Nama',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '$username',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                title: Text(
                                  'No. Telp',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '$phone',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
