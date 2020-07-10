import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class TeacherAssignUpdatePage extends StatefulWidget {
  final AssignmentQuestionInfo assignQInfo;
  TeacherAssignUpdatePage(this.assignQInfo);

  @override
  State<TeacherAssignUpdatePage> createState() =>_TeacherAssignUpdatePageState(assignQInfo);
}

class _TeacherAssignUpdatePageState extends State<TeacherAssignUpdatePage> {
  final FocusNode myFocusNode = FocusNode();
  final AssignmentQuestionInfo assignQInfo;
  final contentController = TextEditingController();
  DateTime dueDate;

  _TeacherAssignUpdatePageState(this.assignQInfo) {
    dueDate = DateTime.fromMillisecondsSinceEpoch(assignQInfo.dueDate);
    contentController.text = assignQInfo.content;
  }

  bool isUpdated = false;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          assignQInfo.assignTitle,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 45.0),
                          child: Text(
                            'Change assignment question',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            controller: contentController,
                            enabled: true,
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Change assignment due date',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20.0),
                        child: DropdownButton(
                          value: dueDate.month,
                          items: List<int>.generate(12, (i) => i + 1)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: (int newValue) => setState(() =>
                            dueDate = DateTime(
                              dueDate.year,
                              newValue,
                              dueDate.day,
                              dueDate.hour,
                              dueDate.minute,
                            )
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20.0),
                        child: DropdownButton(
                          value: dueDate.day,
                          items: List<int>.generate(31, (i) => i + 1)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: (int newValue) => setState(() =>
                            dueDate = DateTime(
                              dueDate.year,
                              dueDate.month,
                              newValue,
                              dueDate.hour,
                              dueDate.minute,
                            )
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20.0),
                        child: DropdownButton(
                          value: dueDate.year,
                          items: List<int>.generate(1000, (i) => i + 2000)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: (int newValue) => setState(() =>
                            dueDate = DateTime(
                              newValue,
                              dueDate.month,
                              dueDate.day,
                              dueDate.hour,
                              dueDate.minute,
                            )
                          ),
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 5.0),
                        child: DropdownButton(
                          value: dueDate.hour,
                          items: List<int>.generate(24, (i) => i)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: (int newValue) => setState(() =>
                            dueDate = DateTime(
                              dueDate.year,
                              dueDate.month,
                              dueDate.day,
                              newValue,
                              dueDate.minute,
                            )
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 5.0),
                        child: DropdownButton(
                          value: dueDate.minute,
                          items: List<int>.generate(60, (i) => i)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: (int newValue) => setState(() =>
                            dueDate = DateTime(
                              dueDate.year,
                              dueDate.month,
                              dueDate.day,
                              dueDate.hour,
                              newValue,
                            )
                          ),
                        )
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Visibility(
                      child: Text(
                        'Assignment update successful',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                      replacement: Text(
                        '',
                        style: TextStyle(fontSize: 16.0,),
                      ),
                      visible: isUpdated,
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
    isUpdated = true;

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;
    
    await dbRef.update(
      'assignmentQuestions',
      AssignmentQuestionInfo(
        assignTitle: assignQInfo.assignTitle,
        courseID: assignQInfo.courseID,
        imageB64: assignQInfo.imageB64,
        content: contentController.text,
        dueDate: dueDate.millisecondsSinceEpoch,
        instrEmail: assignQInfo.instrEmail,
        maxScore: assignQInfo.maxScore,
      ).toMap(),
      where: 'assignTitle = ? AND courseID = ?',
      whereArgs: [assignQInfo.assignTitle, assignQInfo.courseID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dbRef.close();

    setState(() => isUpdated = true);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    contentController.dispose();
    super.dispose();
  }
}