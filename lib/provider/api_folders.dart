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
  List<CategoryModel> _dataActivities = [];
  List<CategoryModel> get dataRecentActivities => _dataActivities;
  List<CategoryModel> _dataSharedFolder = [];
  List<CategoryModel> get dataSharedFolder => _dataSharedFolder;
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

  Future<List<CategoryModel>> getAllFolder(
      String folder_parent_id, String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';

    final url =
        'https://192.168.1.28/leap_integra/master/dms/api/files/getfiles';
    final response = await http.get(url +
        '?user_token=' +
        user_token +
        '&folder_parent_id=' +
        folder_parent_id +
        '&keyword=' +
        keyword);

    if (response.statusCode == 200) {
      print('masuk 200');
      final result =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      _data = result
          .map<CategoryModel>((json) => CategoryModel.fromJson(json))
          .toList();
      return _data;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<List<CategoryModel>?> getDetailFolder(String folder_parent_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        'https://192.168.1.28/leap_integra/master/dms/api/files/getfiles';
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
    final url = 'https://192.168.1.28/leap_integra/master/dms/api/files/search';
    final response = await http
        .get(url + '?user_token=' + user_token + '&keyword=' + keyword);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
        // print(result);

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
        'https://192.168.1.28/leap_integra/master/dms/api/files/getrecentfiles';
    final response = await http.get(url + '?user_token=' + user_token + '');
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk sini');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        _dataRecent = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _dataRecent;
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
        'https://192.168.1.28/leap_integra/master/dms/api/files/getsharedfolder';
    final response = await http.get(url + '?user_token=' + user_token + '');
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        _dataSharedFolder = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _dataSharedFolder;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<CategoryModel>?> getRecentActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        'https://192.168.1.28/leap_integra/master/dms/api/files/getrecentactivities';
    final response = await http.get(url + '?user_token=' + user_token + '');
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('masuk 200');
        final result =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        _dataActivities = result
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
        return _dataActivities;
      } else {
        print('masuk selain 200');
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
}
