class Restaurant {
  final String restaurantId;
  final String name;
  final String imageUrl;
  final String address;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.imageUrl,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final rawName = json['restaurant_name'];

    return Restaurant(
      restaurantId: json['restaurant_id'].toString(),
      name: (rawName == null || rawName.toString().trim().isEmpty)
          ? 'Restaurant'
          : rawName,
      imageUrl: json['restaurant_image'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
