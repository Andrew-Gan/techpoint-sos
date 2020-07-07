import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'dart:io';
// import 'dart:convert';

abstract class SQLiteInfo {
  final String tableName = '';
  Map<String, dynamic> toMap();
}

class AccountInfo implements SQLiteInfo {
  final String tableName = 'accounts';
  final String name, email, major, year, college, password, regCourse;

  AccountInfo({this.name, this.email, this.major,this.year, this.college,
    this.password, this.regCourse,});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'major': major,
      'year': year,
      'college': college,
      'password': password,
      'regCourse': regCourse,
    };
  }
}

class AssignmentQuestionInfo implements SQLiteInfo {
  final String tableName = 'assignmentQuestions';
  final String assignTitle, courseID, imageB64, content, instrEmail;
  final int dueDate;

  AssignmentQuestionInfo({this.assignTitle, this.courseID, this.imageB64,
    this.content, this.dueDate, this.instrEmail,});

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'imageB64': imageB64,
      'content': content,
      'dueDate': dueDate,
      'instrEmail': instrEmail,
    };
  }
}

class AssignmentSubmissionInfo implements SQLiteInfo {
  final String tableName = 'assignmentSubmissions';
  final String assignTitle, courseID, content, studentEmail;
  final int submitDate;

  AssignmentSubmissionInfo({this.assignTitle, this.courseID, this.content,
    this.submitDate, this.studentEmail,});

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'content': content,
      'submitDate': submitDate,
      'studentEmail': studentEmail,
    };
  }
}

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
  // String imgPath = Directory.current.path + '/assets/images/circuit.jpeg';
  // final imgBytes = await File(imgPath).readAsBytes();
  // String imgB64 = base64.encode(imgBytes);
  String imgB64 = '';

  // assignment info for testing
  dbRef.insert(
    'assignmentQuestions',
    AssignmentQuestionInfo(
      assignTitle: 'Weekly assignment #1: Voltage and Resistance',
      courseID: 'ECE 20100',
      imageB64: imgB64,
      content: 'Suppose a diagram',
      dueDate: 1594166399000,
      instrEmail: 'teacher@purdue.edu',
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // dbRef.close();
}