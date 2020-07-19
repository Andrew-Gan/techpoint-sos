import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learningApp/CreateDB.dart';

// constant strings used for http requests
final serverDomain = 'purdueuniversity.apps.dreamfactory.com';
final httpAPIKeyMatchString = 'X-DreamFactory-API-Key';
final httpJWTokenMatchString = 'X-DreamFactory-Session-Token';

// api key and session token obtained from login
String apiKey;
String jwToken;

// global var to be used here only
bool _isInit = false;
FlutterSecureStorage _storage;

// initialize secure storage for app API key
void restInit() {
  if(_isInit) return;
  _storage = FlutterSecureStorage();
  _storage.write(
    key: 'api_key',
    value: '7c914e1385bf8f211ae5e05d2674e92a2c58658f30949cc0ead1f188dcdba191',
  );
  _isInit = true;
}


// request session token using provided credentials. Return null if invalid
Future<AccountInfo> restLogin(String email, String password) async {
  if(!_isInit) restInit();
  apiKey = await _storage.read(key: 'api_key');

  var response = await http.post(
    Uri.https(serverDomain, '/api/v2/user/session'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      httpAPIKeyMatchString: apiKey,
    },
    body: {
    'email' : email,
    'password' : password,
    }
  );

  if(response.statusCode >= 300 && response.statusCode < 400) {
    String newUrl = json.decode(response.body)['new location'];
    var newResp = await http.post(
      Uri.https(newUrl, '/api/v2/user/session'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        httpAPIKeyMatchString: apiKey,
      },
      body: {
        'email' : email,
        'password' : password,
      }
    );
    response = newResp;
  }

  if(response.statusCode >= 200 && response.statusCode < 300) {
    jwToken = json.decode(response.body)['session_token'];
    var map = await restQuery(AccountInfo.tableName, '*', 'email=$email&password=$password');
    return AccountInfo.fromMap(map);
  }
  
  return null;
}

// terminate user token session
Future<bool> restLogout() async {
  var response = await http.delete(
    Uri.https(serverDomain, '/api/v2/user/session'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      httpAPIKeyMatchString : apiKey,
      httpJWTokenMatchString : jwToken,
    },
  );

 if(response.statusCode >= 200 && response.statusCode < 300) return true;
 return false;
}

// performs sql.insert via http POST request. Return false if insertion failed
Future<bool> restInsert(String tableName, Map<String, dynamic> map) async {
  var response = await http.post(
    Uri.https('purdueuniversity.apps.dreamfactory.com', '/api/v2/db/_table/$tableName'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      httpAPIKeyMatchString: apiKey,
      httpJWTokenMatchString: jwToken
    },
    body: json.encode({"resource":map}),
  );

  if(response.statusCode >= 200 && response.statusCode < 300) return true;
  return false;
}

// performs sql.update via http PUT request. Return false if update failed
Future<bool> restUpdate(String tableName, String filter, Map<String, dynamic> map) async {
  var response = await http.put(
    Uri.https('purdueuniversity.apps.dreamfactory.com', '/api/v2/db/_table/$tableName?filter=$filter'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-DreamFactory-API-Key': apiKey,
      'X-DreamFactory-Session-Token': jwToken,
    },
    body: json.encode({"resource":map}),
  );

  if(response.statusCode >= 200 && response.statusCode < 300) return true;
  return false;
}

// performs sql.query via http GET request. Return null if query failed
Future<Map<String, dynamic>> restQuery(String tableName, String fields, String filter) async {
  var queryResp = await http.get(
    Uri.encodeFull('https://' + serverDomain + '/api/v2/db/_table'
                   '/$tableName?fields=$fields&filter=$filter'),
    headers: {
      httpAPIKeyMatchString : apiKey,
      httpJWTokenMatchString : jwToken,
    }
  );

  if(queryResp.statusCode < 200 || queryResp.statusCode > 299) return null;
  return json.decode(queryResp.body);
}