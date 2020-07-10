import '../../CreateDB.dart';
import 'package:flutter/material.dart';

class TeacherAssignSubmissionsPage extends StatefulWidget {
  final List<AssignmentSubmissionInfo> assignSInfo;
  TeacherAssignSubmissionsPage(this.assignSInfo);

  @override
  State<TeacherAssignSubmissionsPage> createState() => 
    _TeacherAssignSubmissionsPageState(assignSInfo);
}

class _TeacherAssignSubmissionsPageState extends State<TeacherAssignSubmissionsPage> {
  final List<AssignmentSubmissionInfo> assignSInfo;
  _TeacherAssignSubmissionsPageState(this.assignSInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Course'),
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
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 50.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: Text(
                                assignSInfo.first.courseID,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 50.0),
                            child: Text(
                              'Assignment Submissions',
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
                                if (index >= assignSInfo.length) return null;
                                if (i.isOdd) return Divider();
                                return _buildRow(context, index);
                              }
                            ),
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
      )
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        assignSInfo[i].studentEmail,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: null,
    );
  }

  @override
  void dispose() => super.dispose();
}