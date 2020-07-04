import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
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
                                  image: ExactAssetImage('assets/images/login.png'),
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
                  padding: EdgeInsets.only(bottom: 20.0),
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
                      Center(
                        heightFactor: 4,
                        child: OutlineButton(
                          onPressed: onLoginPress,
                          child: Text('LOGIN'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                        )
                      ),
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

  void onLoginPress() async {
    // to be removed after debug completed
    log('Email is ' + emailController.text);
    log('PassWord is ' + passwordController.text);

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'account_database.db'),
      onCreate: (db, version) async {
        return await db.execute(
          'CREATE TABLE accounts(name TEXT, email TEXT, password TEXT, major TEXT, year TEXT, college TEXT)',
        );
      },
      version: 1
    );
    final Database dbRef = await db; // capture a reference of the future type
    final List<Map<String, dynamic>> res = await dbRef.query(
      'accounts',
      distinct: true,
      where: 'email = \'' + emailController.text + '\' AND password = \'' + passwordController.text + '\'',
    );
    List<AccountInfo> queryRes = List.generate(res.length, (i) {
      return AccountInfo(
        name: res[i]['name'],
        email: res[i]['email'],
        major: res[i]['major'],
        year: res[i]['year'],
        college: res[i]['college'],
        password: res[i]['password'],
      );
    });
    log(queryRes.toString());
    db.whenComplete(() => null);
  }
}

class AccountInfo {
  final String name;
  final String email;
  final String major;
  final String year;
  final String college;
  final String password;

  AccountInfo(
    {this.name, this.email, this.major, this.year, this.college, this.password}
  );

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