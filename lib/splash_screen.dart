import 'dart:async';
import 'package:flutter/material.dart';
import 'introduction_animation/introduction_animation_screen.dart';

class SplashSreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<SplashSreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    IntroductionAnimationScreen()
            )
        )
    ); 
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Container(
        color: Colors.white,
        child:
        Image.asset(
          'assets/images/splash_screen.png',
          height: height,
          width: width,
        )
    );
  }
}