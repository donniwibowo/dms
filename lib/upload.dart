import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new Upload());

class Upload extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData.dark(),
      home: new MyHomePage(),
    );
  }
}

Future<Response> sendForm(
    String url, Map<String, dynamic> data, Map<String, File> files) async {
  Map<String, MultipartFile> fileMap = {};
  for (MapEntry fileEntry in files.entries) {
    File file = fileEntry.value;
    String fileName = path.basename(file.path);
    fileMap[fileEntry.key] =
        MultipartFile(file.openRead(), await file.length(), filename: fileName);
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File imageFile;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String username = "";
  void initState() {
    super.initState();
    getFromSharedPreferences();
  }

  //ini untuk panggil api
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("username")!;
        print("masuk dalam post " + username);
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: new Column(
        children: <Widget>[
          _buildPreviewImage(),
          _buildText(),
          _buildText2(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    return new Expanded(
      child: new Card(
        elevation: 3.0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            new Radius.circular(4.0),
          ),
        ),
        child: new Stack(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                _selectGalleryImage();
              },
              child: new Container(
                constraints: new BoxConstraints.expand(),
                child: imageFile == null
                    ? new Image.asset('assets/discoverkorea-sejarah.png',
                        colorBlendMode: BlendMode.darken,
                        color: Colors.white,
                        fit: BoxFit.cover)
                    : new Image.file(imageFile, fit: BoxFit.cover),
              ),
            ),
            new Align(
              alignment: AlignmentDirectional.center,
              child: imageFile == null
                  ? new Text(
                      'Tidak ada file',
                      style: Theme.of(context).textTheme.title,
                    )
                  : new Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return new Container(
      padding: EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: TextField(
        controller: _title,
        maxLines: 1,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Judul berita kamu..",
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _buildText2() {
    return new Container(
      padding: EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: TextField(
        controller: _status,
        maxLines: 5,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText:
                "Ketikan deskripsi tentang berita ini yang berkaitan seputar korea..",
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
            icon: Icon(Icons.camera),
            onPressed: _takePhoto,
            color: Colors.black,
            tooltip: 'Ambil foto dari kamera',
          ),
          new IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: uploadImage,
            color: Colors.black,
            tooltip: 'Unggah berita',
          ),
          new IconButton(
            icon: Icon(Icons.image),
            onPressed: _selectGalleryImage,
            color: Colors.black,
            tooltip: 'Pilih dari galeri',
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
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

  Future uploadImage() async {
    if (imageFile == null) {
      return showAlertDialog(context, "Pilih File Terlebih Dahulu.");
    }

    try {
      var image = imageFile;

      print('upload started');
      //upload image
      //scenario  one - upload image as poart of formdata
      var res1 = await sendForm(
          'https://discoverkorea.site/apiuser/unggahapiunggahanpengguna',
          {'name': username, 'title': _title.text, 'status': _status.text},
          {'file': imageFile});
      print("res-1 $res1");
      setState(() {
        imageFile = image;
      });
      if (res1.statusCode == HttpStatus.OK || res1.statusCode == 200) {
        showAlertDialog(context, "Unggahan Berhasil.");
      } else {
        showAlertDialog(context, "Unggahan Gagal, terjadi kesalahan!");
      }
    } catch (e) {
      showAlertDialog(context,
          'Gagal unggah, pastikan gambar, judul dan deskripsi teris.$e');
    }
  }

  _selectGalleryImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  //var resize = img.copyResize(image, 480);
  return img.encodePng(image, level: 1);
}
