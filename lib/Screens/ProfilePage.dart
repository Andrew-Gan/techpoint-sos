import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../CreateDB.dart';
import 'teacher/TeacherCoursePage.dart';
import 'student/StudentCoursePage.dart';
import 'student/StudentRewardPage.dart';
import '../REST_API.dart';
import 'admin/AdminDataExportPage.dart';

class ProfilePage extends StatelessWidget {
  final AccountInfo userInfo;

  ProfilePage(this.userInfo);

  @override
  Widget build(BuildContext context) {
    int numCourses = userInfo.regCourse == null ? 0 : userInfo.regCourse.split(',').length;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              userInfo.privilege > AccountPrivilege.admin.index ? 
                Icons.star : Icons.cloud_download,
            ),
            onPressed: () => userInfo.privilege > AccountPrivilege.admin.index ?
              _onRewardPress(context) : _onDownloadPress(context),
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
                              userInfo.name,
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
                              userInfo.email,
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
                              userInfo.college,
                              style: TextStyle(fontSize: 16.0,),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 65.0),
                        child: Text(
                          (userInfo.receivedScore - userInfo.deductedScore).toString(),
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
                      if (index >= numCourses)
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
    List<String> regCourses = userInfo.regCourse.split(',');
    String courseID = regCourses[index];
    return ListTile(
      title: Text(
        courseID,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        var assignQInfos = await _queryAssignmentInfos(courseID);
        List<int> score = await _queryCourseScore(courseID);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            if(userInfo.privilege == AccountPrivilege.student.index)
              return StudentCoursePage(userInfo, courseID, assignQInfos, score[0], score[1]);
              
            else if(userInfo.privilege == AccountPrivilege.teacher.index)
              return TeacherCoursePage(userInfo.accountID, courseID, assignQInfos);

            else return null;
          }
        ),);
      },
    );
  }

  Future<List<AssignmentQuestionInfo>> _queryAssignmentInfos(String courseID) async {
    var map = await restQuery(AssignmentQuestionInfo.tableName, '*', 
      'courseID=$courseID');

    List<AssignmentQuestionInfo> queryRes = List.generate(
      map.length,
      (i) => AssignmentQuestionInfo.fromMap(map[i]),
    );

    return queryRes;
  }

  Future<List<int>> _queryCourseScore(String courseID) async {
    int totalReceived = 0, totalMax = 0, studentID = userInfo.accountID;

    var map = await restQuery(AssignmentSubmissionInfo.tableName, 'assignID, recScore',
      '(studentID=$studentID)and(courseID=$courseID)');
    for(int i = 0; i < map.length; i++) {
      totalReceived += map[i]['recScore'];

      var assignID = map[i]['assignID'];
      var map2 = await restQuery(AssignmentQuestionInfo.tableName, 'maxScore', 'assignID=$assignID');
      totalMax += map2[0]['maxScore'];
    }
    
    return [totalReceived, totalMax];
  }

  void _onRewardPress(BuildContext context) async {
    var rewards = await restQuery(RewardInfo.tableName, '*', '');
    List<RewardInfo> rewardList = List.generate(
      rewards.length, 
      (i) => RewardInfo.fromMap(rewards[i])
    );

    var studentID = userInfo.accountID;
    var redeems = await restQuery(RedeemedRewardInfo.tableName, 'rewardID', 
      'studentID=$studentID');
    List<int> redeemList = List.generate(
      redeems.length, 
      (i) => redeems[i]['rewardID']
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => StudentRewardPage(
        userInfo,
        rewardList,
        redeemList,
      ),)
    );
  }

  void _onDownloadPress(BuildContext context) async {
    var resp = await restQuerySchema('name');
    List<String> tableNames = List.generate(resp.length, (i) => resp[i]['name']);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => 
        AdminDataExportPage(tableNames, userInfo))
    );
  }
}