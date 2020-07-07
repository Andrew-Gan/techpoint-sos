import 'dart:async';
import '../CreateDB.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseID;
  CourseDetailsPage(this.courseID);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState(courseID);
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final String courseID;
  List<AssignmentQuestionInfo> assignQInfo;
  _CourseDetailsPageState(this.courseID);

  @override
  Widget build(BuildContext context) {
    _queryAssignmentInfo();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course details'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i ~/ 2;
          if (index >= assignQInfo.length) return null;
          if (i.isOdd) return Divider();
          return _buildRow(context, index);
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(
      title: Text(
        assignQInfo[index].assignTitle,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: null,
    );
  }

  @override
  void dispose() => super.dispose();

  void _queryAssignmentInfo() async {
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