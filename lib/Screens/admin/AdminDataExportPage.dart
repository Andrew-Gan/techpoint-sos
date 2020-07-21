import 'package:flutter/material.dart';
import '../../CreateDB.dart';
import '../../REST_API.dart';

import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:ext_storage/ext_storage.dart';

class AdminDataExportPage extends StatefulWidget {
  final AccountInfo userInfo;
  final List<String> tableNames;

  AdminDataExportPage(this.tableNames, this.userInfo);

  @override
  State<AdminDataExportPage> createState() => 
    _AdminDataExportPageState(this.tableNames, userInfo);
}

class _AdminDataExportPageState extends State<AdminDataExportPage> {
  final AccountInfo userInfo;
  final List<String> tableNames;
  List<String> tablesToQuery = List<String>();
  String errMsg = '';

  _AdminDataExportPageState(this.tableNames, this.userInfo);

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Export data'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 400,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, i) {
                      final index = i ~/ 2;
                      if (index >= tableNames.length) return null;
                      if (i.isOdd) return Divider();
                      return _buildTableRow(index);
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: Text(
                    errMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: OutlineButton(
                    child: Text('EXPORT DATA'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () => exportData(userInfo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(int index) {
    return ListTile(
      title: Text(tableNames[index],),
      trailing: tablesToQuery.contains(tableNames[index]) ? 
        Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
      onTap: () => setState(() {
        tablesToQuery.contains(tableNames[index]) ? 
          tablesToQuery.remove(tableNames[index]) :
          tablesToQuery.add(tableNames[index]);
      })
    );
  }

  void exportData(AccountInfo userInfo) async {
    // check if user has accounnt privilege
    if(userInfo.privilege > AccountPrivilege.admin.index) {
      setState(() => errMsg = 'You do not have the required privilege to export data');
      return;
    }

    // check if user selected any tables to export
    if(tablesToQuery.length == 0) {
      setState(() => errMsg = 'Please select at least one table');
      return;
    }

    // check if app has permission to write to external storage
    var permission = await PermissionsPlugin.checkPermissions(
      [Permission.WRITE_EXTERNAL_STORAGE]
    );
    // request permissiont to write to external storage if no permission
    if(permission[Permission.WRITE_EXTERNAL_STORAGE] != PermissionState.GRANTED) {
      permission = await PermissionsPlugin.requestPermissions(
        [Permission.WRITE_EXTERNAL_STORAGE]
      );
      // return if usre decides not to grant permission
      if(permission[Permission.WRITE_EXTERNAL_STORAGE] != PermissionState.GRANTED) {
        setState(() => errMsg = 'Please grant app permission to write to external storage');
        return;
      }
    }

    String path = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS
    );
    

    if(await restExportData(tablesToQuery, path))
      setState(() => errMsg = 'Data exported to ' + path);
    else
      setState(() => errMsg = 'Data export failed. Please try again');
  } 

  @override
  void dispose() => super.dispose();
}