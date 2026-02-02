class RestaurantRegisterRequest {
  final String ownerName;
  final String restaurantName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String restaurantImage; // Base64 main image
  final List<String> additionalImages; // Base64 additional images

  RestaurantRegisterRequest({
    required this.ownerName,
    required this.restaurantName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.restaurantImage,
    required this.additionalImages,
  });

  Map<String, dynamic> toJson() => {
    "owner_name": ownerName,
    "restaurant_name": restaurantName,
    "address": address,
    "phone": phone,
    "email": email,
    "website": website,
    "whatsapp": whatsapp,
    "facebook_link": facebook,
    "instagram_link": instagram,
    "restaurant_image": restaurantImage,
    "additional_images": additionalImages,
  };
}
