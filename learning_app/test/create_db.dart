import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AccountInfo {
  final String name;
  final String email;
  final String major;
  final String year;
  final String college;
  final String password;

  AccountInfo({this.name, this.email, this.major,this.year, this.college,
    this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'major': major,
      'year': year,
      'college': college,
      'password': password,
    };
  }
}

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'account_database.db'),

    // create a table named 'accounts' with the following columns
    onCreate: (db, version) async {
      return await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT, password TEXT,'
        'major TEXT, year TEXT, college TEXT)',
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
  );
  dbRef.close();
  db.whenComplete(() => null);
}