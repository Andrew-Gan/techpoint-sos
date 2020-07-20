// auto increment primary keys are not included in toMap()
// all time entries are stored as milliseconds since unix epoch time

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
  String name, email, password, major, year, college, regCourse;
  int accountID, privilege, receivedScore, deductedScore;

  AccountInfo({this.name, this.email, this.password, this.major,this.year,
    this.college, this.regCourse, this.privilege, this.receivedScore, 
    this.deductedScore});
  
  AccountInfo.fromMap(Map<String, dynamic> map) {
    this.accountID = map['accountID'];
    this.name = map['name'];
    this.email = map['email'];
    this.password = map['password'];
    this.major = map['major'];
    this.year = map['year'];
    this.college = map['college'];
    this.regCourse = map['regCourse'];
    this.privilege = map['privilege'];
    this.receivedScore = map['receivedScore'];
    this.deductedScore = map['deductedScore'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'major': major,
      'year': year,
      'college': college,
      'regCourse': regCourse,
      'privilege': privilege,
      'receivedScore': receivedScore,
      'deductedScore': deductedScore,
    };
  }
}

class AssignmentQuestionInfo implements SQLiteInfo {
  static String tableName = 'assignmentQuestions';
  int assignID, dueDate, maxScore, instrID;
  String assignTitle, courseID, content;

  AssignmentQuestionInfo({this.assignTitle, this.courseID,
    this.content, this.dueDate, this.instrID, this.maxScore,});

  AssignmentQuestionInfo.fromMap(Map<String, dynamic> map) {
    this.assignID = map['assignID'];
    this.courseID = map['courseID'];
    this.assignTitle = map['assignTitle'];
    this.content = map['content'];
    this.dueDate = map['dueDate'];
    this.instrID = map['instrID'];
    this.maxScore = map['maxScore'];
  }

  Map<String, dynamic> toMap() {
    return {
      'assignTitle': assignTitle,
      'courseID': courseID,
      'content': content,
      'dueDate': dueDate,
      'instrID': instrID,
      'maxScore': maxScore,
    };
  }
}

class AssignmentSubmissionInfo implements SQLiteInfo {
  static String tableName = 'assignmentSubmissions';
  String content, remarks, courseID;
  int submitID, assignID, submitDate, studentID, recScore;

  AssignmentSubmissionInfo({this.assignID, this.courseID, this.studentID,
    this.content, this.submitDate, this.recScore, this.remarks,});

  AssignmentSubmissionInfo.fromMap(Map<String, dynamic> map) {
    this.courseID = map['courseID'];
    this.submitID = map['submitID'];
    this.assignID = map['assignID'];
    this.studentID = map['studentID'];
    this.content = map['content'];
    this.submitDate = map['submitDate'];
    this.recScore = map['recScore'];
    this.remarks = map['remarks'];
  }

  Map<String, dynamic> toMap() {
    return {
      'assignID': assignID,
      'content': content,
      'submitDate': submitDate,
      'courseID': courseID,
      'studentID': studentID,
      'recScore': recScore,
      'remarks': remarks,
    };
  }
}

class PeerReviewInfo implements SQLiteInfo {
  static String tableName = 'peerReviews';
  String content;
  int peerID, assignID, submitID, dueDate, reviewerID, reviewedID, instrID;

  PeerReviewInfo({this.submitID, this.content, this.assignID, this.reviewerID,
    this.reviewedID, this.instrID, this.dueDate,});
  
  PeerReviewInfo.fromMap(Map<String, dynamic> map) {
    this.peerID = map['peerID'];
    this.assignID = map['assignID'];
    this.submitID = map['submitID'];
    this.content = map['content'];
    this.dueDate = map['dueDate'];
    this.reviewerID = map['reviewerID'];
    this.reviewedID = map['reviewedID'];
    this.instrID = map['instrID'];
  }
  
  Map<String, dynamic> toMap() {
    return {
      'assignID': assignID,
      'submitID': submitID,
      'content': content,
      'reviewerID': reviewerID,
      'reviewedID': reviewedID,
      'instrID': instrID,
      'dueDate': dueDate,
    };
  }
}

class RewardInfo implements SQLiteInfo {
  static String tableName = 'rewardsList';
  int rewardID, hasLimit, redeemLimit, cost;
  String title, desc;

  RewardInfo({this.title, this.desc, this.cost,
    this.hasLimit, this.redeemLimit,});
  
  RewardInfo.fromMap(Map<String, dynamic> map) {
    this.rewardID = map['rewardID'];
    this.hasLimit = map['hasLimit'];
    this.redeemLimit = map['redeemLimit'];
    this.cost = map['cost'];
    this.title = map['title'];
    this.desc = map['desc'];
  }
  
  Map<String, dynamic> toMap() {
    return {
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
  int redeemedID, studentID, rewardID, redeemDate;

  RedeemedRewardInfo({this.rewardID, this.studentID, this.redeemDate,});
  
  RedeemedRewardInfo.fromMap(Map<String, dynamic> map) {
    this.redeemedID = map['redeemedID'];
    this.studentID = map['studentID'];
    this.rewardID = map['rewardID'];
    this.redeemDate = map['redeemDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'rewardID': rewardID,
      'studentID': studentID,
      'redeemDate': redeemDate,
    };
  }
}