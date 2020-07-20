import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../CreateDB.dart';
import 'StudentAssignSubmitPage.dart';
import 'StudentAssignReviewPage.dart';
import 'package:flutter/material.dart';
import './PeerReviewAssignSubmit.dart';

class PeerReviewPage extends StatefulWidget {
  final String email;
  final String courseID;
  final List<String> peerReviews;
  PeerReviewPage(this.email, this.courseID, this.peerReviews);

  @override
  State<PeerReviewPage> createState() =>
      _PeerReviewPageState(email, courseID, peerReviews);
}

class _PeerReviewPageState extends State<PeerReviewPage> {
  final String courseID;
  final String email;
  final List<String> peerReviews;
  _PeerReviewPageState(this.email, this.courseID, this.peerReviews);

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
    return ListTile(
      title: Text(
        peerReviews[i],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        int now = DateTime.now().millisecondsSinceEpoch;
        var peerReviewInfo = await _queryPeerReviewInfo(peerReviews[i]);
        if (peerReviewInfo.first.dueDate > now) {
          // call Abdullah's peer review submissions page
          () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PeerReviewSubmitPage(email, peerReviewInfo[i]);
            }));
          };
        } else {
          // call peer review outcome page
        }
      },
    );
  }

  Future<List<PeerReviewInfo>> _queryPeerReviewInfo(String assignTitle) async {
    Future<Database> db =
        openDatabase(join(await getDatabasesPath(), 'learningApp_database.db'));
    Database dbRef = await db;

    var res = await dbRef.query(
      PeerReviewInfo.tableName,
      where: 'courseID = ? AND assignTitle = ? AND reviewerEmail = ?',
      whereArgs: [courseID, assignTitle, email],
    );

    return List.generate(
        res.length, (index) => PeerReviewInfo.fromMap(res[index]));
  }

  Future<AssignmentSubmissionInfo> _queryAssignSubmits(
      String assignTitle) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    var res = await dbRef.query('assignmentSubmissions',
        where: 'assignTitle = ? AND courseID = ? AND studentEmail = ?',
        whereArgs: [assignTitle, courseID, email],
        orderBy: 'submitDate DESC');

    dbRef.close();

    if (res.length < 1) {
      return null;
    }

    return AssignmentSubmissionInfo.fromMap(res.first);
  }

  @override
  void dispose() => super.dispose();
}
