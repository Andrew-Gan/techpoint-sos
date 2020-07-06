import 'dart:async';
import 'Screens/LoginPage.dart';
import 'Screens/CoursePage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void createDB() async {
  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'learningApp_database.db'),

    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE accounts(name TEXT, email TEXT UNIQUE, password TEXT,'
        'major TEXT, year TEXT, college TEXT, regCourse TEXT)',
      );
      await db.execute(
        'CREATE TABLE courses(id TEXT UNIQUE, title TEXT,'
        'description TEXT, credit INTEGER, prereq TEXT)',
      );
      await db.execute(
        'CREATE TABLE assignments(courseID TEXT, title TEXT,'
        'content TEXT, dueDate INTEGER, instructor TEXT)',
      );
      await db.execute(
        'CREATE TABLE reviews(courseID TEXT, title TEXT,'
        'sender TEXT, receiver TEXT, instructor TEXT)',
      );
    },
    version: 1
  );

  // user info for testing

  final Database dbRef = await db;
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

  // course info for testing
  dbRef.insert(
    'courses',
    CourseInfo(
      id: 'ECE 20100',
      title: 'Linear Circuit Analysis I',
      description: 'Volt-ampere characteristics for circuit elements;'
      'independent and dependent sources; Kirchhoff\'s laws and circuit'
      'equations. Source transformation; Thevenin\'s and Norton\'s theorems;'
      'superposition, step response of 1st order (RC, RL) and 2nd order (RLC)'
      'circuits. Phasor analysis, impedance calculations, and computation of'
      'sinusoidal steady state responses. Instantaneous and average power,'
      'complex power, power factor correction, and maximum power transfer.'
      'Instantaneous and average power.',
      credit: 3,
      prereq: 'ENGR 13100,PHYS 17200,MA 16600,MA 26100',
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  dbRef.insert(
    'courses',
    CourseInfo(
      id: 'ECE 20200',
      title: 'Linear Circuit Analysis II',
      description: 'Continuation of ECE 20100. Use of Laplace Transform'
      'techniques to analyze linear circuits with and without initial'
      'conditions. Characterization of circuits based upon impedance,'
      'admittance, and transfer function parameters. Determination of frequency'
      'response via analysis of poles and zeroes in the complex plane.'
      'Relationship between the transfer function and the impulse response of a'
      'circuit. Use of continuous time convolution to determine time domain'
      'responses. Properties and practical uses of resonant circuits and'
      'transformers. Input - output characterization of a circuit as a'
      'two-port. Low and high-pass filter design.',
      credit: 3,
      prereq: 'ECE 20100,MA 26600',
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // dbRef.close();
  db.whenComplete(() => null);
}