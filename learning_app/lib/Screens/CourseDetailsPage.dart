import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'CoursePage.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseID;
  CourseDetailsPage(this.courseID);
  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState(courseID);
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final String courseID;
  CourseInfo courseInfo = CourseInfo(
    id: 'id',
    title: 'title',
    description: 'description',
    credit: 0,
    prereq: 'prereq,'
  );
  _CourseDetailsPageState(this.courseID);

  @override
  Widget build(BuildContext context) {
    _queryCourseInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('Course detail'),
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 0.0),
              child: Text(
                courseInfo.id,
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),
              child: Text(
                courseInfo.title,
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Number of credits: ' + courseInfo.credit.toString(),
                textScaleFactor: 1.2,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'Prerequities:\n' + courseInfo.prereq,
                textScaleFactor: 1.2,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'Description\n' + courseInfo.description,
                textScaleFactor: 1.2,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ), 
      ),
      
    );
  }

  @override
  void dispose() => super.dispose();

  void _queryCourseInfo() async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    final List<Map<String, dynamic>> res = await dbRef.query(
      'courses',
      distinct: true,
      where: 'id = \'' + courseID + '\'',
    );

    List<CourseInfo> queryRes = List.generate(res.length, (i) {
      return CourseInfo(
        id: res[i]['id'],
        title: res[i]['title'],
        description: res[i]['description'],
        credit: res[i]['credit'],
        prereq: res[i]['prereq'],
      );
    });

    if(this.mounted == true) setState(() => courseInfo = queryRes.first);
  }
}