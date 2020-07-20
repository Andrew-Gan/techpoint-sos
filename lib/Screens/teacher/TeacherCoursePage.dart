import '../../CreateDB.dart';
import '../../REST_API.dart';
import 'TeacherAssignUpdatePage.dart';
import 'TeacherAssignCreatePage.dart';
import 'TeacherPeerCreatePage.dart';
import 'TeacherAssignSubmissionsPage.dart';
import 'package:flutter/material.dart';

class TeacherCoursePage extends StatelessWidget {
  final String courseID;
  final int instrID;
  final List<AssignmentQuestionInfo> assignQInfos;
  TeacherCoursePage(this.instrID, this.courseID, this.assignQInfos);

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
                  padding: EdgeInsets.only(top: 25.0, left: 25.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Text(
                      courseID,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 30.0),
                  child: Text(
                    'Assignments',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 10.0),
                  height: 380.0,
                  child: ListView.builder(
                    itemBuilder: (context, i) {
                      final index = i ~/ 2;
                      if (index >= assignQInfos.length) return null;
                      if (i.isOdd) return Divider();
                      return _buildRow(context, index);
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        child: Text('Add assignment'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                            TeacherAssignCreatePage(courseID, instrID)
                          )
                        ),
                      ),
                      OutlineButton(
                        child: Text('Add peer review'),
                        onPressed: () {
                          if(assignQInfos.length == 0) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                              TeacherPeerCreatePage(instrID, assignQInfos)
                            )
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignQInfos[i].assignTitle,
      ),
      trailing: Container(
        width: 120,
        child: Row (
          children: <Widget> [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.update),
              onPressed: () async {
                var info = await _queryAssignInfo(assignQInfos[i].assignID);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherAssignUpdatePage(info),
                  ),
                );
              }
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () async {
                var assignQInfo = await _queryAssignInfo(assignQInfos[i].assignID);
                var assignSInfo = await _queryAssignSubmits(assignQInfo);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                      TeacherAssignSubmissionsPage(assignQInfo, assignSInfo),
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Future<AssignmentQuestionInfo> _queryAssignInfo(int assignID) async {
    var map = await restQuery(AssignmentQuestionInfo.tableName, '*',
      'assignID=$assignID');

    var queryRes = List.generate(map.length, (i) {
      return AssignmentQuestionInfo.fromMap(map[i]);
    });

    return queryRes.first;
  }

  Future<List<AssignmentSubmissionInfo>> 
  _queryAssignSubmits(AssignmentQuestionInfo assignQInfos) async {
    int assignID = assignQInfos.assignID;
    var map = await restQuery(AssignmentSubmissionInfo.tableName, '*', 'assignID=$assignID');

    List<AssignmentSubmissionInfo> queryRes = List.generate(map.length, (i) => 
      AssignmentSubmissionInfo.fromMap(map[i]));

    return queryRes;
  }
}