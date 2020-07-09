import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../CreateDB.dart';

class AssignPage extends StatefulWidget {
  final String studentEmail;
  final AssignmentQuestionInfo assignQInfo;
  AssignPage(this.studentEmail, this.assignQInfo);

  @override
  State<AssignPage> createState() =>_AssignPageState(studentEmail, assignQInfo);
}

class _AssignPageState extends State<AssignPage> {
  final FocusNode myFocusNode = FocusNode();
  final String studentEmail;
  final AssignmentQuestionInfo assignQInfo;
  DateTime dueDate;
  _AssignPageState(this.studentEmail, this.assignQInfo) {
    dueDate = DateTime.fromMillisecondsSinceEpoch(assignQInfo.dueDate);
  }
  final ansController = TextEditingController();
  bool isSubmitted = false, isSuccess = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Assignment'),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Submission box',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 18,
                            controller: ansController,
                            enabled: true,
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Visibility(
                      child: Text(
                        'Assignment successfully submitted on ' +
                          DateTime.now().month.toString() + '-' +
                          DateTime.now().day.toString() + '-' +
                          DateTime.now().year.toString() + ' at ' +
                          DateTime.now().hour.toString() + ':' +
                          DateTime.now().minute.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                      replacement: Text(
                        '',
                        style: TextStyle(fontSize: 16.0,),
                      ),
                      visible: isSubmitted && isSuccess,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Visibility(
                      child: Text(
                        'Submission failed.\nAssignment was due on ' +
                        dueDate.month.toString() + '-' +
                        dueDate.day.toString() + '-' +
                        dueDate.year.toString() + ' at ' +
                        dueDate.hour.toString() + ':' +
                        dueDate.minute.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                      replacement: Text(
                        '',
                        style: TextStyle(fontSize: 16.0,),
                      ),
                      visible: isSubmitted && !isSuccess,
                    ),
                  ),
                  Center(
                    heightFactor: 2.0,
                    child: OutlineButton(
                      onPressed: onSubmitPress,
                      child: Text('SUBMIT'),
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

  void onSubmitPress() async {
    isSubmitted = true;

    if(assignQInfo.dueDate < DateTime.now().millisecondsSinceEpoch) {
      setState(() => isSuccess = false);
      return;
    }

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;
    dbRef.insert(
      'assignmentSubmissions',
      AssignmentSubmissionInfo(
        assignTitle: assignQInfo.assignTitle,
        courseID: assignQInfo.courseID,
        content: ansController.text,
        submitDate: DateTime.now().millisecondsSinceEpoch,
        studentEmail: studentEmail,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    ansController.clear();

    setState(() => isSuccess = true);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    ansController.dispose();
    super.dispose();
  }
}