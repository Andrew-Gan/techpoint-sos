import '../../CreateDB.dart';
import '../AssignPage.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  final String email;
  final String courseID;
  final List<AssignmentQuestionInfo> assignQInfo;
  CoursePage(this.email, this.courseID, this.assignQInfo);

  @override
  State<CoursePage> createState() => _CoursePageState(email, courseID, assignQInfo);
}

class _CoursePageState extends State<CoursePage> {
  final String courseID;
  final String email;
  final List<AssignmentQuestionInfo> assignQInfo;
  _CoursePageState(this.email, this.courseID, this.assignQInfo);

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
                                courseID,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20.0, left: 90.0),
                              width: 250.0,
                              height: 80.0,
                              child: Text(
                                '0 / 1000',
                                style: TextStyle(fontSize: 30.0),
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
                              'Assignments',
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
                                if (index >= assignQInfo.length) return null;
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
        assignQInfo[i].assignTitle,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AssignPage(email, assignQInfo[i])),
        );
      },
    );
  }

  @override
  void dispose() => super.dispose();
}