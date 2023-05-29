import 'dart:async';
import 'package:flutter/material.dart';
import 'introduction_animation/introduction_animation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';

class SplashSreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashSreen> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //sharedPreferences.clear();
    //sharedPreferences.commit();
    if (sharedPreferences.getString("user_token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => DesignHomeScreen(
                    folder_parent_id: "0",
                  )),
          (Route<dynamic> route) => false);
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => IntroductionAnimationScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        color: Colors.white,
        child: Image.asset(
          'assets/images/splash_screen.png',
          height: height,
          width: width,
        ));
  }
}
