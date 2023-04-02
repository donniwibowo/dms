import 'package:best_flutter_ui_templates/design_storage/design_app_theme.dart';
import 'package:best_flutter_ui_templates/provider/api_folders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import 'home_design.dart';

class RecentActivitiesListView extends StatefulWidget {
  // final PanelController slidingUpController;
  const RecentActivitiesListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _RecentActivitiesListViewState createState() =>
      _RecentActivitiesListViewState();
}

class _RecentActivitiesListViewState extends State<RecentActivitiesListView>
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
              .getRecentActivities(),
          builder: (BuildContext context, snapshot) {
            print(snapshot);
            print('masuk sini');
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Consumer<ApiFolders>(builder: (context, data, _) {
                folders_length = data.dataRecentActivities.length;
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 150, right: 16, left: 16),
                  itemCount: data.dataRecentActivities.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = data.dataRecentFolders.length > 10
                        ? 10
                        : data.dataRecentActivities.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    return InkWell(
                      onTap: () {},
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
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        data
                                                            .dataRecentActivities[
                                                                index]
                                                            .name,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          letterSpacing: 0.27,
                                                          color: DesignAppTheme
                                                              .darkerText,
                                                        )),
                                                    Text(
                                                        data
                                                            .dataRecentActivities[
                                                                index]
                                                            .created_on,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          letterSpacing: 0.27,
                                                          color: Colors
                                                              .grey.shade400,
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 340,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 15),
                                                      child: Text(data
                                                          .dataRecentActivities[
                                                              index]
                                                          .description),
                                                    ),
                                                  ],
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
}
