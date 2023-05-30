import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/design_storage/category_list_view.dart';
import 'package:best_flutter_ui_templates/design_storage/shared_folders_list_view.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:best_flutter_ui_templates/pages/edit_folder.dart';
import 'package:best_flutter_ui_templates/pages/manage_user.dart';
import 'package:best_flutter_ui_templates/pages/related_document.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller.dart';
import '../design_storage/models/category.dart';
import '../design_storage/design_app_theme.dart';
import '../design_storage/home_design.dart';
import '../settings.dart';

class TopHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String folder_id;
  const TopHeader(
      {Key? key, this.title = "", this.subtitle = "", this.folder_id = "0"})
      : super(key: key);

  Widget build(BuildContext context) {
    ApiFolders serviceAPI = ApiFolders();
    String dirname = subtitle;
    String folder_parent_id = "0";
    bool isVisible = false;
    double custom_left_padding = 18;

    if (folder_id != "0") {
      isVisible = true;
    }

    return FutureBuilder<List<CategoryModel>>(
      future: serviceAPI.getFolderInfo(folder_id),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel>? isiData = snapshot.data!;
          if (isiData.length > 0) {
            if (dirname != 'User Akses') {
              dirname = isiData[0].name;
            }

            folder_parent_id = isiData[0].folder_parent_id;
            custom_left_padding = 0;
          }
          return Padding(
            padding:
                EdgeInsets.only(top: 8.0, left: custom_left_padding, right: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Visibility(
                              visible: isVisible,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DesignHomeScreen(
                                                  folder_parent_id:
                                                      folder_parent_id,
                                                )));
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignAppTheme.darkerText,
                                ),
                              ),
                              Text(
                                dirname,
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
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
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
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class TopHeaderEditPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String folder_id;
  const TopHeaderEditPage(
      {Key? key, this.title = "", this.subtitle = "", this.folder_id = "0"})
      : super(key: key);

  Widget build(BuildContext context) {
    ApiFolders serviceAPI = ApiFolders();
    String dirname = subtitle;
    String folder_parent_id = "0";
    bool isVisible = true;
    double custom_left_padding = 18;

    return FutureBuilder<List<CategoryModel>>(
      future: serviceAPI.getFolderInfo(folder_id),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel>? isiData = snapshot.data!;
          if (isiData.length > 0) {
            if (dirname != 'User Akses') {
              dirname = isiData[0].name;
            }

            folder_parent_id = isiData[0].folder_parent_id;
            custom_left_padding = 0;
          }
          return Padding(
            padding:
                EdgeInsets.only(top: 8.0, left: custom_left_padding, right: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Visibility(
                              visible: isVisible,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DesignHomeScreen(
                                                  folder_parent_id:
                                                      folder_parent_id,
                                                )));
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignAppTheme.darkerText,
                                ),
                              ),
                              Text(
                                'Edit Folder',
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
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
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
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final String searchPlaceHolder;

  const SearchBar({
    Key? key,
    this.searchPlaceHolder = "",
  }) : super(key: key);

  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    searchController.text = searchPlaceHolder;
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
                      // color: DesignAppTheme.nearlyBlue,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // hintText: search,
                      labelText: 'Cari dokumen..',
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
                            builder: (context) => DesignHomeScreen(
                                folder_parent_id: "0",
                                keyword: searchController.text)));
                      },
                      child: Icon(Icons.search))),
            ]));
  }
}

class SlideUpView extends StatelessWidget {
  // const SlideUpView({super.key});
  final String folder_id;
  final String name;
  final String desc;
  final String user_access;
  final String created_by;
  final String created_on;
  final String updated_on;
  final String file_url;
  final String type;
  // final Function reload;

