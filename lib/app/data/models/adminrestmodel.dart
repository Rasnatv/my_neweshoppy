// class NewRestaurantModel {
//   final String id;
//   final String restaurantName;
//   final String restaurantImage;
//   final String ownerName;
//   final String address;
//   final String phone;
//   final String email;
//   final String website;
//   final String whatsapp;
//   final String facebookLink;
//   final String instagramLink;
//   final List<String> additionalImages;
//
//   NewRestaurantModel({
//     required this.id,
//     required this.restaurantName,
//     required this.restaurantImage,
//     required this.ownerName,
//     required this.address,
//     required this.phone,
//     required this.email,
//     required this.website,
//     required this.whatsapp,
//     required this.facebookLink,
//     required this.instagramLink,
//     required this.additionalImages,
//   });
//
//   factory NewRestaurantModel.fromJson(Map<String, dynamic> json) {
//     return NewRestaurantModel(
//       id: json['id']?.toString() ?? '',
//       restaurantName: json['restaurant_name'] ?? '',
//       restaurantImage: json['restaurant_image'] ?? '',
//       ownerName: json['owner_name'] ?? '',
//       address: json['address'] ?? '',
//       phone: json['phone'] ?? '',
//       email: json['email'] ?? '',
//       website: json['website'] ?? '',
//       whatsapp: json['whatsapp'] ?? '',
//       facebookLink: json['facebook_link'] ?? '',
//       instagramLink: json['instagram_link'] ?? '',
//       additionalImages: json['additional_images'] != null
//           ? List<String>.from(json['additional_images'])
//           : [],
//     );
//   }
// }
class NewRestaurantModel {
  final String id;
  final String restaurantName;
  final String restaurantImage;
  final String ownerName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String whatsapp;
  final String facebookLink;
  final String instagramLink;
  final List<String> additionalImages;
  final String upiId;      // ✅ Add this
  final String qrCode;     // ✅ Add this

  NewRestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantImage,
    required this.ownerName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.whatsapp,
    required this.facebookLink,
    required this.instagramLink,
    required this.additionalImages,
    required this.upiId,   // ✅ Add this
    required this.qrCode,  // ✅ Add this
  });

  factory NewRestaurantModel.fromJson(Map<String, dynamic> json) {
    return NewRestaurantModel(
      id: json['id']?.toString() ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      restaurantImage: json['restaurant_image'] ?? '',
      ownerName: json['owner_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      instagramLink: json['instagram_link'] ?? '',
      additionalImages: List<String>.from(json['additional_images'] ?? []),
      upiId: json['upi_id'] ?? '',    // ✅ Add this
      qrCode: json['qr_code'] ?? '',  // ✅ Add this
    );
  }
}