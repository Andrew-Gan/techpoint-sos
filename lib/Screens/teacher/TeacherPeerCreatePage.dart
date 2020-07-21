import 'package:flutter/material.dart';
import 'dart:math';
import 'TeacherPeerPairingPage.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

class TeacherPeerCreatePage extends StatefulWidget {
  final int instrID;
  final List<AssignmentQuestionInfo> assignQInfos;
  TeacherPeerCreatePage(this.instrID, this.assignQInfos);

  @override
  State<TeacherPeerCreatePage> createState() =>
      _TeacherPeerCreatePageState(instrID, assignQInfos);
}

class _TeacherPeerCreatePageState extends State<TeacherPeerCreatePage> {
  int chosenAssignIndex = 0;
  bool isAutoPairing = true;
  final int instrID;
  final List<AssignmentQuestionInfo> assignQInfos;
  int chosenNum = 1;
  DateTime dueDate = DateTime.now();

  _TeacherPeerCreatePageState(this.instrID, this.assignQInfos);

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
                  padding: EdgeInsets.only(
                    left: 25.0,
                    top: 25.0,
                    right: 25.0,
                  ),
                  child: Text(
                    'Select assignment to add peer review component',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 5.0),
                  child: DropdownButton(
                    value: chosenAssignIndex,
                    items: List.generate(
                        assignQInfos.length,
                        (i) => DropdownMenuItem(
                              child: Text(assignQInfos[i].assignTitle.substring(
                                  0,
                                  min(40, assignQInfos[i].assignTitle.length))),
                              value: i,
                            )),
                    onChanged: (newValue) =>
                        setState(() => chosenAssignIndex = newValue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Text(
                    'Pairing mode',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 5.0),
                      child: FlatButton(
                        child: Text('Auto pairing'),
                        onPressed: () => setState(() => isAutoPairing = true),
                        color: isAutoPairing ? Colors.blue : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 5.0),
                      child: FlatButton(
                        child: Text('Manual pairing'),
                        onPressed: () => setState(() => isAutoPairing = false),
                        color: !isAutoPairing ? Colors.blue : null,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Text(
                    'Number of peer reviews',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 5.0),
                  child: DropdownButton(
                    value: chosenNum,
                    items: List<int>.generate(10, (i) => i + 1)
                        .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            ))
                        .toList(),
                    onChanged: (int newValue) =>
                        setState(() => chosenNum = newValue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 50.0),
                  child: Text(
                    'Peer review due date',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                        ),
                        child: DropdownButton(
                          value: dueDate.month,
                          items: List<int>.generate(12, (i) => i + 1)
                              .map<DropdownMenuItem<int>>(
                                  (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(i.toString()),
                                      ))
                              .toList(),
                          onChanged: (int newValue) =>
                              setState(() => dueDate = DateTime(
                                    dueDate.year,
                                    newValue,
                                    dueDate.day,
                                    dueDate.hour,
                                    dueDate.minute,
                                  )),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                        ),
                        child: DropdownButton(
                          value: dueDate.day,
                          items: List<int>.generate(31, (i) => i + 1)
                              .map<DropdownMenuItem<int>>(
                                  (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(i.toString()),
                                      ))
                              .toList(),
                          onChanged: (int newValue) =>
                              setState(() => dueDate = DateTime(
                                    dueDate.year,
                                    dueDate.month,
                                    newValue,
                                    dueDate.hour,
                                    dueDate.minute,
                                  )),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                        ),
                        child: DropdownButton(
                          value: dueDate.year,
                          items: List<int>.generate(1000, (i) => i + 2000)
                              .map<DropdownMenuItem<int>>(
                                  (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(i.toString()),
                                      ))
                              .toList(),
                          onChanged: (int newValue) =>
                              setState(() => dueDate = DateTime(
                                    newValue,
                                    dueDate.month,
                                    dueDate.day,
                                    dueDate.hour,
                                    dueDate.minute,
                                  )),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                        ),
                        child: DropdownButton(
                          value: dueDate.hour,
                          items: List<int>.generate(24, (i) => i)
                              .map<DropdownMenuItem<int>>(
                                  (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(i.toString()),
                                      ))
                              .toList(),
                          onChanged: (int newValue) =>
                              setState(() => dueDate = DateTime(
                                    dueDate.year,
                                    dueDate.month,
                                    dueDate.day,
                                    newValue,
                                    dueDate.minute,
                                  )),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                        ),
                        child: DropdownButton(
                          value: dueDate.minute,
                          items: List<int>.generate(60, (i) => i)
                              .map<DropdownMenuItem<int>>(
                                  (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(i.toString()),
                                      ))
                              .toList(),
                          onChanged: (int newValue) =>
                              setState(() => dueDate = DateTime(
                                    dueDate.year,
                                    dueDate.month,
                                    dueDate.day,
                                    dueDate.hour,
                                    newValue,
                                  )),
                        )),
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
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    visible: isCreated,
                  ),
                ),
                Center(
                  heightFactor: 3.0,
                  child: OutlineButton(
                    onPressed: () => onCreatePress(context),
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

  void onCreatePress(BuildContext context) async {
    int assignID = assignQInfos[chosenAssignIndex].assignID;
    var map = await restQuery(
        AssignmentSubmissionInfo.tableName, '*', 'assignID=$assignID');

    // determine if auto pairing is enabled
    // adding reviewTitle toarguments of the PeerReviewInfo object
    if (isAutoPairing) {
      for (int i = 0; i < map.length; i++) {
        for (int n = 1; n < chosenNum + 1; n++) {
          var obj = PeerReviewInfo(
            assignID: assignQInfos[chosenAssignIndex].assignID,
            submitID: map[i]['submitID'],
            content: null,
            reviewerID: map[i]['studentID'],
            reviewedID: map[(i + n) % map.length]['studentID'],
            instrID: instrID,
            dueDate: dueDate.millisecondsSinceEpoch,
            reviewTitle: assignQInfos[chosenAssignIndex].assignTitle,
          ).toMap();
          if (await restInsert(PeerReviewInfo.tableName, obj)) {
            setState(() => isCreated = true);
          }
        }
      }
    } else {
      var assignSInfos = List.generate(
          map.length, (i) => AssignmentSubmissionInfo.fromMap(map[i]));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherPeerPairingPage(
                  instrID, assignSInfos, dueDate.millisecondsSinceEpoch)));
    }
  }

  @override
  void dispose() => super.dispose();
}
