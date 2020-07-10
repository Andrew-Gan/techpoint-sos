import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:developer';

void debugQuery() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'learningApp_database.db'),
  );

  var dbRef = await db;

  var res = await dbRef.query(
    'assignmentQuestions',
    where: 'assignTitle = ? AND courseID = ?',
    whereArgs: ['Weekly assignment #1: Voltage and Resistance', 'ECE 20100'],
  );

  log(res.first['content']);
}