import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../CreateDB.dart';

class StudentRewardPage extends StatefulWidget {
  final int points;
  final List<RewardInfo> rewards;
  final List<int> redeems;
  final String email;
  StudentRewardPage(this.email, this.points, this.rewards, this.redeems);

  @override
  State<StudentRewardPage> createState() =>
    _StudentRewardPageState(email, points, rewards, redeems);
}

class _StudentRewardPageState extends State<StudentRewardPage> {
  int points;
  final List<RewardInfo> rewards;
  final List<int> redeems;
  final String email;

  _StudentRewardPageState(this.email, this.points, this.rewards, this.redeems);

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
        rewards[i].title,
      ),
      trailing: Icon(
        Icons.redeem,
        color: redeems.contains(rewards[i].rewardID) ? Colors.red : null,
      ),
      onTap: () async {
        onRedeemPress(rewards[i]);
        setState(() => points -= rewards[i].cost);
      }
    );
  }

  void onRedeemPress(RewardInfo reward) async {
    if(redeems.contains(reward.rewardID)) return;

    final Future<Database> db = openDatabase(
      join(await getDatabasesPath(), 'learningApp_database.db'));

    final Database dbRef = await db;

    await dbRef.insert(
      RedeemedRewardInfo.tableName,
      RedeemedRewardInfo(
        rewardID: reward.rewardID,
        studentEmail: email,
        redeemDate: DateTime.now().millisecondsSinceEpoch,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    redeems.add(reward.rewardID);

    var res = await dbRef.query(
      AccountInfo.tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    AccountInfo userInfo = AccountInfo.fromMap(res.first);
    userInfo.deductedScore += reward.cost;

    await dbRef.update(
      AccountInfo.tableName,
      userInfo.toMap(),
    );
    
    dbRef.close();
  }

  @override
  void dispose() => super.dispose();
}