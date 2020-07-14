import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import '../../CreateDB.dart';

class TeacherPeerCreatePage extends StatefulWidget {
  final String chosenCourseID, instrEmail;
  final List<String> assignQTitles;
  TeacherPeerCreatePage(this.chosenCourseID, this.instrEmail, this.assignQTitles);

  @override
  State<TeacherPeerCreatePage> createState() =>
    _TeacherPeerCreatePageState(chosenCourseID, instrEmail, this.assignQTitles);
}

class _TeacherPeerCreatePageState extends State<TeacherPeerCreatePage> {
  final String chosenCourseID, instrEmail;
  final List<String> assignQTitles;
  String chosenAssignTitle;
  int chosenNum;
  DateTime dueDate = DateTime.now();

  _TeacherPeerCreatePageState(this.chosenCourseID, this.instrEmail, this.assignQTitles) {
    chosenAssignTitle = assignQTitles.first;
  }

  bool isCreated = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add peer review component'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0,),
              child: Text(
                'Select assignment to add peer review component',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 5.0),
              child: DropdownButton(
                value: chosenAssignTitle,
                items: List.generate(assignQTitles.length, (i) => 
                  DropdownMenuItem(
                    child: Text(assignQTitles[i].substring(0, min(40, assignQTitles[i].length))),
                    value: assignQTitles[i],
                  )
                ),
                onChanged: (newValue) => 
                  setState(() => chosenAssignTitle = newValue),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 50.0),
              child: Text(
                'Number of peer reviews',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:25.0, top: 5.0),
              child: DropdownButton(
                value: chosenNum,
                items: List<int>.generate(10, (i) => i + 1)
                  .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                    value: i,
                    child: Text(i.toString()),
                  )).toList(),
                onChanged: (int newValue) => setState(() => chosenNum = newValue),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 50.0),
              child: Text(
                'Peer review due date',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
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
              heightFactor: 4.0,
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
    );
  }

  void onCreatePress() async {
    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;

    var res = await dbRef.query(
      'assignmentSubmissions',
      where: 'assignTitle = ? AND courseID = ?',
      whereArgs: [chosenAssignTitle, chosenCourseID],
    );

    for(int i = 0; i < res.length; i++) {
      for(int n = 1; n < chosenNum + 1; n++) {
        await dbRef.insert(
          'peerReviews',
          PeerReviewInfo(
            courseID: chosenCourseID,
            assignTitle: chosenAssignTitle,
            content: null,
            reviewerEmail: res[i]['studentEmail'],
            reviewedEmail: res[(i + n) % res.length]['studentEmail'],
            instrEmail: res[i]['instrEmail'],
            dueDate: dueDate.millisecondsSinceEpoch,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await dbRef.close();
    setState(() => isCreated = true);
  }

  @override
  void dispose() {
    super.dispose();
  }
}