import 'dart:async';
import 'package:flutter_profile_page/Constant/Constant.dart';
import 'package:flutter_profile_page/Screens/ProfilePage.dart';
import 'package:flutter_profile_page/Screens/LoginPage.dart';
import 'package:flutter_profile_page/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';

main() {
  runApp(
    MaterialApp(
      title: 'Student Profile',
      theme: ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        //SPLASH_SCREEN: (BuildContext context) => MapScreen(),
        PROFILE: (BuildContext context) => ProfilePage(), //ProfilePage(),
      },
    )
  );
}
