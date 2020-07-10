import 'package:flutter/material.dart';
import '../../CreateDB.dart';

class StudentAssignReviewPage extends StatelessWidget {
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;

  final FocusNode myFocusNode = FocusNode();
  DateTime submitDate;

  StudentAssignReviewPage(this.assignQInfo, this.assignSInfo) {
    submitDate = DateTime.fromMillisecondsSinceEpoch(assignSInfo.submitDate);
  }
  final ansController = TextEditingController();
  bool isSubmitted = false, isSuccess = false;

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
                      left: 20.0, top: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              assignQInfo.assignTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                assignQInfo.content,
                                maxLines: 3,
                                style: TextStyle(fontSize: 16.0,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0, top: 80.0),
                    child: Text(
                      'Your submission',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0, top: 20.0),
                    child: Text(
                      assignSInfo.content,
                      maxLines: 5,
                      style: TextStyle(fontSize: 16.0,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 120.0),
                    child: Text(
                      'Given score',
                      maxLines: 15,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 25.0),
                    child: Text(assignSInfo.recScore.toString() + ' / ' +
                      assignQInfo.maxScore.toString()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 50.0),
                    child: Text(
                      'Teacher\'s review',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 25.0),
                    child: Text(
                      assignSInfo.remarks,
                      style: TextStyle(fontSize: 16.0,),
                      maxLines: 3,
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
}