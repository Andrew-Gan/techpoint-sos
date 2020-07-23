import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

/// stateful class for instantiating TeacherAssignCreatePage screen
class TeacherAssignCreatePage extends StatefulWidget {
  final int instrID;
  final String courseID;
  TeacherAssignCreatePage(this.courseID, this.instrID);

  @override
  State<TeacherAssignCreatePage> createState() =>
    _TeacherAssignCreatePageState(courseID, instrID);
}

/// state class for TeacherAssignCreatePage screen
class _TeacherAssignCreatePageState extends State<TeacherAssignCreatePage> {
  final String courseID;
  final int instrID;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime dueDate = DateTime.now();

  _TeacherAssignCreatePageState(this.courseID, this.instrID);

  bool isCreated = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add assignment'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
                  child: Text(
                    'Assignment title',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0, right: 25.0),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    enabled: true,
                    maxLines: 2,
                  ),
                ),  
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Text(
                    'Assignment question',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 15.0, right: 25.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 7,
                    controller: contentController,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Text(
                    'Assignment due date',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.0,),
                      child: DropdownButton(
                        value: dueDate.month,
                        items: List<int>.generate(12, (i) => i + 1)
                          .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          )).toList(),
                        onChanged: (int newValue) => setState(() =>
                          dueDate = DateTime(
                            dueDate.year,
                            newValue,
                            dueDate.day,
                            dueDate.hour,
                            dueDate.minute,
                          )
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0,),
                      child: DropdownButton(
                        value: dueDate.day,
                        items: List<int>.generate(31, (i) => i + 1)
                          .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          )).toList(),
                        onChanged: (int newValue) => setState(() =>
                          dueDate = DateTime(
                            dueDate.year,
                            dueDate.month,
                            newValue,
                            dueDate.hour,
                            dueDate.minute,
                          )
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0,),
                      child: DropdownButton(
                        value: dueDate.year,
                        items: List<int>.generate(1000, (i) => i + 2000)
                          .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          )).toList(),
                        onChanged: (int newValue) => setState(() =>
                          dueDate = DateTime(
                            newValue,
                            dueDate.month,
                            dueDate.day,
                            dueDate.hour,
                            dueDate.minute,
                          )
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0,),
                      child: DropdownButton(
                        value: dueDate.hour,
                        items: List<int>.generate(24, (i) => i)
                          .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          )).toList(),
                        onChanged: (int newValue) => setState(() =>
                          dueDate = DateTime(
                            dueDate.year,
                            dueDate.month,
                            dueDate.day,
                            newValue,
                            dueDate.minute,
                          )
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0,),
                      child: DropdownButton(
                        value: dueDate.minute,
                        items: List<int>.generate(60, (i) => i)
                          .map<DropdownMenuItem<int>>((i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          )).toList(),
                        onChanged: (int newValue) => setState(() =>
                          dueDate = DateTime(
                            dueDate.year,
                            dueDate.month,
                            dueDate.day,
                            dueDate.hour,
                            newValue,
                          )
                        ),
                      )
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Visibility(
                    child: Text(
                      'Assignment update successful',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ),
                    ),
                    replacement: Text(
                      '',
                      style: TextStyle(fontSize: 16.0,),
                    ),
                    visible: isCreated,
                  ),
                ),
                Center(
                  heightFactor: 2.0,
                  child: OutlineButton(
                    onPressed: onCreatePress,
                    child: Text('CREATE'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onCreatePress() async {
    if(titleController.text == '' || contentController.text == '') return;
    
    var map = AssignmentQuestionInfo(
      assignTitle: titleController.text,
      courseID: courseID,
      content: contentController.text,
      dueDate: dueDate.millisecondsSinceEpoch,
      instrID: instrID,
      maxScore: 100,
    ).toMap();
    bool created = await restInsert(AssignmentQuestionInfo.tableName, map);

    setState(() => isCreated = created);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}