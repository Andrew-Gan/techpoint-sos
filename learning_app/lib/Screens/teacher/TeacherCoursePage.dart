import '../../CreateDB.dart';
import 'TeacherAssignUpdatePage.dart';
import 'TeacherAssignSubmissionsPage.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TeacherCoursePage extends StatefulWidget {
  final String email;
  final String courseID;
  final List<AssignmentQuestionInfo> assignQInfo;
  TeacherCoursePage(this.email, this.courseID, this.assignQInfo);

  @override
  State<TeacherCoursePage> createState() => _TeacherCoursePageState(email, courseID, assignQInfo);
}

class _TeacherCoursePageState extends State<TeacherCoursePage> {
  final String courseID;
  final String email;
  final List<AssignmentQuestionInfo> assignQInfo;
  _TeacherCoursePageState(this.email, this.courseID, this.assignQInfo);

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
                        padding: EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: Text(
                            courseID,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
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
                                if (index >= assignQInfo.length) return null;
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
        assignQInfo[i].assignTitle,
      ),
      trailing: Container(
        width: 120,
        child: Row (
          children: <Widget> [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.update),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TeacherAssignUpdatePage(assignQInfo[i]),
                ),
              )
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () async {
                var assignSInfo = await _queryAssignSubmits(assignQInfo[i]); 
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherAssignSubmissionsPage(assignSInfo),
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() => super.dispose();

  Future<List<AssignmentSubmissionInfo>> 
  _queryAssignSubmits(AssignmentQuestionInfo assignQInfo) async {
    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );

    final Database dbRef = await db; // capture a reference of the future type
    final List<Map<String, dynamic>> res = await dbRef.query(
      'assignmentSubmissions',
      distinct: true,
      where: 'assignTitle == \'' + assignQInfo.assignTitle + '\' AND '
      'courseID == \'' + assignQInfo.courseID + '\'',
    );
    List<AssignmentSubmissionInfo> queryRes = List.generate(res.length, (i) {
      return AssignmentSubmissionInfo(
        assignTitle: res[i]['assignTitle'],
        courseID: res[i]['courseID'],
        content: res[i]['content'],
        submitDate: res[i]['submitDate'],
        studentEmail: res[i]['studentEmail'],
      );
    });

    return queryRes;
  }
}