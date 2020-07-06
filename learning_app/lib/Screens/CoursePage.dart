import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  final List<String> regCourses;
  CoursePage(this.regCourses);

  @override
  State<CoursePage> createState() => _CoursePageState(regCourses);
}

class _CoursePageState extends State<CoursePage> {
  final List<String> regCourses;
  var _displayinfo;
  final _biggerFont = TextStyle(fontSize: 18.0);

  _CoursePageState(this.regCourses);

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
            if (index >= regCourses.length) return null;
            if (i.isOdd) return Divider();
            return _buildRow(index);
          }),
    );
  }

  Widget _buildRow(int index) {
    return ListTile(
      title: Text(
        regCourses[index],
        style: _biggerFont,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        _displayinfo = index;
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
            body: Text(regCourses[_displayinfo]),
          );
        }, //...to here.
      ),
    );
  }
}

class CourseInfo {
  final String id;
  final String title;
  final String description;
  final int credit;
  final String prereq;  // every course separated with a ','

  CourseInfo({this.id, this.title, this.description, this.credit, this.prereq});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'credit': credit,
      'prereq': prereq,
    };
  }
}