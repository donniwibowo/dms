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

  //
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
        backgroundColor: _dark ? null : Colors.grey.shade200,
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
                    // height: 250,
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [Colors.red, Colors.deepOrange.shade300],
                    //     begin: Alignment.centerLeft,
                    //     end: Alignment.centerRight,
                    //     stops: [0.5, 0.9],
                    //   ),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // CircleAvatar(
                            //   backgroundColor: Colors.red.shade300,
                            //   minRadius: 35.0,
                            //   child: Icon(
                            //     Icons.call,
                            //     size: 30.0,
                            //   ),
                            // ),
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              minRadius: 60.0,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(
                                    'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                              ),
                            ),
                            // CircleAvatar(
                            //   backgroundColor: Colors.red.shade300,
                            //   minRadius: 35.0,
                            //   child: Icon(
                            //     Icons.message,
                            //     size: 30.0,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey.shade400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$email",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nama",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey.shade400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$username",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "No. Telp",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey.shade400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$phone",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Text(
                        //   'Leonardo Palmeiro',
                        //   style: TextStyle(
                        //     fontSize: 35,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // Text(
                        //   'Flutter Developer',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 25,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // Card(
                  //   elevation: 8.0,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0)),
                  //   color: Color(0xff132137),
                  //   child: ListTile(
                  //     onTap: () {
                  //       //open edit profile
                  //     },
                  //     title: Text(
                  //       "$username",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 10.0),
                  // Card(
                  //   elevation: 4.0,
                  //   margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0)),
                  //   child: Column(
                  //     children: <Widget>[

                  //       ListTile(
                  //         leading: Icon(
                  //           Icons.people,
                  //           color: Color(0xff132137),
                  //         ),
                  //         title: Text("Ubah Detail Akun"),
                  //         trailing: Icon(Icons.keyboard_arrow_right),
                  //         onTap: () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 20.0),
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
