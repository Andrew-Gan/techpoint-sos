import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'CourseDetailsPage.dart';
import '../CreateDB.dart';

class ProfilePage extends StatefulWidget {
  final AccountInfo userinfo;
  ProfilePage(this.userinfo);

  @override
  State<ProfilePage> createState() => _ProfilePageState(userinfo);
}

class _ProfilePageState extends State<ProfilePage> {
  final AccountInfo userinfo;
  List<String> regCourses;
  final FocusNode myFocusNode = FocusNode();

  _ProfilePageState(this.userinfo) {
    regCourses = this.userinfo.regCourse.split(',');
  }

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Profile'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 80,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 50.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: ExactAssetImage('assets/images/as.png'),
                                ),
                              )
                            ),
                            Container(
                              color: Color(0xffFFFFFF),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Name',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                      top: 5.0
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              userinfo.name,
                                              style: TextStyle(fontSize: 16.0,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                      top: 15.0
                                    ),
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
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                      top: 5.0
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              userinfo.email,
                                              style: TextStyle(fontSize: 16.0,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                      top: 15.0
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'College',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 25.0,
                                      top: 5.0
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              userinfo.college,
                                              style: TextStyle(fontSize: 16.0,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 50.0),
                            child: Text(
                              'Registered courses',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            height: 200.0,
                            child: ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              itemBuilder: (context, i) {
                                final index = i ~/ 2;
                                if (index >= regCourses.length) return null;
                                if (i.isOdd) return Divider();
                                return _buildRow(context, index);
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(
      title: Text(
        regCourses[index],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CourseDetailsPage(regCourses[index]),
        ),);
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
