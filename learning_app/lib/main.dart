import 'dart:async';
import 'package:flutter_profile_page/Constant/Constant.dart';
import 'package:flutter_profile_page/Screens/LoginPage.dart';
import 'package:flutter_profile_page/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';

main() {
  runApp(
    new MaterialApp(
      title: 'Student Profile',
      theme: new ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        //SPLASH_SCREEN: (BuildContext context) => new MapScreen(),
        PROFILE: (BuildContext context) => new LoginPage(), //new ProfilePage(),
      },
    )
  );
}
