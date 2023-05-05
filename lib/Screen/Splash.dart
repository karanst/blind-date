import 'dart:async';

import 'package:blind_date/Provider/SettingProvider.dart';
import 'package:blind_date/Screen/Intro_Slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Helper/Color.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';
import 'SignInUpAcc.dart';

class Splash extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    //  SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: colors.whiteTemp,
      //key: _scaffoldKey,
      // bottomNavigationBar:Image.asset(
      //   'assets/images/splash.png',
      // ),
      body: Container(
        // color: colors.primary,
        decoration: BoxDecoration(
          color: colors.whiteTemp,
          image: DecorationImage(
              image: AssetImage("assets/images/splashlogo.png"),
              // fit: BoxFit.cover
          ),
        ),
      )
    );
  }

  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(this.context, listen: false);

    bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    print("this is isfirsttime $isFirstTime");
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInUpAcc(),
          ));
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 1.0,
    ));
  }

  @override
  void dispose() {
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
