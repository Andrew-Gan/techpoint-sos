import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class SQLiteInfo {
  static String tableName = '';
  SQLiteInfo();
  SQLiteInfo.fromMap(Map<String, dynamic> map);
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
  static String tableName = 'accounts';
  String name, email, major, year, college, password, regCourse;
  int privilege, receivedScore, deductedScore;

  AccountInfo({this.name, this.email, this.major,this.year, this.college,
    this.password, this.regCourse, this.privilege, this.receivedScore, 
    this.deductedScore});
  
  AccountInfo.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.email = map['email'];
    this.major = map['major'];
    this.year = map['year'];
    this.college = map['college'];
    this.password = map['password'];
    this.regCourse = map['regCourse'];
    this.privilege = map['privilege'];
    this.receivedScore = map['receivedScore'];
    this.deductedScore = map['deductedScore'];
  }

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
      'receivedScore': receivedScore,
      'deductedScore': deductedScore,
    };
  }
}

class AssignmentQuestionInfo implements SQLiteInfo {
  static String tableName = 'assignmentQuestions';
  String assignTitle, courseID, content, instrEmail;
  int dueDate, maxScore;

  AssignmentQuestionInfo({this.assignTitle, this.courseID, this.content,
    this.dueDate, this.instrEmail, this.maxScore,});

  AssignmentQuestionInfo.fromMap(Map<String, dynamic> map) {
    this.assignTitle = map['assignTitle'];
    this.courseID = map['courseID'];
    this.content = map['content'];
    this.dueDate = map['dueDate'];
    this.instrEmail = map['instrEmail'];
    this.maxScore = map['maxScore'];
  }

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
  static String tableName = 'assignmentSubmissions';
  String assignTitle, courseID, content, studentEmail, remarks;
  int submitDate, recScore;

  AssignmentSubmissionInfo({this.assignTitle, this.courseID, this.content,
    this.submitDate, this.studentEmail, this.recScore, this.remarks,});

  AssignmentSubmissionInfo.fromMap(Map<String, dynamic> map) {
    this.assignTitle = map['assignTitle'];
    this.courseID = map['courseID'];
    this.content = map['content'];
    this.submitDate = map['submitDate'];
    this.studentEmail = map['studentEmail'];
    this.recScore = map['recScore'];
    this.remarks = map['remarks'];
  }

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
  static String tableName = 'peerReviews';
  String courseID, assignTitle, content, reviewerEmail, reviewedEmail, instrEmail;
  int dueDate;

  PeerReviewInfo({this.courseID, this.assignTitle, this.content,
    this.reviewerEmail, this.reviewedEmail, this.instrEmail, this.dueDate,});
  
  PeerReviewInfo.fromMap(Map<String, dynamic> map) {
    this.assignTitle = map['assignTitle'];
    this.courseID = map['courseID'];
    this.content = map['content'];
    this.dueDate = map['dueDate'];
    this.reviewerEmail = map['reviewerEmail'];
    this.reviewedEmail = map['reviewedEmail'];
    this.instrEmail = map['instrEmail'];
  }
  
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

class RewardInfo implements SQLiteInfo {
  static String tableName = 'rewardsList';
  int rewardID, hasLimit, redeemLimit, cost;
  String title, desc;

  RewardInfo({this.rewardID, this.title, this.desc, this.cost,
    this.hasLimit, this.redeemLimit,});
  
  Map<String, dynamic> toMap() {
    return {
      'rewardID': rewardID,
      'title': title,
      'desc': desc,
      'cost': cost,
      'hasLimit': hasLimit,
      'redeemLimit': redeemLimit,
    };
  }
}

class RedeemedRewardInfo implements SQLiteInfo {
  static String tableName = 'redeemedRewards';
  int rewardID, redeemDate;
  String studentEmail;

  RedeemedRewardInfo({this.rewardID, this.studentEmail, this.redeemDate,});
  
  Map<String, dynamic> toMap() {
    return {
      'rewardID': rewardID,
      'studentEmail': studentEmail,
      'redeemDate': redeemDate,
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
        'major TEXT, year TEXT, college TEXT, regCourse TEXT, receivedScore INTEGER,'
        'deductedScore INTEGER, privilege INTEGER)'
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
      db.execute(
        'CREATE TABLE rewardsList(rewardID INTEGER PRIMARY KEY, title TEXT,'
        'desc TEXT, cost INTEGER, hasLimit INTEGER, redeemLimit INTEGER)'
      );
      db.execute(
        'CREATE TABLE redeemedRewards(studentEmail TEXT, rewardID INTEGER,'
        'redeemDate INTEGER)'
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
    AccountInfo.tableName,
    AccountInfo(
      name: 'Student 00',
      email: 'student00@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
      receivedScore: 0,
      deductedScore: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    AccountInfo.tableName,
    AccountInfo(
      name: 'Student 01',
      email: 'student01@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
      receivedScore: 0,
      deductedScore: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    AccountInfo.tableName,
    AccountInfo(
      name: 'Student 02',
      email: 'student02@purdue.edu',
      major: 'Computer Engineering',
      year: 'Senior',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100,ECE 20200',
      privilege: AccountPrivilege.student.index,
      receivedScore: 0,
      deductedScore: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    AccountInfo.tableName,
    AccountInfo(
      name: 'Some teacher',
      email: 'teacher00@purdue.edu',
      major: '',
      year: '',
      college: 'Purdue University',
      password: '123456',
      regCourse: 'ECE 20100',
      privilege: AccountPrivilege.teacher.index,
      receivedScore: 0,
      deductedScore: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    RewardInfo.tableName,
    RewardInfo(
      title: 'Wiley dining court discount 10\%',
      desc: 'Receive 10% discount off food in one entry',
      cost: 90,
      hasLimit: 0,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    RewardInfo.tableName,
    RewardInfo(
      title: 'Early course registration for fall 2020',
      desc: 'Start registering for courses in May for the upcoming term',
      cost: 300,
      hasLimit: 1,
      redeemLimit: 1,
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}