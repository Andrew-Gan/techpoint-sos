import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import 'package:learningApp/REST_API.dart';

/// stateful class for instantiating StudentAssignSubmitPage screen
class StudentAssignSubmitPage extends StatefulWidget {
  final int studentID;
  final AssignmentQuestionInfo assignQInfo;
  StudentAssignSubmitPage(this.studentID, this.assignQInfo);

  @override
  State<StudentAssignSubmitPage> createState() =>
    _StudentAssignSubmitPageState(studentID, assignQInfo);
}

/// state class for StudentAssignSubmitPage screen
class _StudentAssignSubmitPageState extends State<StudentAssignSubmitPage> {
  final int studentID;
  final AssignmentQuestionInfo assignQInfo;
  DateTime dueDate;
  _StudentAssignSubmitPageState(this.studentID, this.assignQInfo) {
    dueDate = DateTime.fromMillisecondsSinceEpoch(assignQInfo.dueDate);
  }
  final ansController = TextEditingController();
  bool isSubmitted = false, isSuccess = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Assignment'),
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
                  padding: EdgeInsets.only(left: 25.0, top: 10.0),
                  child: Text(
                    assignQInfo.content,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 80.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 12,
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
                      'Assignment successfully submitted on\n' +
                        DateTime.now().year.toString() + '-' +
                        DateTime.now().month.toString() + '-' +
                        DateTime.now().day.toString() + ' at ' +
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
                      dueDate.year.toString() + '-' +
                      dueDate.month.toString() + '-' +
                      dueDate.day.toString() + ' at ' +
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
    );
  }

  void onSubmitPress() async {
    isSubmitted = true;

    if(assignQInfo.dueDate < DateTime.now().millisecondsSinceEpoch) {
      setState(() => isSuccess = false);
      return;
    }
    
    var map = AssignmentSubmissionInfo(
      assignID: assignQInfo.assignID,
      courseID: assignQInfo.courseID,
      studentID: studentID,
      content: ansController.text,
      submitDate: DateTime.now().millisecondsSinceEpoch,
      recScore: 0,
      remarks: '',
    ).toMap();

    if(await restInsert(AssignmentSubmissionInfo.tableName, map)) {
      ansController.clear();
      setState(() => isSuccess = true);
    }
    else setState(() => isSuccess = false);
  }

  @override
  void dispose() {
    ansController.dispose();
    super.dispose();
  }
}