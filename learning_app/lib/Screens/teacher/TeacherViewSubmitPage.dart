import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class TeacherViewSubmitPage extends StatefulWidget {
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;
  TeacherViewSubmitPage(this.assignQInfo, this.assignSInfo);

  @override
  State<TeacherViewSubmitPage> createState() =>
    _TeacherViewSubmitPageState(assignQInfo, assignSInfo);
}

class _TeacherViewSubmitPageState extends State<TeacherViewSubmitPage> {
  final FocusNode myFocusNode = FocusNode();
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;
  final remarksController = TextEditingController();
  DateTime submitDate;
  int newScore;

  _TeacherViewSubmitPageState(this.assignQInfo, this.assignSInfo) {
    newScore = assignSInfo.recScore;
    remarksController.text = assignSInfo.remarks;
    submitDate = DateTime.fromMillisecondsSinceEpoch(assignSInfo.submitDate);
  }

  bool isGraded = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Student Submission'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 80,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          assignSInfo.assignTitle,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            assignSInfo.studentEmail,
                            style: TextStyle(fontSize: 16.0,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            submitDate.year.toString() + '-' +
                            submitDate.month.toString() + '-' +
                            submitDate.day.toString() + ' ' +
                            submitDate.hour.toString() + ':' +
                            submitDate.minute.toString(),
                            style: TextStyle(fontSize: 16.0,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 20.0),
                    child: Text(
                      assignSInfo.content,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 180.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter review here...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                            controller: remarksController,
                            enabled: true,
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 20.0),
                    child: DropdownButton(
                      value: newScore,
                      items: List<int>.generate(assignQInfo.maxScore+1, (i)=>i)
                        .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                          value: i,
                          child: Text(i.toString()),
                        )).toList(),
                      onChanged: (int newValue) => 
                        setState(() => newScore = newValue)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Visibility(
                      child: Text(
                        'Assignment graded successfully',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                      replacement: Text(
                        '',
                        style: TextStyle(fontSize: 16.0,),
                      ),
                      visible: isGraded,
                    ),
                  ),
                  Center(
                    child: OutlineButton(
                      onPressed: onUpdatePress,
                      child: Text('UPDATE'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  void onUpdatePress() async {
    isGraded = true;

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;
    
    await dbRef.update(
      'assignmentSubmissions',
      AssignmentSubmissionInfo(
        assignTitle: assignSInfo.assignTitle,
        courseID: assignSInfo.courseID,
        content: assignSInfo.content,
        submitDate: assignSInfo.submitDate,
        studentEmail: assignSInfo.studentEmail,
        recScore: newScore,
        remarks: remarksController.text,
      ).toMap(),
      where: 'assignTitle = ? AND courseID = ? AND studentEmail = ?',
      whereArgs: [assignSInfo.assignTitle, assignSInfo.courseID, assignSInfo.studentEmail],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    dbRef.close();

    setState(() => isGraded = true);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    remarksController.dispose();
    super.dispose();
  }
}