import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class TeacherAssignCreatePage extends StatefulWidget {
  final String courseID, instrEmail;
  TeacherAssignCreatePage(this.courseID, this.instrEmail);

  @override
  State<TeacherAssignCreatePage> createState() =>
    _TeacherAssignCreatePageState(courseID, instrEmail);
}

class _TeacherAssignCreatePageState extends State<TeacherAssignCreatePage> {
  final String courseID, instrEmail;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime dueDate = DateTime.now(), reviewDueDate = DateTime.now();
  bool isPeerReview = false;
  int peerReviewCount = 0;

  _TeacherAssignCreatePageState(this.courseID, this.instrEmail);

  bool isCreated = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add assignment'),
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
                      left: 25.0, top: 25.0, right: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Assignment title',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          enabled: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Text(
                            'Assignment question',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          controller: contentController,
                          enabled: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0, top: 25.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Assignment due date',
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
                        padding: EdgeInsets.only(left: 25.0,),
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
                        padding: EdgeInsets.only(left: 25.0,),
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
                        padding: EdgeInsets.only(left: 25.0,),
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
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
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
                        padding: EdgeInsets.only(left: 25.0,),
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
                    padding: EdgeInsets.only(left: 25.0, top: 25.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Text(
                            'Peer review options',
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
                        child: DropdownButton(
                          value: isPeerReview,
                          items: [
                            DropdownMenuItem(child: Text('enable'), value: true),
                            DropdownMenuItem(child: Text('disable'), value: false),
                          ],
                          onChanged: (bool option) => 
                            setState(() => isPeerReview = option),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
                        child: DropdownButton(
                          value: peerReviewCount,
                          items: List.generate(10, (index) => 
                            DropdownMenuItem(
                              child: Text(index.toString()),
                              value: index,
                            )
                          ),
                          onChanged: isPeerReview ? (int option) => 
                            setState(() => peerReviewCount = option) : null,
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
                        child: DropdownButton(
                          value: reviewDueDate.month,
                          items: List<int>.generate(12, (i) => i + 1)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: !isPeerReview ? null : (int newValue) =>
                            setState(() => reviewDueDate = DateTime(
                              reviewDueDate.year,
                              newValue,
                              reviewDueDate.day,
                              reviewDueDate.hour,
                              reviewDueDate.minute,
                            )),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
                        child: DropdownButton(
                          value: reviewDueDate.day,
                          items: List<int>.generate(31, (i) => i + 1)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: !isPeerReview ? null : (int newValue) =>
                            setState(() => reviewDueDate = DateTime(
                              reviewDueDate.year,
                              reviewDueDate.month,
                              newValue,
                              reviewDueDate.hour,
                              reviewDueDate.minute,
                            )),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0,),
                        child: DropdownButton(
                          value: reviewDueDate.year,
                          items: List<int>.generate(1000, (i) => i + 2000)
                            .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )).toList(),
                          onChanged: !isPeerReview ? null : (int newValue) =>
                            setState(() => reviewDueDate = DateTime(
                              newValue,
                              reviewDueDate.month,
                              reviewDueDate.day,
                              reviewDueDate.hour,
                              reviewDueDate.minute,
                            )),
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
                      visible: isCreated,
                    ),
                  ),
                  Center(
                    heightFactor: 2.0,
                    child: OutlineButton(
                      onPressed: onCreatePress,
                      child: Text('CREATE'),
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

  void onCreatePress() async {
    isCreated = true;

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;

    await dbRef.insert(
      'assignmentQuestions',
      AssignmentQuestionInfo(
        assignTitle: titleController.text,
        courseID: courseID,
        content: contentController.text,
        dueDate: dueDate.millisecondsSinceEpoch,
        instrEmail: instrEmail,
        maxScore: 100,
        isPeerReview: isPeerReview ? 1 : 0,
        peerReviewCount: peerReviewCount,
        reviewDueDate: reviewDueDate.millisecondsSinceEpoch,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    dbRef.close();

    setState(() => isCreated = true);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}