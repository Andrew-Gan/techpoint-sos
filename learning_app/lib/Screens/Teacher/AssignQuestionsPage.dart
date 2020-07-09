import '../../CreateDB.dart';
import 'package:flutter/material.dart';

class AssignQuestionsPage extends StatelessWidget {
  final String courseID;
  final String email;
  final List<AssignmentQuestionInfo> assignQInfo;
  AssignQuestionsPage(this.email, this.courseID, this.assignQInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Assignment Questions'),
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
                        child: Text(
                          courseID,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, i) {
                          final index = i ~/ 2;
                          if (index >= assignQInfo.length) return null;
                          if (i.isOdd) return Divider();
                          return _buildRow(context, index);
                        }
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
          MaterialPageRoute(builder: (context) => AssignUpdatePage(assignQInfo[i])),
        );
      },
    );
  }
}