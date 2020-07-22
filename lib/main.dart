import 'Screens/SplashScreen.dart';
import 'Screens/LoginPage.dart';
import 'package:flutter/material.dart';

/// Start program.
/// 
/// Display splash screen and load login page.
main() {
  runApp(
    MaterialApp(
      title: 'Main',
      theme: ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/ProfilePage': (BuildContext context) => LoginPage(),
      },
    )
  );
}
