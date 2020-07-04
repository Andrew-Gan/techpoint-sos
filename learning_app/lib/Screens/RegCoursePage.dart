import 'package:flutter/material.dart';

class RegCoursePage extends StatefulWidget {
  @override
  State<RegCoursePage> createState() => _RegCoursePageState();
}

class _RegCoursePageState extends State<RegCoursePage> {
  // replace with db retrieval
  final _courses = ['ECE 101', 'ECE 201', 'ECE 202', 'ECE 301', 'ENGR 132', 'ENGL 106'];
  // final _registered = <String>{};
  var _displayinfo;
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
            return _buildRow(index);
          }),
    );
  }

  Widget _buildRow(int index) {
    return ListTile(
      title: Text(
        _courses[index],
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
            body: Text(_courses[_displayinfo]),
          );
        }, //...to here.
      ),
    );
  }
}