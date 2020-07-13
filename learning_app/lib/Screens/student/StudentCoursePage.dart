import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../CreateDB.dart';
import 'StudentAssignSubmitPage.dart';
import 'StudentAssignReviewPage.dart';
import 'package:flutter/material.dart';

class StudentCoursePage extends StatelessWidget {
  final String courseID;
  final String email;
  final List<String> assignQTitles;
  final int score;
  StudentCoursePage(this.email, this.courseID, this.assignQTitles, this.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 80,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: EdgeInsets.only(top: 20.0, left: 80.0),
                    width: 250.0,
                    height: 80.0,
                    child: Text(
                      score.toString() + ' / 1000',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0),
              child: Text(
                'Assignments',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0,),
              height: 150.0,
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
              padding: EdgeInsets.only(left: 25.0, top: 50.0),
              child: Text(
                'Peer Reviews to do',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0,),
              height: 150.0,
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
      ),
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignQTitles[i],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var assignQInfo = await _queryAssignInfo(assignQTitles[i]);
        var assignSInfo = await _queryAssignSubmits(assignQTitles[i]);
        if(assignQInfo.dueDate > now || assignSInfo == null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
              StudentAssignSubmitPage(email, assignQInfo)),
          );
        }
        else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
              StudentAssignReviewPage(assignQInfo, assignSInfo)),
          );
        }
      },
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(String assignTitle) async {
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

    return AssignmentQuestionInfo(
      assignTitle: res.first['assignTitle'],
      courseID: res.first['courseID'],
      content: res.first['content'],
      dueDate: res.first['dueDate'],
      instrEmail: res.first['instrEmail'],
      maxScore: res.first['maxScore'],
    );
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(String assignTitle) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      'assignmentSubmissions',
      where: 'assignTitle = ? AND courseID = ? AND studentEmail = ?',
      whereArgs: [assignTitle, courseID, email],
      orderBy: 'submitDate DESC'
    );

    dbRef.close();

    if(res.length < 1) {
      return null;
    }

    return AssignmentSubmissionInfo(
      assignTitle: res.first['assignTitle'],
      courseID: res.first['courseID'],
      content: res.first['content'],
      submitDate: res.first['submitDate'],
      studentEmail: res.first['studentEmail'],
      recScore: res.first['recScore'],
      remarks: res.first['remarks'],
    );
  }
}