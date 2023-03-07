// import 'package:best_flutter_ui_templates/model/model_user.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// class ApiUser extends ChangeNotifier {
//   List<UserModel> _data = [];
//   List<UserModel> get dataUser => _data;

//   String username = "";
//   String uid = "";
//   ApiUser() {
//     notifyListeners();
//     setup();
//   }

//   void setup() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String url = (await prefs.getString('username') ?? 'unknown');
//     String url2 = (await prefs.getString('uid') ?? 'unknown');
//     username = url;
//     uid = url2;
//     notifyListeners();
//   }
  //
  // //Notifikasi pengguna
  // Future<List<UserModel>> getNotif() async {
  //   final url = 'https://discoverkorea.site/apinotifikasi';
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     final result =
  //     json.decode(response.body)['values'].cast<Map<String, dynamic>>();
  //     _data =
  //         result.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  //     return _data;
  //   } else {
  //     throw Exception();
  //   }
  // }
  // //mendapatkan info following
  // Future<List<UserModel>> getProfileFollowing() async {
  //   final url = 'https://discoverkorea.site/apiuser/following/$uid';
  //   final response = await http.get(url);
  //   if (response.body.isNotEmpty) {
  //     if (response.statusCode == 200) {
  //       print('uid following $uid');
  //       final result =
  //       json.decode(response.body)['values'].cast<Map<String, dynamic>>();
  //       _data = result
  //           .map<UserModel>((json) => UserModel.fromJson(json))
  //           .toList();
  //       return _data;
  //     } else {}
  //   } else {
  //     print('Terjadi disini kesalahannya');
  //   }
  // }
  //
  // // FOLLOW USER
  // Future<bool> followUser(String mengikuti, String pengikut) async {
  //   final url = 'https://discoverkorea.site/apiuser/followuser';
  //   final response = await http.post(url, body: {
  //     'mengikuti': mengikuti,
  //     'pengikut': pengikut,
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200 && result['message'] == 'Success!') {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  // // unFOLLOW USER
  // Future<bool> unfollowUser(String mengikuti, String pengikut) async {
  //   final url = 'https://discoverkorea.site/apiuser/unfollowuser';
  //   final response = await http.post(url, body: {
  //     'mengikuti': mengikuti,//kita
  //     'pengikut': pengikut,
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200 && result['message'] == 'Success!') {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  // //Memberi pesan kepada orang
  // Future<bool> messageUser(String user1, String user2) async {
  //   final url = 'https://discoverkorea.site/apiuser/pesan';
  //   final response = await http.post(url, body: {
  //     'user1': user1,
  //     'user2': user2,
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200 && result['message'] == 'Success!') {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  // Future<UserModel> findUser(String uid) async {
  //   return _data.firstWhere((i) => i.uid == uid);
  // }
  // //edit password
  // Future<bool> editPassword(uid, oldpassword, password, confirmation) async {
  //   final url = 'https://discoverkorea.site/apiuser/updatepassword/' + uid;
  //   final response = await http.post(url, body: {
  //     'uid': uid,
  //     'oldpassword': oldpassword,
  //     'password': password,
  //     'confirmation': confirmation
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200 && result['message'] == 'success') {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  // //edit biodata
  // Future<bool> editbio(uid, bio) async {
  //   final url = 'https://discoverkorea.site/apiuser/updatebio/' + uid;
  //   final response = await http.post(url, body: {
  //     'id': uid,
  //     'biodata': bio,
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200) {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  // //edit profile
  // Future<bool> editprofile(uid, username, email, nohp, nama, kota) async {
  //   final url = 'https://discoverkorea.site/apiuser/updatedetailakun/' + uid;
  //   final response = await http.post(url, body: {
  //     'id': uid,
  //     'username': username,
  //     'email': email,
  //     'nohp': nohp,
  //     'nama': nama,
  //     'alamat': kota,
  //   });
  //
  //   final result = json.decode(response.body);
  //   if (response.statusCode == 200 && result['message'] == 'success') {
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
  //
  // Future<void> deleteEmployee(String id) async {
  //   final url = 'http://employee-crud-flutter.daengweb.id/delete.php';
  //   await http.get(url + '?id=$id');
  // }
// }