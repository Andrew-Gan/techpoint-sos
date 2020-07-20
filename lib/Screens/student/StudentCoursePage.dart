import '../../CreateDB.dart';
import 'StudentAssignSubmitPage.dart';
import 'StudentAssignReviewPage.dart';
import 'package:flutter/material.dart';
import './PeerReviewPage.dart';
import '../../REST_API.dart';

class StudentCoursePage extends StatelessWidget {
  final String courseID;
  final AccountInfo studentInfo;
  final List<AssignmentQuestionInfo> assignQInfos;
  final int score;
  StudentCoursePage(this.studentInfo, this.courseID, this.assignQInfos, this.score);

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
                        height: 80.0,
                        child: Text(
                          score.toString() + ' / 1000',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
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
            List<String> peerReviewTitles = await _queryPeerReviewInfo();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PeerReviewPage(studentInfo.email, courseID, peerReviewTitles);
            }));
            // Add your onPressed code here!
          },
          label: Text('Peer Review'),
          //icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.grey),
    );
  }

  Widget _buildAssignRow(BuildContext context, int i) {
    return ListTile(
      title: Text(assignQInfos[i].assignTitle,),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var assignQInfo = await _queryAssignInfo(assignQInfos[i].assignID);
        var assignSInfo = await _queryAssignSubmits(assignQInfos[i].assignID);
        if (assignQInfo.dueDate > now || assignSInfo == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    StudentAssignSubmitPage(studentInfo.accountID, assignQInfo)),
          );
        } else {
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
    var map = await restQuery(AssignmentQuestionInfo.tableName, '*',
      'assignID=$assignID');

    return AssignmentQuestionInfo.fromMap(map.first);
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(int assignID) async {
    int accountID = studentInfo.accountID;
    
    var map = await restQuery(AssignmentSubmissionInfo.tableName, '*',
      'studentID=$accountID&assignID=$assignID');

    if (map.length < 1) return null;
    return AssignmentSubmissionInfo.fromMap(map.first);
  }

  Future<List<String>> _queryPeerReviewInfo() async {
    int reviewerID = studentInfo.accountID;
    var map = await restQuery(PeerReviewInfo.tableName, 'assignTitle',
      'reviewerID=$reviewerID');
    
    List<String> ret = List.generate(
      map.length, 
      (index) => map[index]['assignTitle']
    );
    
    return ret.toSet().toList();
  }
}
