import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class AssignUpdatePage extends StatefulWidget {
  final AssignmentQuestionInfo assignQInfo;
  AssignUpdatePage(this.assignQInfo);

  @override
  State<AssignUpdatePage> createState() =>_AssignUpdatePageState(assignQInfo);
}

class _AssignUpdatePageState extends State<AssignUpdatePage> {
  final FocusNode myFocusNode = FocusNode();
  final AssignmentQuestionInfo assignQInfo;
  _AssignUpdatePageState(this.assignQInfo);

  final contentController = TextEditingController();
  final dueDateController = TextEditingController();
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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              assignQInfo.assignTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                assignQInfo.content,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
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
                            maxLines: 15,
                            controller: contentController,
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
                        'Assignment successfully updated',
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
                        'Submission update failed',
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
    isSubmitted = true;

    if(assignQInfo.dueDate < DateTime.now().millisecondsSinceEpoch) {
      setState(() => isSuccess = false);
      return;
    }

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;
    dbRef.update(
      'assignmentQuestions',
      AssignmentQuestionInfo(
        assignTitle: assignQInfo.assignTitle,
        courseID: assignQInfo.courseID,
        imageB64: assignQInfo.imageB64,
        content: contentController.text,
        dueDate: assignQInfo.dueDate,
        instrEmail: assignQInfo.instrEmail,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    contentController.clear();
    dueDateController.clear();

    setState(() => isSuccess = true);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    contentController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}