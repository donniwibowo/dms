import 'dart:ffi';

import 'package:best_flutter_ui_templates/design_storage/models/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiFolders extends ChangeNotifier {
  List<CategoryModel> _data = [];
  List<CategoryModel> get dataFolders => _data;
  List<CategoryModel> _dataDetail = [];
  List<CategoryModel> get dataDetail => _dataDetail;
  List<CategoryModel> _dataRecent = [];
  List<CategoryModel> get dataRecentFolders => _dataRecent;
  List<CategoryModel> _dataSearch = [];
  List<CategoryModel> get dataSearchFolders => _dataSearch;
  late SharedPreferences sharedPreferences;
  String email = "unknown";
  String user_id = "";

  ApiFolders() {
    notifyListeners();
    setup();
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = (await prefs.getString('email') ?? 'unknown');
    String url2 = await prefs.getString('user_id') ?? 'unknown';
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    email = url;
    user_id = url2;
    notifyListeners();
  }

  Future<List<CategoryModel>?> getAllFolder(String folder_parent_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        // 'https://192.168.1.119/leap_integra/master/dms/api/files/getfiles';
        'https://192.168.1.119/leap_integra/master/dms/api/files/getfiles';
    final response = await http.get(url +
        '?user_token=' +
        user_token +
        '&folder_parent_id=' +
        folder_parent_id);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        // print(result);

        _data = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _data;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<CategoryModel>?> getDetailFolder(String folder_parent_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        // 'https://192.168.1.119/leap_integra/master/dms/api/files/getfiles';
        'https://192.168.1.119/leap_integra/master/dms/api/files/getfiles';
    final response = await http.get(url +
        '?user_token=' +
        user_token +
        '&folder_parent_id=' +
        folder_parent_id);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        print(result);

        _dataDetail = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _dataDetail;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<CategoryModel>?> getSearchFolder(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        // 'https://192.168.1.119/leap_integra/master/dms/api/files/getfiles';
        'https://192.168.1.119/leap_integra/master/dms/api/files/search';
    final response = await http
        .get(url + '?user_token=' + user_token + '&keyword=' + keyword);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        print(result);

        _dataSearch = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _dataSearch;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<CategoryModel>?> getRecentFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        // 'https://192.168.1.119/leap_integra/master/dms/api/files/getrecentfiles';
        'https://192.168.1.119/leap_integra/master/dms/api/files/getrecentfiles';
    final response = await http.get(url + '?user_token=' + user_token + '');
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        print(result);

        _dataRecent = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _data;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<CategoryModel>?> getSharedFolder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        // 'https://192.168.1.119/leap_integra/master/dms/api/files/getsharedfolder';
        'https://192.168.1.119/leap_integra/master/dms/api/files/getsharedfolder';
    final response = await http.get(url + '?user_token=' + user_token + '');
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        print(result);

        _data = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _data;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
// //ADD DATA
// Future<bool> storeEmployee(String name, String salary, String age) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/add.php';
//   final response = await http.post(url, body: {
//     'employee_name': name,
//     'employee_salary': salary,
//     'employee_age': age
//   });

//   final result = json.decode(response.body);
//   if (response.statusCode == 200 && result['message'] == 'success') {
//     notifyListeners();
//     return true;
//   }
//   return false;
// }

// Future<EmployeeModel> findEmployee(String id) async {
//   return _data.firstWhere((i) => i.id == id);
// }

// Future<bool> updateEmployee(id, name, salary, age) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/update.php';
//   final response = await http.post(url, body: {
//     'id': id,
//     'employee_name': name,
//     'employee_salary': salary,
//     'employee_age': age
//   });

//   final result = json.decode(response.body);
//   if (response.statusCode == 200 && result['message'] == 'success') {
//     notifyListeners();
//     return true;
//   }
//   return false;
// }

// Future<void> deleteEmployee(String id) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/delete.php';
//   await http.get(url + '?id=$id');
// }
}
