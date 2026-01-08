class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String address;


  Restaurant({

    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      address: json['address'],

    );
  }
}
