import 'dart:async';
import 'dart:ffi';

import 'package:best_flutter_ui_templates/design_storage/models/category.dart';
import 'package:best_flutter_ui_templates/design_storage/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUser extends ChangeNotifier {
  List<UserModel> _data = [];
  List<UserModel> get dataFolders => _data;

  late SharedPreferences sharedPreferences;
  String email = "unknown";
  String user_id = "";

  ApiUser() {
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

  Future<List<UserModel>> getUserAccessByFile(String folder_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? 'unknown';
    final url =
        'https://192.168.1.66/leap_integra/leap_integra/master/dms/api/files/getuseraccessbyfile';
    final response = await http
        .get(url + '?user_token=' + user_token + '&folder_id=' + folder_id);

    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      _data =
          result.map<UserModel>((json) => UserModel.fromJson(json)).toList();

      return _data;
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
