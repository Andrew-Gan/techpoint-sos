import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../CreateDB.dart';
import 'StudentAssignSubmitPage.dart';
import 'StudentAssignReviewPage.dart';
import 'package:flutter/material.dart';
import './PeerReviewPage.dart';

class StudentCoursePage extends StatelessWidget {
  final String courseID;
  final AccountInfo studentInfo;
  final List<AssignmentQuestionInfo> assignQInfos;
  final int score;
  StudentCoursePage(this.studentInfo, this.courseID, this.assignQInfos, this.score);

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
                  padding: EdgeInsets.only(top: 20.0, left: 50.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Text(
                          courseID,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                  ),
                  height: 300.0,
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, i) {
                        final index = i ~/ 2;
                        if (index >= assignQInfos.length) return null;
                        if (i.isOdd) return Divider();
                        return _buildAssignRow(context, index);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            List<String> peerReviewTitles = await _queryPeerReviewInfo();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PeerReviewPage(studentInfo.email, courseID, peerReviewTitles);
            }));
            // Add your onPressed code here!
          },
          label: Text('Peer Review'),
          //icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.grey),
    );
  }

  Widget _buildAssignRow(BuildContext context, int i) {
    return ListTile(
      title: Text(assignQInfos[i].assignTitle,),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var assignQInfo = await _queryAssignInfo(assignQInfos[i].assignID);
        var assignSInfo = await _queryAssignSubmits(assignQInfos[i].assignID);
        if (assignQInfo.dueDate > now || assignSInfo == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    StudentAssignSubmitPage(studentInfo.accountID, assignQInfo)),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    StudentAssignReviewPage(assignQInfo, assignSInfo)),
          );
        }
      },
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentQuestionInfo.tableName,
      where: 'assignID = ?',
      whereArgs: [assignID],
    );

    dbRef.close();

    return AssignmentQuestionInfo.fromMap(res.first);
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(int assignID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentSubmissionInfo.tableName,
      where: 'assignID = ? AND studentID = ?',
      whereArgs: [assignID, studentInfo.accountID],
    );

    dbRef.close();

    if (res.length < 1) {
      return null;
    }

    return AssignmentSubmissionInfo.fromMap(res.first);
  }

  Future<List<String>> _queryPeerReviewInfo() async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db')
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      PeerReviewInfo.tableName,
      where: 'reviewerID = ?',
      whereArgs: [studentInfo.accountID],
    );

    List<String> ret = List.generate(res.length, (index) => res[index]['assignTitle']);
    return ret.toSet().toList();
  }
}
