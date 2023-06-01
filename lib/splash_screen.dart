import 'dart:async';
import 'dart:convert';
import 'package:best_flutter_ui_templates/login_view.dart';
import 'package:flutter/material.dart';
import 'introduction_animation/introduction_animation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:http/http.dart' as http;

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

    var user_token = sharedPreferences.getString("user_token");
    if (user_token != null) {
      var api_url =
          'http://34.101.208.151/agutask/dms/api/user/islogin?user_token=' +
              user_token;
      var response = await http.get(Uri.parse(api_url));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 0) {
        sharedPreferences.clear();
        sharedPreferences.commit();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginView()));
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => DesignHomeScreen(
                      folder_parent_id: "0",
                    )),
            (Route<dynamic> route) => false);
      }
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
