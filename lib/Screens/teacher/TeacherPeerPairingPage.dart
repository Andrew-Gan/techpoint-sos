import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

class TeacherPeerPairingPage extends StatefulWidget {
  final int instrID;
  final int dueDate;
  final List<AssignmentSubmissionInfo> assignSInfos;
  TeacherPeerPairingPage(this.instrID, this.assignSInfos, this.dueDate);

  @override
  State<TeacherPeerPairingPage> createState() =>
    _TeacherPeerPairingPageState(instrID, assignSInfos, dueDate);
}

class _TeacherPeerPairingPageState extends State<TeacherPeerPairingPage> {
  final int instrID, dueDate;
  final List<AssignmentSubmissionInfo> assignSInfos;
  bool isInvalid = false, isSuccess = false;
  int studentAIndex, studentBIndex;

  var pairs = List<List<AssignmentSubmissionInfo>>();

  _TeacherPeerPairingPageState(this.instrID, this.assignSInfos, this.dueDate);

  bool isCreated = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Peer review manual pairing'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              'Current pairings',
              style: TextStyle(
                fontSize: 18.0, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 350,
            child: ListView.builder(
              itemBuilder: (context, i) {
                final index = i ~/ 2;
                if(index >= pairs.length || pairs.length == 0) return null;
                if(i.isOdd) return Divider();
                return _buildRow(context, pairs[index]);
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: DropdownButton(
                  value: studentAIndex,
                  items: List.generate(assignSInfos.length, (i) => 
                    DropdownMenuItem(
                      child: Text(assignSInfos[i].studentID.toString()),
                      value: i,
                    ),
                  ),
                  onChanged: (newValue) => setState(() => studentAIndex = newValue)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: DropdownButton(
                  value: studentBIndex,
                  items: List.generate(assignSInfos.length, (i) => 
                    DropdownMenuItem(
                      child: Text(assignSInfos[i].studentID.toString()),
                      value: i,
                    ),
                  ),
                  onChanged: (newValue) => setState(() => studentBIndex = newValue)
                ),
              ),
              Center(
                child: IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: onCreatePair,
                ),
              ),
            ],
          ),
          Center(
            child: Visibility(
              child: Text(
                'Error cannot pair same student',
                style: TextStyle(color: Colors.red),
              ),
              replacement: Text(''),
              visible: isInvalid,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10.0),
            child: OutlineButton(
              onPressed: onConfirm,
              child: Text('CONFIRM'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          Center(
            child: Visibility(
              child: Text(
                'Peer review pairing successful',
                style: TextStyle(color: Colors.red),
              ),
              replacement: Text(''),
              visible: isSuccess,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<AssignmentSubmissionInfo> pair) {
    return ListTile(
      title: Text(
        pair[0].studentID.toString() + ' paired with ' + pair[1].studentID.toString(),
      ),
    );
  }

  void onCreatePair() {
    if (studentAIndex == null || 
        studentBIndex == null || 
        studentAIndex == studentBIndex) {
      setState(() => isInvalid = true);
      return;
    }

    setState(() {
      pairs.add([assignSInfos[studentAIndex], assignSInfos[studentBIndex]]);
      assignSInfos.removeAt(studentAIndex);
      if (studentAIndex < studentBIndex) assignSInfos.removeAt(studentBIndex - 1);
      else assignSInfos.removeAt(studentBIndex);
      isInvalid = false;
      studentAIndex = null;
      studentBIndex = null;
    });
  }

  void onConfirm() async {
    bool success = false;
    for(int i = 0; i < pairs.length; i++) {
      var map1 = PeerReviewInfo(
        submitID: pairs[i][0].submitID,
        content: null,
        assignID: pairs[i][0].assignID,
        reviewerID: pairs[i][1].studentID,
        reviewedID: pairs[i][0].studentID,
        instrID: instrID,
        dueDate: dueDate,
      ).toMap();
      await restInsert(PeerReviewInfo.tableName, map1);

      var map2 = PeerReviewInfo(
        submitID: pairs[i][1].submitID,
        content: null,
        assignID: pairs[i][1].assignID,
        reviewerID: pairs[i][0].studentID,
        reviewedID: pairs[i][1].studentID,
        instrID: instrID,
        dueDate: dueDate,
      ).toMap();
      success = await restInsert(PeerReviewInfo.tableName, map2);
    }
    setState(() => isSuccess = success);
  }

  @override
  void dispose() => super.dispose();
}