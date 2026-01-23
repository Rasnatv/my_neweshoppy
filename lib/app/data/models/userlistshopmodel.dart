class ShopModel {
  final int id;
  final String name;
  final String image;
  final String location;

  ShopModel({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['shop_name'] ?? '',
      image: json['shop_image'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
