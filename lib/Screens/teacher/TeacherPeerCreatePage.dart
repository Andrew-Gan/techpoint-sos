import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import '../../CreateDB.dart';

class TeacherPeerCreatePage extends StatefulWidget {
  final int instrID;
  final List<AssignmentQuestionInfo> assignQInfos;
  TeacherPeerCreatePage(this.instrID, this.assignQInfos);

  @override
  State<TeacherPeerCreatePage> createState() =>
    _TeacherPeerCreatePageState(instrID, assignQInfos);
}

class _TeacherPeerCreatePageState extends State<TeacherPeerCreatePage> {
  int chosenAssignIndex;
  final int instrID;
  final List<AssignmentQuestionInfo> assignQInfos;
  int chosenNum;
  DateTime dueDate = DateTime.now();

  _TeacherPeerCreatePageState(this.instrID, this.assignQInfos) {
    chosenAssignIndex = 0;
  }

  bool isCreated = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add peer review component'),
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
                    value: assignQInfos[chosenAssignIndex].assignTitle,
                    items: List.generate(assignQInfos.length, (i) => 
                      DropdownMenuItem(
                        child: Text(assignQInfos[i].assignTitle
                          .substring(0, min(40, assignQInfos[i].assignTitle.length))
                        ),
                        value: assignQInfos[i].assignTitle,
                      )
                    ),
                    onChanged: (newValue) => 
                      setState(() => chosenAssignIndex = newValue),
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
        ],
      ),
    );
  }

  void onCreatePress() async {
    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentSubmissionInfo.tableName,
      where: 'assignID = ?',
      whereArgs: [assignQInfos[chosenAssignIndex].assignID],
    );

    for(int i = 0; i < res.length; i++) {
      for(int n = 1; n < chosenNum + 1; n++) {
        await dbRef.insert(
          PeerReviewInfo.tableName,
          PeerReviewInfo(
            assignID: assignQInfos[chosenAssignIndex].assignID,
            submitID: res[i]['submitID'],
            content: null,
            reviewerID: res[i]['studentID'],
            reviewedID: res[(i + n) % res.length]['studentID'],
            instrID: res[i]['instrID'],
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