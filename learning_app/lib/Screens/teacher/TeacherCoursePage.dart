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
  final List<String> assignQTitles;
  TeacherCoursePage(this.email, this.courseID, this.assignQTitles);

  @override
  State<TeacherCoursePage> createState() => _TeacherCoursePageState(email, courseID, assignQTitles);
}

class _TeacherCoursePageState extends State<TeacherCoursePage> {
  final String courseID;
  final String email;
  final List<String> assignQTitles;
  _TeacherCoursePageState(this.email, this.courseID, this.assignQTitles);

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
                var info = await _queryAssignInfo(assignQTitles[i], courseID);
                var assignSInfo = await _queryAssignSubmits(info); 
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

  Future<List<AssignmentSubmissionInfo>> 
  _queryAssignSubmits(AssignmentQuestionInfo assignQTitles) async {
    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );

    final Database dbRef = await db;
    final List<Map<String, dynamic>> res = await dbRef.query(
      'assignmentSubmissions',
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
      );
    });

    return queryRes;
  }
}