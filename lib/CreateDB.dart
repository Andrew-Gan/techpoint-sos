import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class SQLiteInfo {
  final String tableName = '';
  Map<String, dynamic> toMap();
}

enum AccountPrivilege {
  root,
  admin,
  teacher,
  student,
  guest,
}

class AccountInfo implements SQLiteInfo {
  final String tableName = 'accounts';
  final String name, email, major, year, college, password, regCourse;
  final int privilege;

  AccountInfo({this.name, this.email, this.major,this.year, this.college,
    this.password, this.regCourse, this.privilege});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'major': major,
      'year': year,
      'college': college,
      'password': password,
      'regCourse': regCourse,
      'privilege': privilege,
    };
  }
}

class AssignmentQuestionInfo implements SQLiteInfo {
  final String tableName = 'assignmentQuestions';
  final String assignTitle, courseID, content, instrEmail;
  final int dueDate, maxScore;

  AssignmentQuestionInfo({this.assignTitle, this.courseID, this.content,
    this.dueDate, this.instrEmail, this.maxScore,});

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'content': content,
      'dueDate': dueDate,
      'instrEmail': instrEmail,
      'maxScore': maxScore,
    };
  }
}

class AssignmentSubmissionInfo implements SQLiteInfo {
  final String tableName = 'assignmentSubmissions';
  final String assignTitle, courseID, content, studentEmail, remarks;
  final int submitDate, recScore;

  AssignmentSubmissionInfo({this.assignTitle, this.courseID, this.content,
    this.submitDate, this.studentEmail, this.recScore, this.remarks,});

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'content': content,
      'submitDate': submitDate,
      'studentEmail': studentEmail,
      'recScore': recScore,
      'remarks': remarks,
    };
  }
}

class PeerReviewInfo implements SQLiteInfo {
  final String tableName = 'peerReviews';
  final String courseID, assignTitle, content, reviewerEmail, reviewedEmail,
    instrEmail;
  final int dueDate;

  PeerReviewInfo({this.courseID, this.assignTitle, this.content,
    this.reviewerEmail, this.reviewedEmail, this.instrEmail, this.dueDate,});
  
  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'assignTitle': assignTitle,
      'content': content,
      'reviewerEmail': reviewerEmail,
      'reviewedEmail': reviewedEmail,
      'instrEmail': instrEmail,
      'dueDate': dueDate,
    };
  }
}

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'learningApp_database.db'),

    // all time entries are stored as milliseconds since unix epoch time

    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT UNIQUE, password TEXT,'
        'major TEXT, year TEXT, college TEXT, regCourse TEXT, privilege INTEGER)'
      );
      db.execute(
        'CREATE TABLE assignmentQuestions(assignTitle TEXT UNIQUE, courseID TEXT'
        'UNIQUE, content TEXT, dueDate INTEGER, instrEmail TEXT,'
        'maxScore INTEGER)',
      );
      db.execute(
        'CREATE TABLE assignmentSubmissions(assignTitle TEXT, courseID TEXT,'
        'content TEXT, submitDate INTEGER, studentEmail TEXT, recScore INTEGER,'
        'remarks TEXT, UNIQUE(assignTitle, courseID, studentEmail))'
      );
      db.execute(
        'CREATE TABLE peerReviews(courseID TEXT, assignTitle TEXT, content TEXT,'
        'reviewerEmail TEXT, reviewedEmail TEXT, instrEmail TEXT, dueDate INTEGER,'
        'UNIQUE(courseID, assignTitle, reviewerEmail, reviewedEmail))'
      );
    },
    onOpen: (db) => insertTestInfo(db),
    version: 1,
  );

  final Database dbRef = await db;
  dbRef.close();
}

void insertTestInfo(Database dbRef) async {
  // user info for testing
  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Student 00',
      email: 'student00@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Student 01',
      email: 'student01@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Student 02',
      email: 'student02@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Some teacher',
      email: 'teacher00@purdue.edu',
      major: '',
      year: '',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100',
      privilege: AccountPrivilege.teacher.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}