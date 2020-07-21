import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

class TeacherViewSubmitPage extends StatefulWidget {
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;
  TeacherViewSubmitPage(this.assignQInfo, this.assignSInfo);

  @override
  State<TeacherViewSubmitPage> createState() =>
    _TeacherViewSubmitPageState(assignQInfo, assignSInfo);
}

class _TeacherViewSubmitPageState extends State<TeacherViewSubmitPage> {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Student Submission'),
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
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: Text(
                    assignQInfo.assignTitle,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Text(
                    assignSInfo.studentID.toString(),
                    style: TextStyle(fontSize: 16.0,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 10.0),
                  child: Text(
                    submitDate.year.toString() + '-' +
                    submitDate.month.toString() + '-' +
                    submitDate.day.toString() + ' ' +
                    submitDate.hour.toString() + ':' +
                    submitDate.minute.toString(),
                    style: TextStyle(fontSize: 16.0,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                  child: Text(
                    'Submission content',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0, top: 10.0,),
                  height: 150,
                  child: ListView(
                    children: [
                      Text(
                        assignSInfo.content,
                      ),
                    ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
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
                    child: Text('GRADE'),
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

  void onUpdatePress() async {
    int accountID = assignSInfo.studentID;
    var map = await restQuery(AccountInfo.tableName, '*', 'accountID=$accountID');

    AccountInfo studentInfo = AccountInfo.fromMap(map.first);
    studentInfo.receivedScore += (newScore - assignSInfo.recScore);

    await restUpdate(AccountInfo.tableName, 'accountID=$accountID',
      studentInfo.toMap());

    assignSInfo.recScore = newScore;
    assignSInfo.remarks = remarksController.text;
    
    int submitID = assignSInfo.submitID;
    bool graded = await restUpdate(AssignmentSubmissionInfo.tableName,
      'submitID=$submitID', assignSInfo.toMap());

    setState(() => isGraded = graded);
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }
}