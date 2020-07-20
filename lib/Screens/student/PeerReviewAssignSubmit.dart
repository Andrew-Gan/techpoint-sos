import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class PeerReviewSubmitPage extends StatefulWidget {
  final String studentEmail;
  final PeerReviewInfo reviewQInfo;
  //final List<AssignmentQuestionInfo> assignQInfos;
  PeerReviewSubmitPage(this.studentEmail, this.reviewQInfo);

  @override
  State<PeerReviewSubmitPage> createState() => _PeerReviewSubmitPageState(
        studentEmail,
        reviewQInfo,
      );
}

class _PeerReviewSubmitPageState extends State<PeerReviewSubmitPage> {
  final String studentEmail;
  final PeerReviewInfo reviewQInfo;
  //final List<AssignmentQuestionInfo> assignQInfos;
  DateTime dueDate;
  _PeerReviewSubmitPageState(this.studentEmail, this.reviewQInfo) {
    dueDate = DateTime.fromMillisecondsSinceEpoch(reviewQInfo.dueDate);
  }
  final ansController = TextEditingController();
  bool isSubmitted = false, isSuccess = false;

  @override
  void initState() => super.initState();

  //var assignQInfo = await _queryAssignInfo(reviewQInfo.assignID);

//var info = AssignmentSubmissionInfo.fromMap(res.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Peer Review Assignments'),
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
                    assignContent,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 10.0),
                  child: Text(
                    reviewQInfo.content,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 80.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: assignContent,
                            ),
                            maxLines: null,
                            obscureText: true,
                            //controller: ansController,
                            enabled: false,
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 80.0),
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
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Visibility(
                    child: Text(
                      'Assignment successfully submitted on\n' +
                          DateTime.now().year.toString() +
                          '-' +
                          DateTime.now().month.toString() +
                          '-' +
                          DateTime.now().day.toString() +
                          ' at ' +
                          DateTime.now().hour.toString() +
                          ':' +
                          DateTime.now().minute.toString(),
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
                    visible: isSubmitted && isSuccess,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Visibility(
                    child: Text(
                      'Submission failed.\nAssignment was due on ' +
                          dueDate.year.toString() +
                          '-' +
                          dueDate.month.toString() +
                          '-' +
                          dueDate.day.toString() +
                          ' at ' +
                          dueDate.hour.toString() +
                          ':' +
                          dueDate.minute.toString(),
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

    if (reviewQInfo.dueDate < DateTime.now().millisecondsSinceEpoch) {
      setState(() => isSuccess = false);
      return;
    }

    final Future<Database> db =
        openDatabase(join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;
    await dbRef.insert(
      PeerReviewInfo.tableName,
      PeerReviewInfo(
        //peerID: reviewQInfo.peerID,
        assignID: reviewQInfo.assignID,
        submitID: reviewQInfo.submitID,
        content: reviewQInfo.content,
        dueDate: reviewQInfo.dueDate,
        reviewedID: reviewQInfo.reviewedID,
        reviewerID: reviewQInfo.reviewerID,
        instrID: reviewQInfo.instrID,

        /*assignTitle: reviewQInfo.assignTitle,
        courseID: reviewQInfo.reviewerID,
        content: ansController.text,
        submitDate: DateTime.now().millisecondsSinceEpoch,
        studentEmail: studentEmail,
        recScore: 0,
        remarks: '',*/
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dbRef.close();

    ansController.clear();

    setState(() => isSuccess = true);
  }

  @override
  void dispose() {
    ansController.dispose();
    super.dispose();
  }

  //var assignQInfo = _queryAssignInfo(assignQInfos[i].assignID);
  //String Rtitle = assignQInfo.assignTitle;

  //var assignQInfo =  _queryAssignInfo(reviewQInfo.assignID);

  Future<AssignmentSubmissionInfo> _queryAssignSubmission(int assignID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentSubmissionInfo.tableName,
      where: 'submitID = ?',
      whereArgs: [reviewQInfo.submitID],
    );

    dbRef.close();
    //var info = AssignmentSubmissionInfo.fromMap(res.first);

    return AssignmentSubmissionInfo.fromMap(res.first);
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentQuestionInfo.tableName,
      where: 'assignID = ?',
      whereArgs: [assignID],
    );

    dbRef.close();

    return AssignmentQuestionInfo.fromMap(res.first);
  }

  String assignContent;
  String assignTitle;

  Future<AssignmentSubmissionInfo> getContent() async {
    var info = await _queryAssignSubmission(reviewQInfo.assignID);
    assignContent = info.content;
    return info;
  }

  Future<AssignmentQuestionInfo> getTitle() async {
    var title = await _queryAssignInfo(reviewQInfo.assignID);
    assignContent = title.content;
    return title;
  }
}
