import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'account_database.db'),
    onCreate: (db, version) async {
      return await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT, password TEXT, major TEXT, year TEXT, college TEXT)',
      );
    },
    version: 1
  );
  db.whenComplete(() => null);
}