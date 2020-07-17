import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../CreateDB.dart';
import 'teacher/TeacherCoursePage.dart';
import 'student/StudentCoursePage.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'student/StudentRewardPage.dart';

class ProfilePage extends StatelessWidget {
  final AccountInfo userinfo;

  ProfilePage(this.userinfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => _onRewardPress(context),
          ),
        ],
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
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0,),
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 5.0,
                            ),
                            child: Text(
                              userinfo.name,
                              style: TextStyle(fontSize: 16.0,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 15.0
                            ),
                            child: Text(
                              'Email ID',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 5.0,
                            ),
                            child: Text(
                              userinfo.email,
                              style: TextStyle(fontSize: 16.0,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 15.0,
                            ),
                            child: Text(
                              'College',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 5.0,
                            ),
                            child: Text(
                              userinfo.college,
                              style: TextStyle(fontSize: 16.0,),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 65.0),
                        child: Text(
                          (userinfo.receivedScore - userinfo.deductedScore).toString(),
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Text(
                    'Registered courses',
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
                      if (index >= userinfo.regCourse.split(',').length)
                        return null;
                      if (i.isOdd) return Divider();
                      return _buildRow(context, index);
                    }
                  ),
                ),
              ],
            ),
          ),
        ]
      )
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    List<String> regCourses = userinfo.regCourse.split(',');
    String courseID = regCourses[index];
    return ListTile(
      title: Text(
        courseID,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        var assignQInfos = await _queryAssignmentInfos(courseID);
        int score = await _queryCourseScore(courseID);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            if(userinfo.privilege == AccountPrivilege.student.index)
              return StudentCoursePage(userinfo, courseID, assignQInfos, score);
              
            else if(userinfo.privilege == AccountPrivilege.teacher.index)
              return TeacherCoursePage(userinfo.accountID, courseID, assignQInfos);

            else return null;
          }
        ),);
      },
    );
  }

  Future<List<AssignmentQuestionInfo>> _queryAssignmentInfos(String courseID) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    final res = await dbRef.query(
      AssignmentQuestionInfo.tableName,
      distinct: true,
      where: 'courseID = ?',
      whereArgs: [courseID],
      orderBy: 'dueDate',
    );

    dbRef.close();

    List<AssignmentQuestionInfo> queryRes = List.generate(
      res.length,
      (i) => AssignmentQuestionInfo.fromMap(res[i]),
    );

    return queryRes;
  }

  Future<int> _queryCourseScore(String courseID) async {
    int sum = 0;

    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'),
    );
    Database dbRef = await db;

    final res = await dbRef.query(
      AssignmentSubmissionInfo.tableName,
      distinct: true,
      where: 'studentID = ? AND courseID = ?',
      whereArgs: [userinfo.accountID, courseID],
    );

    for(int i = 0; i < res.length; i++) sum += res[i]['recScore'];

    dbRef.close();
    return sum;
  }

  void _onRewardPress(BuildContext context) async {
    Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db')
    );
    Database dbRef = await db;

    var res = await dbRef.query(
      RewardInfo.tableName,
    );

    var redeem = await dbRef.query(
      RedeemedRewardInfo.tableName,
      where: 'studentID = ?',
      whereArgs: [userinfo.accountID],
    );

    var rewardList = List.generate(res.length, (i) => RewardInfo.fromMap(res[i]));
    List<int> redeemList = List.generate(redeem.length, (i) => redeem[i]['rewardID']);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => StudentRewardPage(
        userinfo,
        rewardList,
        redeemList,
      ),)
    );
  }
}
