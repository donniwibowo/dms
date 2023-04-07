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
import 'package:best_flutter_ui_templates/design_storage/models/category.dart';

import '../custom_widget/custom_widget.dart';

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

  ApiFolders serviceAPI = ApiFolders();
  late Future<List<CategoryModel>> listData;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    listData = serviceAPI.getAllFolder(widget.folder_parent_id, widget.keyword);
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

  @override
  Widget build(BuildContext context) {
    ScrollController sc = new ScrollController();

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 660,
        width: double.infinity,
        child: FutureBuilder<List<CategoryModel>>(
          // future: Provider.of<ApiFolders>(context, listen: false)
          //     .getAllFolder(widget.folder_parent_id, widget.keyword),
          future: listData,
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              List<CategoryModel>? isiData = snapshot.data!;
              if (isiData.length > 0) {
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 150, right: 16, left: 16),
                  itemCount: isiData.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = isiData.length > 10 ? 10 : isiData.length;

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
                                            isiData[index].folder_id)),
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
                                                      child:
                                                          isiData[index].type ==
                                                                  'Folder'
                                                              ? Icon(
                                                                  Icons.folder,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade200,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .picture_as_pdf,
                                                                  color: Colors
                                                                      .red
                                                                      .shade300,
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
                                                                  isiData[index]
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
                                                                isiData[index]
                                                                            .type ==
                                                                        'Folder'
                                                                    ? isiData[
                                                                            index]
                                                                        .type
                                                                    : isiData[
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
                                                                    isiData[index].size ==
                                                                            null
                                                                        ? ''
                                                                        : isiData[index]
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
                                                  child: PopupMenuButton<
                                                          String>(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                                  .circular(20)
                                                              .copyWith(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          0))),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      elevation: 10,
                                                      color:
                                                          Colors.grey.shade100,
                                                      itemBuilder:
                                                          (BuildContext
                                                                  context) =>
                                                              <
                                                                  PopupMenuEntry<
                                                                      String>>[
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value: 'view',
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.info_rounded,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Info',
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500),
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
                                                                  value: 'edit',
                                                                  enabled:
                                                                      isiData[index].is_owner ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.edit,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Edit',
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500),
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
                                                                  enabled:
                                                                      isiData[index].is_owner ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500),
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
                                                        if (value == 'view') {
                                                          slidePanelOn(
                                                              SlideUpView(
                                                            name: isiData[index]
                                                                .name,
                                                            desc: isiData[index]
                                                                .description,
                                                            user_access:
                                                                isiData[index]
                                                                    .user_access,
                                                            created_by:
                                                                isiData[index]
                                                                    .created_by,
                                                            created_on:
                                                                isiData[index]
                                                                    .created_on,
                                                            updated_on:
                                                                isiData[index]
                                                                    .updated_on,
                                                            file_url:
                                                                isiData[index]
                                                                    .file_url,
                                                          ));
                                                        }
                                                        if (value == 'delete') {
                                                          var folder_id =
                                                              isiData[index]
                                                                  .folder_id;
                                                          deleteData(folder_id);
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
              } else {
                return Container(
                  padding: EdgeInsets.only(left: 18, top: 15),
                  child: Text("Tidak ada data"),
                );
              }
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
