//
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
//   final String upiId;      // ✅ Add this
//   final String qrCode;     // ✅ Add this
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
//     required this.upiId,   // ✅ Add this
//     required this.qrCode,  // ✅ Add this
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
//       upiId: json['upi_id'] ?? '',
//       qrCode: json['qr_code'] ?? '',
//
//       // ✅ THE FIX: skip any non-String entries like {}
//       additionalImages: (json['additional_images'] as List? ?? [])
//           .whereType<String>()
//           .toList(),
//     );
//   }}
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
  final String upiId;
  final String qrCode;

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
    required this.upiId,
    required this.qrCode,
  });

  factory NewRestaurantModel.fromJson(Map<String, dynamic> json) {
    // ✅ FIX: Robust additional_images parsing
    // API can return any of these formats:
    //   ["https://..."]               → plain string URLs  ✅ keep
    //   [{}]                          → empty objects      ✅ skip
    //   [{"url":"https://..."}]       → map with url key   ✅ extract
    //   [{"image":"https://..."}]     → map with image key ✅ extract
    //   []                            → empty array        ✅ no images
    //   null                          → null               ✅ no images
    final List<String> parsedAdditionalImages = [];
    final rawList = json['additional_images'] as List? ?? [];

    for (final item in rawList) {
      if (item is String) {
        final trimmed = item.trim();
        if (trimmed.isNotEmpty && trimmed.startsWith('http')) {
          parsedAdditionalImages.add(trimmed);
        }
      } else if (item is Map && item.isNotEmpty) {
        // Handle object formats returned by the API
        final url = (item['url'] ??
            item['image'] ??
            item['image_url'] ??
            item['path'] ??
            item['src'] ??
            item['file'] ??
            '')
            ?.toString()
            .trim();
        if (url != null && url.isNotEmpty) {
          if (url.startsWith('http')) {
            parsedAdditionalImages.add(url);
          } else {
            // Convert relative path → full URL
            parsedAdditionalImages.add("https://eshoppy.co.in/$url");
          }
        }
      }
      // Empty {} or null items are silently skipped ✅
    }

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
      upiId: json['upi_id'] ?? '',
      qrCode: json['qr_code'] ?? '',
      additionalImages: parsedAdditionalImages,
    );
  }
}