import 'dart:convert';

List<UserModel> welcomeFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  String folder_id;
  String user_id;
  String fullname;
  String email;
  String role;

  UserModel(
      {required this.folder_id,
      required this.user_id,
      required this.fullname,
      required this.email,
      required this.role});
  //FORMAT TO JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      folder_id: json["folder_id"],
      user_id: json["user_id"],
      fullname: json["fullname"],
      email: json["email"],
      role: json["role"]);
}
