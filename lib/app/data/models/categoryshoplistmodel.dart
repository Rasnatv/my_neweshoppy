// class ShoplistModel {
//   final String shopName;
//   final String image;
//   final String location;
//
//   ShoplistModel({
//     required this.shopName,
//     required this.image,
//     required this.location,
//   });
//
//   factory ShoplistModel.fromJson(Map<String, dynamic> json) {
//     return ShoplistModel(
//       shopName: json['shop_name'] ?? '',
//       image: json['image'] ?? '',
//       location: json['location'] ?? '',
//     );
//   }
// }
class ShoplistModel {
  final int merchantId; // ✅ new field
  final String shopName;
  final String image;
  final String location;

  ShoplistModel({
    required this.merchantId,
    required this.shopName,
    required this.image,
    required this.location,
  });

  factory ShoplistModel.fromJson(Map<String, dynamic> json) {
    return ShoplistModel(
      merchantId: json['merchant_id'] != null
          ? int.tryParse(json['merchant_id'].toString()) ?? 0
          : 0,
      shopName: json['shop_name'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
