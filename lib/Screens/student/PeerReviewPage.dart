import 'dart:async';

import '../../CreateDB.dart';
import 'package:flutter/material.dart';
import './PeerReviewAssignSubmit.dart';
import '../../REST_API.dart';
import './PeerReviewAssignReview.dart';

class PeerReviewPage extends StatefulWidget {
  final AccountInfo userInfo;
  final String courseID;
  final List<PeerReviewInfo> peerReviews;
  PeerReviewPage(
    this.userInfo,
    this.courseID,
    this.peerReviews,
  );

  @override
  State<PeerReviewPage> createState() =>
      _PeerReviewPageState(userInfo, courseID, peerReviews);
}

class _PeerReviewPageState extends State<PeerReviewPage> {
  final String courseID;
  final AccountInfo userInfo;
  final List<PeerReviewInfo> peerReviews;
  _PeerReviewPageState(this.userInfo, this.courseID, this.peerReviews);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Peer Review'),
        ),
        body: Container(
          color: Colors.blueGrey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 80,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 50.0),
                              child: Text(
                                'Assignments available for Review',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20.0, top: 20.0),
                              height: 200.0,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  itemBuilder: (context, i) {
                                    final index = i ~/ 2;
                                    if (index >= peerReviews.length)
                                      return null;
                                    if (i.isOdd) return Divider();
                                    return _buildPeerReviewRow(context, index);
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildPeerReviewRow(BuildContext context, int i) {
    String reviewTitle = 'English';

    return ListTile(
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var peerReviewInfo = await _queryPeerReviewInfo();
        var assignSubmitInfo =
            await _queryAssignSubmits(peerReviewInfo[i].assignID, i);
        var assignQuestionInfo =
            await _queryAssignInfo(peerReviewInfo[i].assignID);

        if (peerReviewInfo[i].dueDate > now &&
            peerReviewInfo[i].content == null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            reviewTitle = assignQuestionInfo.assignTitle;
            String reviewQuestion = assignQuestionInfo.content;
            return PeerReviewSubmitPage(userInfo, peerReviewInfo[i],
                assignSubmitInfo.content, reviewTitle, reviewQuestion);
          }));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PeerReviewAssignReviewPage(
                assignQuestionInfo, assignSubmitInfo, peerReviewInfo[i]);
          }));
        }
      },
      title: Text(reviewTitle),
    );
  }

  Future<List<PeerReviewInfo>> _queryPeerReviewInfo() async {
    int accountID = userInfo.accountID;
    var res = await restQuery(PeerReviewInfo.tableName, '*',
        '(reviewerID=$accountID)and(courseID=$courseID)');
    return List.generate(
        res.length, (index) => PeerReviewInfo.fromMap(res[index]));
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(
      int assignID, int i) async {
    int accountID = peerReviews[i].reviewedID;

    var map = await restQuery(AssignmentSubmissionInfo.tableName, '*',
        '(studentID=$accountID)and(assignID=$assignID)');

    if (map.length < 1) return null;
    return AssignmentSubmissionInfo.fromMap(map.first);
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    var map = await restQuery(
        AssignmentQuestionInfo.tableName, '*', 'assignID=$assignID');

    return AssignmentQuestionInfo.fromMap(map.first);
  }

  @override
  void dispose() => super.dispose();
}
