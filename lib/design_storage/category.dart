import 'dart:convert';

List<CategoryModel> welcomeFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  String folder_id;
  String folder_parent_id;
  String name;
  String nomor;
  String perihal;
  String format;
  String size;
  String description;
  String created_by;
  String created_on;
  String updated_on;
  String updated_by;
  String user_access;

  CategoryModel(
      {required this.folder_id,
      required this.folder_parent_id,
      required this.name,
      required this.nomor,
      required this.perihal,
      required this.format,
      required this.size,
      required this.description,
      required this.created_by,
      required this.created_on,
      required this.updated_on,
      required this.updated_by,
      required this.user_access});
  //FORMAT TO JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      folder_id: json["folder_id"],
      folder_parent_id: json["folder_parent_id"],
      name: json["name"],
      nomor: json["nomor"],
      perihal: json["perihal"],
      format: json["format"],
      size: json["size"],
      description: json["description"],
      created_by: json["created_by"],
      created_on: json["created_on"],
      updated_on: json["updated_on"],
      updated_by: json["updated_by"],
      user_access: json["user_access"]);

  // static List<Category> categoryList = <Category>[
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'User interface Design',
  //     fileCount: 24,
  //     money: 25,
  //     rating: 4.3,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'User interface Design',
  //     fileCount: 22,
  //     money: 18,
  //     rating: 4.6,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'User interface Design',
  //     fileCount: 24,
  //     money: 25,
  //     rating: 4.3,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'User interface Design',
  //     fileCount: 22,
  //     money: 18,
  //     rating: 4.6,
  //   ),
  // ];

  // static List<Category> popularCourseList = <Category>[
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'Folder Main',
  //     fileCount: 12,
  //     money: 25,
  //     rating: 4.8,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'Folder 1',
  //     fileCount: 28,
  //     money: 208,
  //     rating: 4.9,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'Folder 2',
  //     fileCount: 12,
  //     money: 25,
  //     rating: 4.8,
  //   ),
  //   Category(
  //     imagePath: 'assets/design_storage/folders.png',
  //     title: 'Folder 3',
  //     fileCount: 28,
  //     money: 208,
  //     rating: 4.9,
  //   ),
  // ];
}
