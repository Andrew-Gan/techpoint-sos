import '../../CreateDB.dart';
import 'package:flutter/material.dart';

class TeacherPeerSubmissionsPage extends StatelessWidget {
  final AssignmentQuestionInfo assignQInfo;
  final List<PeerReviewInfo> peerReviews;
  TeacherPeerSubmissionsPage(this.assignQInfo, this.peerReviews);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Peer review submissions'),
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
                  padding: EdgeInsets.only(top: 25.0, left: 25.0),
                  child: Text(
                    assignQInfo.courseID,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 25.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Text(
                      'assignID: ' + assignQInfo.assignID.toString(),
                      style: TextStyle(fontSize: 16.0,),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 25.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Text(
                      'assignTitle: ' + assignQInfo.assignTitle,
                      style: TextStyle(fontSize: 16.0,),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 50.0),
                  child: Text(
                    'Submissions',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  height: 200.0,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, i) {
                      final index = i ~/ 2;
                      if (index >= peerReviews.length) return null;
                      if (i.isOdd) return Divider();
                      return _buildRow(context, index);
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        'Reviewer ID: ' + peerReviews[i].reviewerID.toString() + '\n' +
        'Reviewed ID: ' + peerReviews[i].reviewedID.toString() + '\n' +
        'Content:\n' + peerReviews[i].content
      ),
    );
  }
}