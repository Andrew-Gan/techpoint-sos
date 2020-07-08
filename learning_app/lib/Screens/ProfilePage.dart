import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'CoursePage.dart';
import '../CreateDB.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProfilePage extends StatefulWidget {
  final AccountInfo userinfo;
  ProfilePage(this.userinfo);

  @override
  State<ProfilePage> createState() => _ProfilePageState(userinfo);
}

class _ProfilePageState extends State<ProfilePage> {
  final AccountInfo userinfo;
  List<String> regCourses;
  List<AssignmentQuestionInfo> assignQInfo;

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
    String courseID = regCourses[index];
    return ListTile(
      title: Text(
        courseID,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        _queryAssignmentInfo(courseID);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CoursePage(userinfo.email, courseID, assignQInfo),
        ),);
      },
    );
  }

  @override
  void dispose() => super.dispose();

  void _queryAssignmentInfo(String courseID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    final List<Map<String, dynamic>> res = await dbRef.query(
      'assignmentQuestions',
      distinct: true,
      where: 'courseID = \'' + courseID + '\'',
      orderBy: 'dueDate',
    );

    List<AssignmentQuestionInfo> queryRes = List.generate(res.length, (i) {
      return AssignmentQuestionInfo(
        assignTitle: res[i]['assignTitle'],
        courseID: res[i]['courseID'],
        imageB64: res[i]['imageB64'],
        content: res[i]['content'],
        dueDate: res[i]['dueDate'],
        instrEmail: res[i]['instrEmail'],
      );
    });

    if(this.mounted == true) setState(() => assignQInfo = queryRes);
  }
}
