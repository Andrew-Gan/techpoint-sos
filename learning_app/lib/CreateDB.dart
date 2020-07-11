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
  final int dueDate, maxScore, isPeerReview, peerReviewCount, reviewDueDate;

  AssignmentQuestionInfo({this.assignTitle, this.courseID, this.content,
    this.dueDate, this.instrEmail, this.maxScore, this.isPeerReview,
    this.peerReviewCount, this.reviewDueDate});

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'content': content,
      'dueDate': dueDate,
      'instrEmail': instrEmail,
      'maxScore': maxScore,
      'isPeerReview': isPeerReview,
      'peerReviewCount': peerReviewCount,
      'reviewDueDate': reviewDueDate,
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
  final String tableName = 'peerReview';
  final String courseID, assignTitle, content, reviewerEmail, reviewedEmail,
    instrEmail;

  PeerReviewInfo({this.courseID, this.assignTitle, this.content,
    this.reviewerEmail, this.reviewedEmail, this.instrEmail,});
  
  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'assignTitle': assignTitle,
      'content': content,
      'reviewerEmail': reviewerEmail,
      'reviewedEmail': reviewedEmail,
      'instrEmail': instrEmail,
    };
  }
}

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'learningApp_database.db'),

    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT UNIQUE, password TEXT,'
        'major TEXT, year TEXT, college TEXT, regCourse TEXT, privilege INTEGER)',
      );
      await db.execute(
        'CREATE TABLE assignmentQuestions(assignTitle TEXT UNIQUE, courseID TEXT'
        'UNIQUE, content TEXT, dueDate INTEGER, instrEmail TEXT,'
        'maxScore INTEGER, isPeerReview INTEGER, peerReviewCount INTEGER,'
        'reviewDueDate INTEGER)',
      );
      await db.execute(
        'CREATE TABLE assignmentSubmissions(assignTitle TEXT, courseID TEXT,'
        'content TEXT, submitDate INTEGER, studentEmail TEXT, recScore INTEGER,'
        'remarks TEXT, UNIQUE(assignTitle, courseID, studentEmail))',
      );
      await db.execute(
        'CREATE TABLE peerReviews(courseID TEXT, assignTitle TEXT, content TEXT'
        'reviewerEmail TEXT, reviewedEmail TEXT, instrEmail TEXT)',
      );
    },
    version: 1
  );

  final Database dbRef = await db;

  // user info for testing
  await dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Andrew Gan',
      email: 'gan35@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await dbRef.insert(
    'accounts',
    AccountInfo(
      name: 'Paul Ryan',
      email: 'paul@purdue.edu',
      major: '',
      year: '',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100',
      privilege: AccountPrivilege.teacher.index,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // assignment info for testing
  await dbRef.insert(
    'assignmentQuestions',
    AssignmentQuestionInfo(
      assignTitle: 'Weekly assignment #1: Voltage and Resistance',
      courseID: 'ECE 20100',
      content: 'Suppose a diagram',
      dueDate: 1594166399000,
      instrEmail: 'teacher@purdue.edu',
      maxScore: 100,
      isPeerReview: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await dbRef.insert(
    'assignmentQuestions',
    AssignmentQuestionInfo(
      assignTitle: 'Weekly assignment #2: Nodal and Loop Analysis',
      courseID: 'ECE 20100',
      content: 'Calculate using nodal analysis',
      dueDate: 1894166399000,
      instrEmail: 'teacher@purdue.edu',
      maxScore: 100,
      isPeerReview: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await dbRef.insert(
    'assignmentQuestions',
    AssignmentQuestionInfo(
      assignTitle: 'Weekly assignment #3: Circuit Simplification',
      courseID: 'ECE 20100',
      content: 'Suppose a diagram',
      dueDate: 1894166399000,
      instrEmail: 'teacher@purdue.edu',
      maxScore: 100,
      isPeerReview: 1,
      peerReviewCount: 3,
      reviewDueDate: 2194166399000,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.close();
}