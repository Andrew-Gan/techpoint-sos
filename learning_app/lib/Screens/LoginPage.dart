import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'ProfilePage.dart';
import '../create_db.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode myFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isInvalid = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {

    void onLoginPress() async {
      // insert test database
      createDB();

      final Future<Database> db = openDatabase(
        join(await getDatabasesPath(), 'account_database.db'),
      );

      final Database dbRef = await db; // capture a reference of the future type
      final List<Map<String, dynamic>> res = await dbRef.query(
        'accounts',
        distinct: true,
        where: 'email = \'' + emailController.text + '\' AND password = \'' +
          passwordController.text + '\'',
      );
      List<AccountInfo> queryRes = List.generate(res.length, (i) {
        return AccountInfo(
          name: res[i]['name'],
          email: res[i]['email'],
          major: res[i]['major'],
          year: res[i]['year'],
          college: res[i]['college'],
        );
      });

      dbRef.close();
      db.whenComplete(() => null);
      if (queryRes.length == 0)
        setState(() => isInvalid = true);
      else {
        setState(() => isInvalid = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(queryRes.first)
        ));
      }
    }

    return Scaffold(
        body: Container(
      color: Colors.blueGrey,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 260.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 300.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'assets/images/login.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email ID',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: "Enter email ID"),
                                  controller: emailController,
                                  enabled: true,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: "Enter password"),
                                  controller: passwordController,
                                  enabled: true,
                                  obscureText: true,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 35.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Visibility(
                                child: Text(
                                  'Incorrect email or password provided',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                                replacement: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                visible: isInvalid,
                              ),
                            ],
                          )),
                      Center(
                          heightFactor: 2,
                          child: OutlineButton(
                            onPressed: onLoginPress,
                            child: Text('LOGIN'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class AccountInfo {
  final String name;
  final String email;
  final String major;
  final String year;
  final String college;
  final String password;

  AccountInfo({this.name, this.email, this.major,this.year, this.college,
    this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'major': major,
      'year': year,
      'college': college,
      'password': password,
    };
  }
}