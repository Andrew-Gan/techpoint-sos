import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// constant strings used for http requests
final serverDomain = 'purdueuniversity.apps.dreamfactory.com';
final apiKeyMatchString = 'X-DreamFactory-API-Key';
final jwTokenMatchString = 'X-DreamFactory-Session-Token';

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
Future<Map<String, dynamic>> restLogin(String email, String password) async {
  if(!_isInit) restInit();
  apiKey = await _storage.read(key: 'api_key');

  var response = await http.post(
    Uri.https(serverDomain, '/api/v2/user/session'),
    headers: {
      'Accept': 'application/json',
      apiKeyMatchString: apiKey,
    },
    body: {
      'email' : email,
      'password' : password,
    }
  );

  // server ip redirect
  if(response.statusCode >= 300 && response.statusCode < 400) {
    String newUrl = json.decode(response.body)['new location'];
    var newResp = await http.post(
      Uri.https(newUrl, '/api/v2/user/session'),
      headers: {
        'Accept': 'application/json',
        apiKeyMatchString: apiKey,
      },
      body: {
        'email' : email,
        'password' : password,
      }
    );
    response = newResp;
  }

  if(response.statusCode < 200 || response.statusCode >= 300) {
    print('trying admin');
    // try logging in as admin
    var adminResp = await http.post(
      Uri.https(serverDomain, '/api/v2/system/admin/session'),
      headers: {
        'Accept': 'application/json',
        apiKeyMatchString: apiKey,
      },
      body: {
        'email' : email,
        'password' : password,
      }
    );
    response = adminResp;
  }

  // user logged in as admin or non-admin successfully
  if(response.statusCode >= 200 && response.statusCode < 300) {
    jwToken = json.decode(response.body)['session_token'];
    var map = await restQuery('accounts', '*', 'email=$email&password=$password');
    return map[0];
  }

  return null;
}

// terminate user token session
Future<bool> restLogout() async {
  if(!_isInit) restInit();
  var response = await http.delete(
    Uri.https(serverDomain, '/api/v2/user/session'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      apiKeyMatchString : apiKey,
      jwTokenMatchString : jwToken,
    },
  );

 if(response.statusCode >= 200 && response.statusCode < 300) return true;
 return false;
}

// performs sql.insert via http POST request. Return false if insertion failed
Future<bool> restInsert(String tableName, Map<String, dynamic> map) async {
  if(!_isInit) restInit();
  var response = await http.post(
    Uri.https(serverDomain, '/api/v2/db/_table/$tableName'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      apiKeyMatchString: apiKey,
      jwTokenMatchString: jwToken
    },
    body: json.encode({"resource":map}),
  );

  if(response.statusCode >= 200 && response.statusCode < 300) return true;
  return false;
}

// performs sql.update via http PUT request. Return false if update failed
Future<bool> restUpdate(String tableName, String filter, Map<String, dynamic> map) async {
  if(!_isInit) restInit();
  var response = await http.put(
    Uri.encodeFull('https://' + serverDomain +
      '/api/v2/db/_table/$tableName?filter=$filter'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      apiKeyMatchString: apiKey,
      jwTokenMatchString: jwToken,
    },
    body: json.encode({"resource":map}),
  );

  if(response.statusCode >= 200 && response.statusCode < 300) return true;
  return false;
}

// performs sql.query via http GET request. Return null if query failed
Future<List<dynamic>> restQuery(String tableName, String fields, String filter) async {
  if(!_isInit) restInit();
  var response = await http.get(
    Uri.encodeFull('https://' + serverDomain + '/api/v2/db/_table'
                   '/$tableName?fields=$fields&filter=$filter'),
    headers: {
      apiKeyMatchString : apiKey,
      jwTokenMatchString : jwToken,
    }
  );
  
  if(response.statusCode < 200 || response.statusCode > 299) return List<dynamic>();
  return json.decode(response.body)['resource'];
}

Future<List<dynamic>> restQuerySchema(String fields) async {
  var response = await http.get(
    Uri.encodeFull('https://purdueuniversity.apps.dreamfactory.com/api/v2/db/_schema?fields=$fields'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      apiKeyMatchString: apiKey,
      jwTokenMatchString: jwToken,
    },
  );

  if(response.statusCode < 200 || response.statusCode > 299) return List<dynamic>();
  return json.decode(response.body)['resource'];
}

Future<bool> restExportData(List<String> tableNames, String path) async {
  var bodyJson = {
    "service" : {
      "db":{	    
        "_table": tableNames
      }
    }
  };
  
  // HTTP POST request to obtain table data
  var insertResp = await http.post(
    Uri.encodeFull('https://purdueuniversity.apps.dreamfactory.com/api/v2/system/package'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      apiKeyMatchString: apiKey,
      jwTokenMatchString: jwToken,
    },
    body: json.encode(bodyJson),
  );

  // return false if http request unsuccessful
  if(insertResp.statusCode < 200 || insertResp.statusCode > 299) return false;

  // download byte file and pipe to local storage
  var link = json.decode(insertResp.body)['path'];
  await HttpClient().getUrl(Uri.parse(link))
  .then((HttpClientRequest request) => request.close())
  .then((HttpClientResponse response) => 
  response.pipe(File(path + '/learningApp_export.zip').openWrite()));

  return true;
}