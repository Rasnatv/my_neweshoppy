class RestaurantMenuItem {
  final String id;
  final String image;
  final String foodName;
  final String shortDescription;
  final String price;

  RestaurantMenuItem({
    required this.id,
    required this.image,
    required this.foodName,
    required this.shortDescription,
    required this.price,
  });

  factory RestaurantMenuItem.fromJson(Map<String, dynamic> json) {
    return RestaurantMenuItem(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      foodName: json['food_name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      price: json['price'] ?? '0.00',
    );
  }
}