import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class CoursePage extends StatefulWidget {
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // replace with db retrieval
  final _courses = ['ECE 101', 'ECE 201', 'ECE 202', 'ECE 301', 'ENGR 132', 'ENGL 106'];
  final _registered = <String>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Listing'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _showCourseInfo),
        ],
      ),
      body: /*_buildSuggestions()*/
        ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            final index = i ~/ 2;
            if (index >= _courses.length) return null;
            if (i.isOdd) return Divider();
            return _buildRow(_courses[index]);
          }),
    );
  }

  Widget _buildRow(String courseName) {
    return ListTile(
      title: Text(
        courseName,
        style: _biggerFont,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        _showCourseInfo();
      },
    );
  }

  void _showCourseInfo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Course Information'),
            ),
            body: Text('courseName'),
          );
        }, //...to here.
      ),
    );
  }
}