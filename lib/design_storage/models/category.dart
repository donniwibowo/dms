class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.fileCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int fileCount;
  int money;
  double rating;
  String imagePath;

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'User interface Design',
      fileCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'User interface Design',
      fileCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'User interface Design',
      fileCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'User interface Design',
      fileCount: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'Folder Main',
      fileCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'Folder 1',
      fileCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'Folder 2',
      fileCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/design_storage/folders.png',
      title: 'Folder 3',
      fileCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}
