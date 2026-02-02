class RestaurantAboutModel {
  final String restaurantName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String whatsapp;
  final String facebook;
  final String instagram;

  RestaurantAboutModel({
    required this.restaurantName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
  });

  factory RestaurantAboutModel.fromJson(Map<String, dynamic> json) {
    return RestaurantAboutModel(
      restaurantName: json['restaurant_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      facebook: json['facebook_link'] ?? '',
      instagram: json['instagram_link'] ?? '',
    );
  }
}
