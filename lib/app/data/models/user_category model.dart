class UserCategoryModel {
  final int id;
  final String name;
  final String image;

  UserCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory UserCategoryModel.fromJson(Map<String, dynamic> json) {
    return UserCategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