  const SlideUpView({
    Key? key,
    this.folder_id = "",
    this.name = "",
    this.desc = "",
    this.user_access = "",
    this.created_by = "",
    this.created_on = "",
    this.updated_on = "",
    this.file_url = "",
    this.type = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiFolders serviceAPI = ApiFolders();
    // bool isVisible = true;

    // if (type == "Folder") {
    //   isVisible = false;
    // }

    return Container(
      // decoration: BoxDecoration(color: Colors.amber),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
        child: Column(
          children: [
            Container(
              height: 10,
              width: 60,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Nama',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Deskripsi',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Text(desc,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Akses',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Flexible(
                      child: Text(user_access,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Dibuat Oleh',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Text(created_by,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Tanggal Dibuat',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Text(created_on,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Tanggal Diperbaharui',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Text(updated_on,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// slide up untuk setting
class SlideUpSetting extends StatelessWidget {
  final String folder_parent_id;
  final String folder_id;
  final String name;
  final String desc;
  final String user_access;
  final String created_by;
  final String created_on;
  final String updated_on;
  final String file_url;
  final String type;
  final String is_owner;
  final String perihal;
  final String nomor;
  final Function reloadData;

  const SlideUpSetting(
      {Key? key,
      this.folder_parent_id = "",
      this.folder_id = "",
      this.name = "",
      this.desc = "",
      this.user_access = "",
      this.created_by = "",
      this.created_on = "",
      this.updated_on = "",
      this.file_url = "",
      this.type = "",
      this.is_owner = "",
      this.perihal = "",
      this.nomor = "",
      required this.reloadData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiFolders serviceAPI = ApiFolders();
    bool isVisible = true;

    if (type == "Folder") {
      isVisible = false;
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
        String descriptionController, String _folder_id) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'pdf', 'doc'],
      );

      if (result != null) {
        try {
          _selectedFile = File(result.files.single.path!);
          PlatformFile file_data = result.files.first;

          if (file_data.size / 1024 > 1000) {
            const fileUploadFailedMsg = SnackBar(
              content: Text('Batas maksimal ukuran dokumen adalah 1 MB'),
            );
            ScaffoldMessenger.of(context).showSnackBar(fileUploadFailedMsg);
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String user_token =
                await prefs.getString('user_token') ?? 'unknown';
            var res1 = await sendForm(
                'http://34.101.208.151/agutask/dms/api/files/revisidocument' +
                    '?user_token=' +
                    user_token,
                {
                  'folder_id': _folder_id,
                  'perihal': perihalController,
                  'nomor': nomorController,
                  'description': descriptionController
                },
                {
                  'file': _selectedFile!
                });

            if (res1.statusCode == HttpStatus.OK || res1.statusCode == 200) {
              slidePanelClose();
              const fileUploadSuccessMsg = SnackBar(
                content: Text('Revisi dokumen berhasil diupload'),
              );
              ScaffoldMessenger.of(context).showSnackBar(fileUploadSuccessMsg);
              reloadData();
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
      }
    }

    //untuk upload file
    showRevisionFile(BuildContext context, String message, String _folder_id,
        String _nomor, String _perihal, String _desc) {
      final TextEditingController perihalController =
          new TextEditingController();
      final TextEditingController nomorController = new TextEditingController();
      final TextEditingController descriptionController =
          new TextEditingController();

      nomorController.text = _nomor;
      perihalController.text = _perihal;
      descriptionController.text = _desc;

      List<String>? selectedItems = [];
      AlertDialog alert = AlertDialog(
        title: Text("Revisi Dokumen"),
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
                  descriptionController.text, _folder_id);
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

    return Container(
      // decoration: BoxDecoration(color: Colors.amber),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
        child: Column(
          children: [
            Container(
              height: 10,
              width: 60,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ManageUser(
                                name: name,
                                file_id: folder_id,
                                folder_parent_id: folder_parent_id,
                                type: type,
                              )));
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 10, bottom: 10),
                          child: Icon(
                            Icons.people,
                            size: 20,
                          ),
                        ),
                        Text('User Akses')
                      ],
                    ),
                  )),
                  // Divider(),
                  Visibility(
                    visible: is_owner == "1" && type == 'File' ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RelatedDocument(
                                  name: name,
                                  file_id: folder_id,
                                  folder_parent_id: folder_parent_id,
                                )));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.file_copy,
                              size: 20,
                            ),
                          ),
                          Text('Dokumen Terkait')
                        ],
                      ),
                    )),
                  ),
                  Visibility(
                    visible: is_owner == "1" && type == 'File' ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        // revisi
                        showRevisionFile(context, 'Revisi Dokumen', folder_id,
                            nomor, perihal, desc);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                          Text('Revisi')
                        ],
                      ),
                    )),
                  ),
                  Visibility(
                    visible: is_owner == "1" && type == 'File' ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Pengaturan File'),
                                  content: Container(
                                    height: 300,
                                    width: 400,
                                    child: FutureBuilder<List<CategoryModel>>(
                                        future: serviceAPI
                                            .getRevisionFile(folder_id),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<CategoryModel>? isiData =
                                                snapshot.data!;
                                            if (isiData.length < 1) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Text(
                                                  "Tidak ada data",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              );
                                            }
                                            return Container(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: isiData.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 0,
                                                                top: 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Text(
                                                                      isiData[index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        '(' +
                                                                            isiData[index].no_revision +
                                                                            ')',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey.shade500),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                    'Updated : ' +
                                                                        isiData[index]
                                                                            .updated_on,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600)),
                                                                Text(
                                                                    'Oleh : ' +
                                                                        isiData[index]
                                                                            .email,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600)),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      // set up the buttons
                                                                      Widget
                                                                          cancelButton =
                                                                          ElevatedButton(
                                                                        child: Text(
                                                                            "Tutup"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                      Widget
                                                                          continueButton =
                                                                          ElevatedButton(
                                                                        child: Text(
                                                                            "Rollback"),
                                                                        onPressed:
                                                                            () async {
                                                                          // do rollback

                                                                          Map data =
                                                                              {
                                                                            'active_file_id':
                                                                                folder_id,
                                                                            'target_file_id':
                                                                                isiData[index].folder_id
                                                                          };
                                                                          print(
                                                                              folder_id);
                                                                          print(
                                                                              isiData[index].folder_id);
                                                                          SharedPreferences
                                                                              sharedPreferences =
                                                                              await SharedPreferences.getInstance();

                                                                          var user_token =
                                                                              sharedPreferences.getString("user_token");

                                                                          var jsonResponse =
                                                                              null;
                                                                          var response = await http.post(
                                                                              "http://34.101.208.151/agutask/dms/api/files/rollback?user_token=" + user_token!,
                                                                              body: data);
                                                                          jsonResponse =
                                                                              json.decode(response.body);
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            Navigator.pop(context,
                                                                                'Cancel');
                                                                            slidePanelClose();
                                                                            const rollbackMsg =
                                                                                SnackBar(
                                                                              content: Text('Rollback berhasil'),
                                                                            );
                                                                            ScaffoldMessenger.of(context).showSnackBar(rollbackMsg);
                                                                            reloadData();
                                                                          } else {
                                                                            print("error");
                                                                          }

                                                                          // end of do rollback
                                                                        },
                                                                      );
                                                                      // set up the AlertDialog
                                                                      AlertDialog
                                                                          alert =
                                                                          AlertDialog(
                                                                        title: Text(
                                                                            "Rollback Dokumen"),
                                                                        content:
                                                                            Text("Apakah anda yakin untuk melakukan rollback pada file ini?"),
                                                                        actions: [
                                                                          cancelButton,
                                                                          continueButton,
                                                                        ],
                                                                      );
                                                                      // show the dialog
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return alert;
                                                                        },
                                                                      );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .refresh,
                                                                      color: Colors
                                                                          .amber,
                                                                    )),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      slidePanelClose();
                                                                      Navigator.pop(
                                                                          context);
                                                                      const downloadRevisionFileMsg =
                                                                          SnackBar(
                                                                        content:
                                                                            Text('Dokumen berhasil di download'),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              downloadRevisionFileMsg);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .download,
                                                                      color: Colors
                                                                          .blue,
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ));
                                                  }),
                                            );
                                          } else {}
                                          return Container();
                                        }),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                ));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.refresh,
                              size: 20,
                            ),
                          ),
                          Text('Rollback')
                        ],
                      ),
                    )),
                  ),
                  Visibility(
                    visible: type == 'File' ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        FileDownloader.downloadFile(
                            url:
                                'https://dms.tigajayabahankue.com/uploads/documents/EF_TestResult.pdf',
                            onProgress: (name, progress) {
                              print(progress);
                              // setState(() {
                              //   _progress = progress;
                              // });
                            },
                            onDownloadCompleted: (value) {
                              slidePanelClose();
                              const downloadMsg = SnackBar(
                                content: Text('Dokumen berhasil di download'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(downloadMsg);
                              // setState(() {
                              //   _progress = null;
                              // });
                            });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.download,
                              size: 20,
                            ),
                          ),
                          Text('Download')
                        ],
                      ),
                    )),
                  ),
                  // Divider(),
                  Visibility(
                    visible: type == "Folder" && is_owner == "1" ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditFolder(
                                  folder_parent_id: folder_parent_id,
                                  folder_id: folder_id,
                                  name: name,
                                  description: desc,
                                )));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                          Text('Edit')
                        ],
                      ),
                    )),
                  ),
                  // Divider(),
                  Visibility(
                    visible: is_owner == "1" ? true : false,
                    child: Container(
                        child: InkWell(
                      onTap: () async {
                        // set up the buttons
                        Widget cancelButton = ElevatedButton(
                          child: Text("Tutup"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget continueButton = ElevatedButton(
                          child: Text("Hapus"),
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            Map data = {'file_id': folder_id};
                            var user_token =
                                sharedPreferences.getString("user_token");
                            var jsonResponse = null;
                            final response = await http.post(
                                "http://34.101.208.151/agutask/dms/api/files/delete?user_token=" +
                                    user_token!,
                                body: data);
                            if (response.body.isNotEmpty) {
                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                                slidePanelClose();
                                const downloadMsg = SnackBar(
                                  content: Text('File berhasil dihapus'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(downloadMsg);
                                reloadData();
                              } else {
                                print(response.body);
                              }
                            } else {
                              print('Gagal menghapus data');
                            }
                          },
                        );
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Hapus Dokumen"),
                          content: Text(
                              "Apakah anda yakin untuk menghapus dokumen ini?"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );
                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          ),
                          Text('Hapus')
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
