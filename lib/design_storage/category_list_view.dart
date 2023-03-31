import 'package:best_flutter_ui_templates/design_storage/design_app_theme.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:best_flutter_ui_templates/settings.dart';
import 'package:best_flutter_ui_templates/design_storage/detail_files_list_view.dart';
import 'package:http/http.dart' as http;
import '../controller.dart';

class CategoryListView extends StatefulWidget {
  // final PanelController slidingUpController;
  final String folder_parent_id;
  final String keyword;
  const CategoryListView(
      {Key? key, this.callBack, this.folder_parent_id = "0", this.keyword = ""})
      : super(key: key);

  final Function()? callBack;
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("user_token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginView()),
          (Route<dynamic> route) => false);
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  int folders_length = 0;

  Widget _attributeDetail(String name, String desc, String user_access,
      String created_by, String created_on, String updated_on) {
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
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Nama : ',
                    ),
                  ),
                  Text(name)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Deskripsi : '),
                  ),
                  Text(desc)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Akses : '),
                  ),
                  Flexible(child: Text(user_access))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Dibuat Oleh : '),
                  ),
                  Text(created_by)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Tanggal Dibuat : '),
                  ),
                  Text(created_on)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Tanggal Diperbaharui : '),
                  ),
                  Text(updated_on)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController sc = new ScrollController();
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 660,
        width: double.infinity,
        child: FutureBuilder(
          future: Provider.of<ApiFolders>(context, listen: false)
              .getAllFolder(widget.folder_parent_id, widget.keyword),
          builder: (BuildContext context, snapshot) {
            // print(snapshot);
            // print('masuk sini');
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Consumer<ApiFolders>(builder: (context, data, _) {
                folders_length = data.dataFolders.length;
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 150, right: 16, left: 16),
                  itemCount: data.dataFolders.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = data.dataFolders.length > 10
                        ? 10
                        : data.dataFolders.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    return InkWell(
                      onTap: () {
                        // handle tap on item
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DesignHomeScreen(
                                        folder_parent_id:
                                            data.dataFolders[index].folder_id)),
                            (Route<dynamic> route) => false);
                      },
                      child: AnimatedBuilder(
                        animation: animationController!,
                        builder: (BuildContext context, Widget? child) {
                          return FadeTransition(
                            opacity: animation,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 50 * (1.0 - animation.value), 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                child: SizedBox(
                                  // height: 100,
                                  child: Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: <Widget>[
                                      Container(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 15),
                                                      child: data
                                                                  .dataFolders[
                                                                      index]
                                                                  .type ==
                                                              'Folder'
                                                          ? Icon(
                                                              Icons.folder,
                                                              color: Colors.blue
                                                                  .shade200,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              color: Colors
                                                                  .red.shade300,
                                                            ),
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  data
                                                                      .dataFolders[
                                                                          index]
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        0.27,
                                                                    color: DesignAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                data.dataFolders[index].type ==
                                                                        'Folder'
                                                                    ? data
                                                                        .dataFolders[
                                                                            index]
                                                                        .type
                                                                    : data
                                                                        .dataFolders[
                                                                            index]
                                                                        .format,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100,
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.27,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade300,
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              15),
                                                                  child: Text(
                                                                    data.dataFolders[index].size ==
                                                                            null
                                                                        ? ''
                                                                        : data
                                                                            .dataFolders[index]
                                                                            .size
                                                                            .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      fontSize:
                                                                          13,
                                                                      letterSpacing:
                                                                          0.27,
                                                                      color: DesignAppTheme
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  child:
                                                      PopupMenuButton<String>(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                      .circular(
                                                                          20)
                                                                  .copyWith(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              0))),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          elevation: 10,
                                                          color: Colors
                                                              .grey.shade100,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  <
                                                                      PopupMenuEntry<
                                                                          String>>[
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                          'view',
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.info_rounded,
                                                                                size: 20,
                                                                                color: Colors.green,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                'Info',
                                                                                style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                          'edit',
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.edit,
                                                                                size: 20,
                                                                                color: Colors.green,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                'Edit',
                                                                                style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                          'delete',
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
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
                                                                                'Delete',
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
                                                              (String value) {
                                                            // Handle menu item selection here
                                                            if (value ==
                                                                'view') {
                                                              var name = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .name;
                                                              var description = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .description;
                                                              var user_access = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .user_access;
                                                              var created_by = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .created_by;

                                                              var created_on = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .created_on;

                                                              var updated_on = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .updated_on;

                                                              // Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder:
                                                              //           (context) =>
                                                              //               Settings()),
                                                              // );
                                                              slidePanelOn(_attributeDetail(
                                                                  name,
                                                                  description,
                                                                  user_access,
                                                                  created_by,
                                                                  created_on,
                                                                  updated_on));

                                                              // showViewDialog(
                                                              //     context,
                                                              //     name,
                                                              //     description,
                                                              //     user_access,
                                                              //     created_by);
                                                            }
                                                            if (value ==
                                                                'delete') {
                                                              var folder_id = data
                                                                  .dataFolders[
                                                                      index]
                                                                  .folder_id;
                                                              deleteData(
                                                                  folder_id);
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.black,
                                                              size: 20,
                                                            ),
                                                          )),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              });
            }
          },
        ),
      ),
    );
  }

  showViewDialog(BuildContext context, String name, String description,
      String user_access, String created_by) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("File Attribute"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name : ' + name),
          SizedBox(height: 10),
          Text('Description : ' + (description == '' ? '-' : description)),
          SizedBox(height: 10),
          Text('User Access : ' + user_access),
          SizedBox(height: 10),
          Text('Created By : ' + created_by),
        ],
      ),
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

  //delete folder
  deleteData(String folder_id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'file_id': folder_id};
    var user_token = sharedPreferences.getString("user_token");
    var jsonResponse = null;
    final response = await http.post(
        "https://192.168.1.119/leap_integra/master/dms/api/files/delete?user_token=" +
            user_token!,
        body: data);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        showAlertDialog(context, 'File Deleted');
      } else {
        showAlertDialog(context, 'Failed Delete Data' + response.body);
      }
      setState(() {});
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
}
