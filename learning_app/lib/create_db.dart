import 'dart:async';
import 'Screens/LoginPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'account_database.db'),

    // create a table named 'accounts' with the following columns
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT, password TEXT,'
        'major TEXT, year TEXT, college TEXT)',
      );
      await db.execute(
        'CREATE TABLE registeredCourses(email TEXT, course TEXT, currentXP INT,'
        'maxXP INT)',
      );
    },
    version: 1
  );

  final Database dbRef = await db;
  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Andrew Gan',
      email: 'gan35@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456'
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  // dbRef.close();
  db.whenComplete(() => null);
}