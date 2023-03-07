// import 'dart:convert';

// List<UserModel> welcomeFromJson(String str) =>
//     List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

// class UserModel {
//   String status;
//   String user_token;
//   String data;
//   UserModel({
//     this.status,
//     this.user_token,
//     this.data,
//   });

//   //FORMAT TO JSON
//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//     status: json["status"],
//     user_token: json["user_token"],
//     data: json["data"],
//   );

// //PARSE JSON
// }