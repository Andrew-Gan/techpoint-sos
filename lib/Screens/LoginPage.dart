import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import '../CreateDB.dart';
import '../REST_API.dart';

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
                onPressed: () => onLoginPress(context),
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

  void onLoginPress(BuildContext context) async {
    var map = await restLogin(emailController.text, passwordController.text);
    
    emailController.clear();
    passwordController.clear();

    if (map == null)
      setState(() => isInvalid = true);
    else {
      AccountInfo userInfo = AccountInfo.fromMap(map);
      setState(() => isInvalid = false);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
          ProfilePage(userInfo),
        )
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}