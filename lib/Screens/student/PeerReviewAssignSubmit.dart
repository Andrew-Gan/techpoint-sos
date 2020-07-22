import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

class PeerReviewSubmitPage extends StatefulWidget {
  final AccountInfo studentAccountInfo;
  final PeerReviewInfo reviewQInfo;
  String studentSubmission, reviewTitle, reviewQuestion;
  //final List<AssignmentQuestionInfo> assignQInfos;
  PeerReviewSubmitPage(this.studentAccountInfo, this.reviewQInfo,
      this.studentSubmission, this.reviewTitle, this.reviewQuestion);

  @override
  State<PeerReviewSubmitPage> createState() => _PeerReviewSubmitPageState(
        studentAccountInfo,
        reviewQInfo,
        studentSubmission,
        reviewTitle,
        reviewQuestion,
      );
}

class _PeerReviewSubmitPageState extends State<PeerReviewSubmitPage> {
  final AccountInfo studentAccountInfo;
  final PeerReviewInfo reviewQInfo;
  String studentSubmission, reviewTitle, reviewQuestion;
  //final List<AssignmentQuestionInfo> assignQInfos;
  DateTime dueDate;
  _PeerReviewSubmitPageState(this.studentAccountInfo, this.reviewQInfo,
      this.studentSubmission, this.reviewTitle, this.reviewQuestion) {
    dueDate = DateTime.fromMillisecondsSinceEpoch(reviewQInfo.dueDate);
  }
  final ansController = TextEditingController();
  bool isSubmitted = false, isSuccess = false;
  TextEditingController controller;

  @override
  void initState() => super.initState();

  //var assignQInfo = await _queryAssignInfo(reviewQInfo.assignID);

//var info = AssignmentSubmissionInfo.fromMap(res.first);

  @override
  Widget build(BuildContext context) {
    print(reviewQInfo.reviewTitle);
    print(reviewQInfo.reviewerID);
    print(reviewQInfo.reviewedID);
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
            height: MediaQuery.of(context).size.height, //- 80,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: Text(
                    reviewTitle, //reviewQInfo.reviewTitle,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 10.0),
                  child: Text(
                    reviewQuestion, //reviewQInfo.content,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 10,
                    ),
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //Flexible(
                        /*child:*/ TextField(
                          controller:
                              TextEditingController(text: studentSubmission),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            /*labelText:
                                'insert student submission here I am trying to see how far this wifget will go... ',*/
                          ),
                          maxLines: null,

                          //maxLines: 1,
                          //obscureText: true,
                          //controller: ansController,
                          enabled: false,
                        )
                        //),
                        //),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: Text(
                    'Your Review:', //reviewQInfo.reviewTitle,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
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

    /*final Future<Database> db =
        openDatabase(join(await getDatabasesPath(), 'learningApp_database.db'));*/

    // final Database dbRef = await db;
    /*await dbRef.insert(
      PeerReviewInfo.tableName,*/
    var map = PeerReviewInfo(
      //peerID: reviewQInfo.peerID,
      assignID: reviewQInfo.assignID,
      submitID: reviewQInfo.submitID,
      content: ansController.text, //reviewQInfo.content,
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
    ).toMap();
    var peerID = reviewQInfo.peerID;
    //Changing AssignmentSubmissionInfo to PeerReviewInfo
    if (await restUpdate(PeerReviewInfo.tableName, 'peerID=$peerID', map)) {
      ansController.clear();
      setState(() => isSuccess = true);
    } else
      setState(() => isSuccess = false);
    /*}
    else setState(() => isSuccess = false);
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dbRef.close();

    ansController.clear();*/
  }

  @override
  void dispose() {
    ansController.dispose();
    super.dispose();
  }

  //var assignQInfo = _queryAssignInfo(assignQInfos[i].assignID);
  //String Rtitle = assignQInfo.assignTitle;

  //var assignQInfo =  _queryAssignInfo(reviewQInfo.assignID);

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(int assignID) async {
    int accountID = studentAccountInfo.accountID;

    var map = await restQuery(AssignmentSubmissionInfo.tableName, '*',
        'studentID=$accountID&assignID=$assignID');

    if (map.length < 1) return null;
    return AssignmentSubmissionInfo.fromMap(map.first);
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    var map = await restQuery(
        AssignmentQuestionInfo.tableName, '*', 'assignID=$assignID');

    return AssignmentQuestionInfo.fromMap(map.first);
    /*Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      AssignmentQuestionInfo.tableName,
      where: 'assignID = ?',
      whereArgs: [assignID],
    );

    dbRef.close();

    return AssignmentQuestionInfo.fromMap(res.first);*/
  }

  String assignContent;
  String assignTitle;

  Future<AssignmentSubmissionInfo> getContent() async {
    var info = await _queryAssignSubmits(reviewQInfo.assignID);
    assignContent = info.content;
    return info;
  }

  Future<AssignmentQuestionInfo> getTitle() async {
    var title = await _queryAssignInfo(reviewQInfo.assignID);
    assignContent = title.content;
    return title;
  }
}
