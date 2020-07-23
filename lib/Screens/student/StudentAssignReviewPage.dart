import 'package:flutter/material.dart';
import '../../CreateDB.dart';

/// stateless class for instantiating StudentAssignReviewPage screen
class StudentAssignReviewPage extends StatelessWidget {
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;
  final ansController = TextEditingController();

  StudentAssignReviewPage(this.assignQInfo, this.assignSInfo);

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
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
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
                    assignQInfo.content,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16.0,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0, top: 80.0),
                  child: Text(
                    'Your submission',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Text(
                    assignSInfo.content,
                    maxLines: 5,
                    style: TextStyle(fontSize: 16.0,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 140.0),
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
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Text(assignSInfo.recScore.toString() + ' / ' +
                    assignQInfo.maxScore.toString()),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 50.0),
                  child: Text(
                    'Teacher\'s review',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
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
    );
  }
}