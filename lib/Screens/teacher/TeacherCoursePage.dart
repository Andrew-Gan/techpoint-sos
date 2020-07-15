import '../../CreateDB.dart';
import 'TeacherAssignUpdatePage.dart';
import 'TeacherAssignCreatePage.dart';
import 'TeacherPeerCreatePage.dart';
import 'TeacherAssignSubmissionsPage.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TeacherCoursePage extends StatelessWidget {
  final String courseID;
  final String email;
  final List<String> assignQTitles;
  TeacherCoursePage(this.email, this.courseID, this.assignQTitles);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 25.0),
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
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 30.0),
                  child: Text(
                    'Assignments',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 10.0),
                  height: 380.0,
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
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        child: Text('Add assignment'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                            TeacherAssignCreatePage(courseID, email)
                          )
                        ),
                      ),
                      OutlineButton(
                        child: Text('Add peer review'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                            TeacherPeerCreatePage(courseID, email, assignQTitles)
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignQTitles[i],
      ),
      trailing: Container(
        width: 120,
        child: Row (
          children: <Widget> [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.update),
              onPressed: () async {
                var info = await _queryAssignInfo(assignQTitles[i], courseID);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherAssignUpdatePage(info),
                  ),
                );
              }
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () async {
                var assignQInfo = await _queryAssignInfo(assignQTitles[i], courseID);
                var assignSInfo = await _queryAssignSubmits(assignQInfo); 
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                      TeacherAssignSubmissionsPage(assignQInfo, assignSInfo),
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(String assignTitle, String courseID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentQuestionInfo.tableName,
      where: 'assignTitle = ? AND courseID = ?',
      whereArgs: [assignTitle, courseID],
    );
    dbRef.close();

    var queryRes = List.generate(res.length, (i) {
      return AssignmentQuestionInfo(
        assignTitle: res[i]['assignTitle'],
        courseID: res[i]['courseID'],
        content: res[i]['content'],
        dueDate: res[i]['dueDate'],
        instrEmail: res[i]['instrEmail'],
        maxScore: res[i]['maxScore'],
      );
    });

    return queryRes.first;
  }

  Future<List<AssignmentSubmissionInfo>> 
  _queryAssignSubmits(AssignmentQuestionInfo assignQTitles) async {
    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );

    final Database dbRef = await db;
    final List<Map<String, dynamic>> res = await dbRef.query(
      AssignmentSubmissionInfo.tableName,
      distinct: true,
      where: 'assignTitle = ? AND courseID = ?',
      whereArgs: [assignQTitles.assignTitle, assignQTitles.courseID],
    );
    dbRef.close();

    List<AssignmentSubmissionInfo> queryRes = List.generate(res.length, (i) {
      return AssignmentSubmissionInfo(
        assignTitle: res[i]['assignTitle'],
        courseID: res[i]['courseID'],
        content: res[i]['content'],
        submitDate: res[i]['submitDate'],
        studentEmail: res[i]['studentEmail'],
        recScore: res[i]['recScore'],
        remarks: res[i]['remarks'],
      );
    });

    return queryRes;
  }
}