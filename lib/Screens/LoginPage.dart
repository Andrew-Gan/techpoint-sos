import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'ProfilePage.dart';
import '../CreateDB.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isInvalid = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    // createDB();
    void onLoginPress() async {
      final Future<Database> db = openDatabase(
        join(await getDatabasesPath(), 'learningApp_database.db'),
      );

      final Database dbRef = await db; // capture a reference of the future type
      final List<Map<String, dynamic>> res = await dbRef.query(
        AccountInfo.tableName,
        distinct: true,
        where: 'email = ? AND password = ?',
        whereArgs: [emailController.text, passwordController.text],
      );
      List<AccountInfo> queryRes = List.generate(res.length, (i) {
        return AccountInfo(
          name: res[i]['name'],
          email: res[i]['email'],
          major: res[i]['major'],
          year: res[i]['year'],
          college: res[i]['college'],
          regCourse: res[i]['regCourse'],
          privilege: res[i]['privilege'],
          receivedScore: res[i]['receivedScore'],
          deductedScore: res[i]['deductedScore'],
        );
      });

      dbRef.close();
      emailController.clear();
      passwordController.clear();

      if (queryRes.length == 0)
        setState(() => isInvalid = true);
      else {
        setState(() => isInvalid = false);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>
            ProfilePage(queryRes.first),
          )
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Login'),
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(100.0),
              width: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: ExactAssetImage('assets/images/login.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Text(
                'Email ID',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 2.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Enter email ID"),
                controller: emailController,
                enabled: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
              child: TextField(
                decoration: const InputDecoration(hintText: "Enter password"),
                controller: passwordController,
                enabled: true,
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 35.0),
              child: Visibility(
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
            ),
            Center(
              heightFactor: 2,
              child: OutlineButton(
                onPressed: onLoginPress,
                child: Text('LOGIN'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}