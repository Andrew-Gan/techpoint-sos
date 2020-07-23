import 'package:flutter/material.dart';
import '../../CreateDB.dart';

/// stateless class for instantiating PeerReviewAssignReviewPage screen
class PeerReviewAssignReviewPage extends StatelessWidget {
  final AssignmentQuestionInfo assignQInfo;
  final AssignmentSubmissionInfo assignSInfo;
  final PeerReviewInfo peerReviews;
  final ansController = TextEditingController();

  PeerReviewAssignReviewPage(
      this.assignQInfo, this.assignSInfo, this.peerReviews);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Peer Review'),
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Text(
                    assignQInfo.content,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 15.0),
                    child: TextField(
                      controller:
                          TextEditingController(text: assignSInfo.content),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      enabled: false,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 50.0),
                  child: Text(
                    'Your review',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Text(
                    peerReviews.content, //reviewer's response
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
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
                    'Not Graded yet',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
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
