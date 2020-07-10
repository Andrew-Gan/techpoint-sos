import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../CreateDB.dart';
import 'StudentAssignPage.dart';
import 'package:flutter/material.dart';

class StudentCoursePage extends StatefulWidget {
  final String email;
  final String courseID;
  final List<String> assignQTitles;
  StudentCoursePage(this.email, this.courseID, this.assignQTitles);

  @override
  State<StudentCoursePage> createState() => 
    _StudentCoursePageState(email, courseID, assignQTitles);
}

class _StudentCoursePageState extends State<StudentCoursePage> {
  final String courseID;
  final String email;
  final List<String> assignQTitles;
  _StudentCoursePageState(this.email, this.courseID, this.assignQTitles);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course'),
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
                              color: Colors.white,
                              child: Text(
                                courseID,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20.0, left: 90.0),
                              width: 250.0,
                              height: 80.0,
                              child: Text(
                                '0 / 1000',
                                style: TextStyle(fontSize: 30.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 50.0),
                            child: Text(
                              'Assignments',
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
                                if (index >= assignQTitles.length) return null;
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

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignQTitles[i],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        var info = await _queryAssignInfo(assignQTitles[i], courseID);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StudentAssignPage(email, info)),
        );
      },
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(String assignTitle, String courseID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      'assignmentQuestions',
      where: 'assignTitle = ? AND courseID = ?',
      whereArgs: [assignTitle, courseID],
    );

    dbRef.close();

    var queryRes = List.generate(res.length, (i) {
      return AssignmentQuestionInfo(
        assignTitle: res[i]['assignTitle'],
        courseID: res[i]['courseID'],
        imageB64: res[i]['imageB64'],
        content: res[i]['content'],
        dueDate: res[i]['dueDate'],
        instrEmail: res[i]['instrEmail'],
        maxScore: res[i]['maxScore'],
      );
    });

    return queryRes.first;
  }

  @override
  void dispose() => super.dispose();
}