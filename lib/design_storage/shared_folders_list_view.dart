import 'package:best_flutter_ui_templates/design_storage/design_app_theme.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:best_flutter_ui_templates/provider/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import 'home_design.dart';

class SharedFoldersListView extends StatefulWidget {
  // final PanelController slidingUpController;
  const SharedFoldersListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _SharedFoldersListViewState createState() => _SharedFoldersListViewState();
}

class _SharedFoldersListViewState extends State<SharedFoldersListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
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

  void reloadData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScrollController sc = new ScrollController();
    double c_width = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 660,
        width: double.infinity,
        child: FutureBuilder(
          future:
              Provider.of<ApiFolders>(context, listen: false).getSharedFolder(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Consumer<ApiFolders>(builder: (context, data, _) {
                folders_length = data.dataSharedFolder.length;
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 150, right: 16, left: 16),
                  itemCount: data.dataSharedFolder.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = data.dataSharedFolder.length > 10
                        ? 10
                        : data.dataSharedFolder.length;
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
                                        folder_parent_id: data
                                            .dataSharedFolder[index]
                                            .folder_id)),
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
                                                                  .dataSharedFolder[
                                                                      index]
                                                                  .type ==
                                                              'Folder'
                                                          ? Icon(
                                                              data.dataSharedFolder[index]
                                                                          .is_shared ==
                                                                      "1"
                                                                  ? Icons.folder_shared
                                                                  : Icons.folder,
                                                              color: Colors.blue
                                                                  .shade200,
                                                            )
                                                          : Icon(
                                                              data.dataSharedFolder[index].format ==
                                                                      'pdf'
                                                                  ? MyFlutterApp
                                                                      .file_pdf
                                                                  : MyFlutterApp
                                                                      .file_word,
                                                              color: data
                                                                          .dataSharedFolder[
                                                                              index]
                                                                          .format ==
                                                                      'pdf'
                                                                  ? Colors.red
                                                                  : Colors.blue,
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
                                                                Container(
                                                                  width:
                                                                      c_width,
                                                                  child: Text(
                                                                    data
                                                                        .dataSharedFolder[
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
                                                                data.dataSharedFolder[index].type ==
                                                                        'Folder'
                                                                    ? data
                                                                        .dataSharedFolder[
                                                                            index]
                                                                        .type
                                                                    : data
                                                                        .dataSharedFolder[
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
                                                                    data.dataSharedFolder[index].size ==
                                                                            null
                                                                        ? ''
                                                                        : data
                                                                            .dataSharedFolder[index]
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
                                                          borderRadius: BorderRadius.circular(20).copyWith(
                                                              topRight:
                                                                  Radius.circular(
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
                                                                  value: 'atur',
                                                                  enabled: data
                                                                              .dataSharedFolder[index]
                                                                              .is_owner ==
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
                                                                            Icons.settings,
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
                                                                            'Pengaturan',
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
                                                            folder_id: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .folder_id,
                                                            name: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .name,
                                                            desc: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .description,
                                                            user_access: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .user_access,
                                                            created_by: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .created_by,
                                                            created_on: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .created_on,
                                                            updated_on: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .updated_on,
                                                            file_url: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .file_url,
                                                            type: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .type,
                                                          ));
                                                        }

                                                        if (value == 'atur') {
                                                          slidePanelOn(
                                                              SlideUpSetting(
                                                            folder_parent_id: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .folder_parent_id,
                                                            folder_id: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .folder_id,
                                                            name: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .name,
                                                            desc: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .description,
                                                            user_access: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .user_access,
                                                            created_by: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .created_by,
                                                            created_on: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .created_on,
                                                            updated_on: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .updated_on,
                                                            file_url: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .file_url,
                                                            type: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .type,
                                                            is_owner: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .is_owner,
                                                            perihal: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .perihal,
                                                            nomor: data
                                                                .dataSharedFolder[
                                                                    index]
                                                                .nomor,
                                                            reloadData:
                                                                reloadData,
                                                          ));
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
}
