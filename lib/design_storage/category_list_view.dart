import 'package:best_flutter_ui_templates/design_storage/design_app_theme.dart';
import 'package:best_flutter_ui_templates/design_storage/models/category.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 660,
        width: double.infinity,
        child: FutureBuilder(
          future:
              Provider.of<ApiFolders>(context, listen: false).getAllFolder(),
          builder: (BuildContext context, snapshot) {
            print(snapshot);
            print('masuk sini');
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Consumer<ApiFolders>(builder: (context, data, _) {
                folders_length = data.dataFolders.length;
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 16, left: 16),
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
                    return AnimatedBuilder(
                      animation: animationController!,
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                          opacity: animation!,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 50 * (1.0 - animation!.value), 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              child: SizedBox(
                                height: 100,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: HexColor('#F8FAFB'),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16.0)),
                                                // border: new Border.all(
                                                //     color: DesignAppTheme.notWhite),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      height: 1.0,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16,
                                                                    left: 16,
                                                                    right: 16),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
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
                                                                Container(
                                                                  child:
                                                                      PopupMenuButton<
                                                                          String>(
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context) =>
                                                                            <PopupMenuEntry<String>>[
                                                                      PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            'edit',
                                                                        child: Text(
                                                                            'Edit'),
                                                                      ),
                                                                      PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            'delete',
                                                                        child: Text(
                                                                            'Delete'),
                                                                      ),
                                                                    ],
                                                                    onSelected:
                                                                        (String
                                                                            value) {
                                                                      // Handle menu item selection here
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .settings,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8,
                                                                    left: 16,
                                                                    right: 16,
                                                                    bottom: 8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  data
                                                                      .dataFolders[
                                                                          index]
                                                                      .type,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0.27,
                                                                    color:
                                                                        DesignAppTheme
                                                                            .grey,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        data.dataFolders[index].size ==
                                                                                null
                                                                            ? 'Unknown Size'
                                                                            : data.dataFolders[index].size.toString(),
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w200,
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0.27,
                                                                          color:
                                                                              DesignAppTheme.grey,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: DesignAppTheme
                                                                            .nearlyBlue,
                                                                        size:
                                                                            20,
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
                                                  ),
                                                  const SizedBox(
                                                    width: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
}
