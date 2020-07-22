import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// url of database server
final serverDomain = 'purdueuniversity.apps.dreamfactory.com';
/// api key mapping string in http request header
final apiKeyMatchString = 'X-DreamFactory-API-Key';
/// session token mapping string in http request header
final jwTokenMatchString = 'X-DreamFactory-Session-Token';

/// api key for app authorization
String apiKey;
/// session token for user authentication
String jwToken;

/// boolean for whether storage is initialized
bool _isInit = false;
/// flutter secure storage
FlutterSecureStorage _storage;

/// Initialize secure storage for app API key.
/// 
/// Store the api key for sql database and set _isInit to true.
void restInit() {
  if(_isInit) return;
  _storage = FlutterSecureStorage();
  _storage.write(
    key: 'api_key',
    value: '7c914e1385bf8f211ae5e05d2674e92a2c58658f30949cc0ead1f188dcdba191',
  );
  _isInit = true;
}

/// Attempt login via http post request.
/// 
/// Attempt login as user and admin. Upon successful login, retrieve and store session token.
/// Return null upon a failed login attempt.
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

  if(response.statusCode >= 200 && response.statusCode < 300) {
    jwToken = json.decode(response.body)['session_token'];
    var map = await restQuery('accounts', '*', '(email=$email)and(password=$password)');
    return map[0];
  }

  return null;
}

/// Attempt logout for current session token.
/// 
/// Attempt logout. Upon successful login, return true.
/// Return null upon a failed logout attempt.
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

/// Perform an insertion request.
/// 
/// Perform insertion to server via http POST request.
/// Name of table and map of object to insert should be provided.
/// Return true if insertion successful, otherwise false;
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

/// Perform an update request.
/// 
/// Perform update to server via http PUT request.
/// Name of table, row filter and map of updated object should be provided.
/// /// Return true if update successful, otherwise false;
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

/// Perform a query request.
/// 
/// Perform query to server via http GET request.
/// Name of table, fields to return and row filter should be provided.
/// Return list of maps if query successful, otherwise return empty list.
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

/// Perform a query request for the schema.
/// 
/// Perform query for schema to server via http GET request.
/// Schema info include table name, number of entries, etc.
/// Schema fields to return should be provided.
/// Return list of maps, otherwise return empty list.
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

/// Download package from link.
/// 
/// Given list of table names to export data, export and download table data as
/// zip file to provided path. Downloaded file is named 'learningApp_export.zip'
Future<bool> restExportData(List<String> tableNames, String path) async {
  var bodyJson = {
    "service" : {
      "db":{	    
        "_table": tableNames
      }
    }
  };
  
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

  if(insertResp.statusCode < 200 || insertResp.statusCode > 299) return false;

  var link = json.decode(insertResp.body)['path'];
  await HttpClient().getUrl(Uri.parse(link))
  .then((HttpClientRequest request) { 
    request.headers.add(apiKeyMatchString, apiKey);
    request.headers.add(jwTokenMatchString, jwToken);
    return request.close();
  })
  .then((HttpClientResponse response) => 
  response.pipe(File(path + '/learningApp_export.zip').openWrite()));

  return true;
}