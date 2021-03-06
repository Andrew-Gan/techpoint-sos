import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

/// stateful class for instantiating StudentRewardPage screen
class StudentRewardPage extends StatefulWidget {
  final AccountInfo studentInfo;
  final List<RewardInfo> rewards;
  final List<int> redeems;
  StudentRewardPage(this.studentInfo, this.rewards, this.redeems);

  @override
  State<StudentRewardPage> createState() =>
    _StudentRewardPageState(studentInfo, rewards, redeems);
}

/// state class for StudentRewardPage screen
class _StudentRewardPageState extends State<StudentRewardPage> {
  int points;
  bool isInsufficient = false;
  final AccountInfo studentInfo;
  final List<RewardInfo> rewards;
  final List<int> redeems;

  _StudentRewardPageState(this.studentInfo, this.rewards, this.redeems) {
    points = studentInfo.receivedScore - studentInfo.deductedScore;
  }

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Rewards'),
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
                    'Available points: ' + points.toString(),
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0),
                  child: Visibility(
                    child: Text(
                      'You have insufficient points!',
                      style: TextStyle(color: Colors.red),
                    ),
                    replacement: Text(''),
                    visible: isInsufficient,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0,),
                  height: 150.0,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, i) {
                      final index = i ~/ 2;
                      if (index >= rewards.length) return null;
                      if (i.isOdd) return Divider();
                      return _buildRewardRow(context, index);
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

  Widget _buildRewardRow(BuildContext context, int i) {
    return ListTile(
      title: Text(
        rewards[i].title + '\ncost: ' + rewards[i].cost.toString(),
      ),
      trailing: Icon(
        Icons.redeem,
        color: redeems.contains(rewards[i].rewardID) ? Colors.red : null,
      ),
      onTap: () async {
        onRedeemPress(rewards[i]);
      }
    );
  }

  void onRedeemPress(RewardInfo reward) async {
    // do nothing if user already claimed reward
    if(redeems.contains(reward.rewardID)) return;

    // display error message if student has insufficient score
    if((studentInfo.receivedScore - studentInfo.deductedScore) < reward.cost) {
      setState(() => isInsufficient = true);
      return;
    }

    // deduct from student score and update row
    studentInfo.deductedScore += reward.cost;
    int accountID = studentInfo.accountID;
    await restUpdate(AccountInfo.tableName, 'accountID=$accountID', studentInfo.toMap());

    var map = RedeemedRewardInfo(
      rewardID: reward.rewardID,
      studentID: studentInfo.accountID,
      redeemDate: DateTime.now().millisecondsSinceEpoch,
    ).toMap();
    await restInsert(RedeemedRewardInfo.tableName, map);

    redeems.add(reward.rewardID);
    setState(() {
      isInsufficient = false;
      setState(() => points -= reward.cost);
    });
  }

  @override
  void dispose() => super.dispose();
}