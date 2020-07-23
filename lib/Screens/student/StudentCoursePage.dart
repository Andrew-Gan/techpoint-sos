import '../../CreateDB.dart';
import 'StudentAssignSubmitPage.dart';
import 'StudentAssignReviewPage.dart';
import 'package:flutter/material.dart';
import './PeerReviewPage.dart';
import '../../REST_API.dart';

/// stateless class for instantiating StudentCoursePage screen
class StudentCoursePage extends StatelessWidget {
  final String courseID;
  final AccountInfo studentInfo;
  final List<AssignmentQuestionInfo> assignQInfos;
  final int recScore, maxScore;
  StudentCoursePage(
      this.studentInfo, this.courseID, this.assignQInfos, this.recScore, this.maxScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course'),
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
                  padding: EdgeInsets.only(top: 20.0, left: 50.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Text(
                          courseID,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.0, left: 80.0),
                        width: 250.0,
                        height: 120.0,
                        child: Text(
                          _scoreToGrade(recScore, maxScore) + '\n' +
                            recScore.toString() + ' / ' + maxScore.toString(),
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0,),
                  child: LinearProgressIndicator(
                    value: recScore / maxScore,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 45.0),
                  child: Text(
                    'Assignments',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                  ),
                  height: 300.0,
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, i) {
                        final index = i ~/ 2;
                        if (index >= assignQInfos.length) return null;
                        if (i.isOdd) return Divider();
                        return _buildAssignRow(context, index);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            List<PeerReviewInfo> peerReviewTitles =
                await _queryPeerReviewInfo();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PeerReviewPage(studentInfo, courseID, peerReviewTitles);
            }));
          },
          label: Text('Peer Review'),
          backgroundColor: Colors.grey),
    );
  }

  Widget _buildAssignRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignQInfos[i].assignTitle,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var assignQInfo = await _queryAssignInfo(assignQInfos[i].assignID);
        var assignSInfo = await _queryAssignSubmits(assignQInfos[i].assignID);
        if (assignQInfo.dueDate > now || assignSInfo == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StudentAssignSubmitPage(
                studentInfo.accountID, assignQInfo)),
          );
        }
        else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                StudentAssignReviewPage(assignQInfo, assignSInfo)),
          );
        }
      },
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    var map = await restQuery(
        AssignmentQuestionInfo.tableName, '*', 'assignID=$assignID');

    return AssignmentQuestionInfo.fromMap(map.first);
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(int assignID) async {
    int accountID = studentInfo.accountID;

    var map = await restQuery(AssignmentSubmissionInfo.tableName, '*',
        '(studentID=$accountID)and(assignID=$assignID)');

    if (map.length < 1) return null;
    return AssignmentSubmissionInfo.fromMap(map.first);
  }

  Future<List<PeerReviewInfo>> _queryPeerReviewInfo() async {
    int accountID = studentInfo.accountID;
    var res = await restQuery(PeerReviewInfo.tableName, '*',
        '(reviewerID=$accountID)and(courseID=$courseID)');
  
    return List.generate(
        res.length, (index) => PeerReviewInfo.fromMap(res[index]));
  }

  String _scoreToGrade(int recScore, int maxScore) {
    int percentage = recScore * 100 ~/ maxScore;
    if(percentage > 90) return 'A';
    if(percentage > 80) return 'B';
    if(percentage > 70) return 'C';
    if(percentage > 60) return 'D';
    if(percentage > 50) return 'E';
    else return 'F';
  }
}