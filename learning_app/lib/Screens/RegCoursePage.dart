import 'package:flutter/material.dart';
import 'CourseDetailsPage.dart';

class RegCoursePage extends StatefulWidget {
  final List<String> regCourses;
  RegCoursePage(this.regCourses);

  @override
  State<RegCoursePage> createState() => _RegCoursePageState(regCourses);
}

class _RegCoursePageState extends State<RegCoursePage> {
  final List<String> regCourses;
  _RegCoursePageState(this.regCourses);
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Registered courses'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i ~/ 2;
          if (index >= regCourses.length) return null;
          if (i.isOdd) return Divider();
          return _buildRow(index);
        }
      ),
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CourseDetailsPage(regCourses[index]),
        ),);
      },
    );
  }
}