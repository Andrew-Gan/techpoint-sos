import '../../CreateDB.dart';
import 'package:flutter/material.dart';
import 'TeacherViewSubmitPage.dart';

class TeacherAssignSubmissionsPage extends StatefulWidget {
  final AssignmentQuestionInfo assignQInfo;
  final List<AssignmentSubmissionInfo> assignSInfo;
  TeacherAssignSubmissionsPage(this.assignQInfo, this.assignSInfo);

  @override
  State<TeacherAssignSubmissionsPage> createState() => 
    _TeacherAssignSubmissionsPageState(assignQInfo, assignSInfo);
}

class _TeacherAssignSubmissionsPageState extends State<TeacherAssignSubmissionsPage> {
  final AssignmentQuestionInfo assignQInfo;
  final List<AssignmentSubmissionInfo> assignSInfo;
  _TeacherAssignSubmissionsPageState(this.assignQInfo, this.assignSInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Submissions'),
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
                        padding: EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: Text(
                            assignQInfo.courseID,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: Text(
                            assignQInfo.assignTitle,
                            style: TextStyle(fontSize: 16.0,),
                          ),
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
    DateTime submitDate =
      DateTime.fromMillisecondsSinceEpoch(assignSInfo[i].submitDate);
    return ListTile(
      title: Text(
        assignSInfo[i].studentEmail + '\n' + submitDate.year.toString() + '-' +
          submitDate.month.toString() + '-' + submitDate.day.toString() + ', ' +
          submitDate.hour.toString() + ':' + submitDate.minute.toString(),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
          TeacherViewSubmitPage(assignQInfo, assignSInfo[i])
        )
      ),
    );
  }

  @override
  void dispose() => super.dispose();
}