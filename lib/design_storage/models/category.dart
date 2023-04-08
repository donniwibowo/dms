import 'dart:convert';

List<CategoryModel> welcomeFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  String folder_id;
  String folder_parent_id;
  String name;
  String nomor;
  String perihal;
  String type;
  String format;
  String size;
  String description;
  String created_by;
  String created_on;
  String updated_on;
  String updated_by;
  String user_access;
  String is_owner;
  String file_url;
  String no_revision;
  String email;

  CategoryModel(
      {required this.folder_id,
      required this.folder_parent_id,
      required this.name,
      required this.nomor,
      required this.perihal,
      required this.type,
      required this.format,
      required this.size,
      required this.description,
      required this.created_by,
      required this.created_on,
      required this.updated_on,
      required this.updated_by,
      required this.user_access,
      required this.is_owner,
      required this.file_url,
      required this.no_revision,
      required this.email});
  //FORMAT TO JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      folder_id: json["folder_id"],
      folder_parent_id: json["folder_parent_id"],
      name: json["name"],
      nomor: json["nomor"],
      perihal: json["perihal"],
      type: json["type"],
      format: json["format"],
      size: json["size"],
      description: json["description"],
      created_by: json["created_by"],
      created_on: json["created_on"],
      updated_on: json["updated_on"],
      updated_by: json["updated_by"],
      user_access: json["user_access"],
      is_owner: json["is_owner"],
      file_url: json["file_url"],
      no_revision: json["no_revision"],
      email: json["email"]);
}
