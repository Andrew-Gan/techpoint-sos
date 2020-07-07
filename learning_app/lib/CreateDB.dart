import 'dart:async';
import 'Screens/CourseDetailsPage.dart';
import 'Screens/LoginPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:convert';

/// void createDB() async
/// 
/// Create tables in the same database if the db file is not found
/// Insert entries into the tables for testing purposes
/// Note: all time data are stored as 'UnixTimeFromEpoch'

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'learningApp_database.db'),

    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT UNIQUE, password TEXT,'
        'major TEXT, year TEXT, college TEXT, regCourse TEXT)',
      );
      await db.execute(
        'CREATE TABLE assignmentQuestions(assignTitle TEXT UNIQUE, courseID TEXT,'
        'imageB64 TEXT, content TEXT, dueDate INTEGER, instrEmail TEXT)',
      );
      await db.execute(
        'CREATE TABLE assignmentAnswers(assignTitle TEXT, courseID TEXT'
        'content TEXT, submitDate INTEGER, studentEmail TEXT)',
      );
      await db.execute(
        'CREATE TABLE reviews(courseID TEXT, title TEXT,'
        'sender TEXT, receiver TEXT, instrEmail TEXT)',
      );
    },
    version: 1
  );

  final Database dbRef = await db;

  // user info for testing
  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Andrew Gan',
      email: 'gan35@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // encode image file to base64
  final imgBytes = await File('assets/images/circuit.jpeg').readAsBytes();
  String imgB64 = base64.encode(imgBytes);

  // assignment info for testing
  dbRef.insert(
    'assignments',
    AssignmentInfo(
      assignTitle: 'Weekly assignment #1: Voltage and Resistance',
      courseID: 'ECE 20100',
      imageB64: imgB64,
      content: 'Suppose a diagram',
      dueDate: 1594166399000,
      instrEmail: 'teacher@purdue.edu',
    ).toMap(),
  );

  // dbRef.close();
  db.whenComplete(() => null);
}