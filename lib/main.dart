import 'Constant/Constant.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/LoginPage.dart';
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
        PROFILE: (BuildContext context) => LoginPage(),
      },
    )
  );
}
