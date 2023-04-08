import 'dart:io';

import 'package:best_flutter_ui_templates/design_storage/shared_folders_list_view.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    String dirname = "Dashboard";
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
            dirname = isiData[0].name;
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

  const SlideUpView(
      {Key? key,
      this.folder_id = "",
      this.name = "",
      this.desc = "",
      this.user_access = "",
      this.created_by = "",
      this.created_on = "",
      this.updated_on = "",
      this.file_url = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiFolders serviceAPI = ApiFolders();

    const snackBar = SnackBar(
      content: Text('Download berhasil'),
    );

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
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                          ),
                          icon: Icon(
                            // <-- Icon
                            Icons.edit,
                            size: 15.0,
                          ),
                          label: Text('Revisi'), // <-- Text
                        ),
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Pengaturan File'),
                                      content: Container(
                                        height: 300,
                                        width: 400,
                                        child:
                                            FutureBuilder<List<CategoryModel>>(
                                                future: serviceAPI
                                                    .getRevisionFile(folder_id),
                                                builder: (BuildContext context,
                                                    snapshot) {
                                                  if (snapshot.hasData) {
                                                    List<CategoryModel>?
                                                        isiData =
                                                        snapshot.data!;

                                                    return Container(
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              isiData.length,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1.0,
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
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Text(
                                                                              isiData[index].name,
                                                                              style: TextStyle(fontWeight: FontWeight.w400),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 5),
                                                                              child: Text(
                                                                                '(' + isiData[index].no_revision + ')',
                                                                                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                            'Updated : ' +
                                                                                isiData[index].updated_on,
                                                                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                                                        Text(
                                                                            'Oleh : ' +
                                                                                isiData[index].email,
                                                                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                Icon(
                                                                              Icons.refresh,
                                                                              color: Colors.amber,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                Icon(
                                                                              Icons.download,
                                                                              color: Colors.blue,
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
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Background color
                          ),
                          icon: Icon(
                            // <-- Icon
                            Icons.refresh,
                            size: 15.0,
                          ),
                          label: Text('Rollback'), // <-- Text
                        ),
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () async {
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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  // setState(() {
                                  //   _progress = null;
                                  // });
                                });
                          },
                          icon: Icon(
                            // <-- Icon
                            Icons.download,
                            size: 15.0,
                          ),
                          label: Text('Download'), // <-- Text
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
