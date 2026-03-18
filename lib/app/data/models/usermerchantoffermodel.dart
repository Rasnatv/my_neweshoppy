// class UserOfferModel {
//   final int offer_id;
//   final int merchant_id;
//   final String discountPercentage;
//   final String image;
//   final String shopName;
//
//   UserOfferModel({
//     required this. offer_id,
//    required this. merchant_id,
//     required this.discountPercentage,
//     required this.image,
//     required this.shopName,
//   });
//
//   factory UserOfferModel.fromJson(Map<String, dynamic> json) {
//     return UserOfferModel(
//       merchant_id: json['merchant_id'],
//       offer_id :json['offer_id'],
//       discountPercentage: json['discount_percentage'],
//       image: json['image'],
//       shopName: json['shop_name'],
//     );
//   }
// }
class UserOfferModel {
  final int offerId;
  final int? merchantId;       // ✅ nullable — API sends null
  final String discountPercentage;
  final String image;
  final String? shopName;      // ✅ nullable — API sends null

  UserOfferModel({
    required this.offerId,
    this.merchantId,            // ✅ optional
    required this.discountPercentage,
    required this.image,
    this.shopName,              // ✅ optional
  });

  factory UserOfferModel.fromJson(Map<String, dynamic> json) {
    return UserOfferModel(
      offerId: json['offer_id'] ?? 0,
      merchantId: json['merchant_id'],                      // null-safe
      discountPercentage: json['discount_percentage'] ?? '0',
      image: json['image'] ?? '',
      shopName: json['shop_name'],                          // null-safe
    );
  }
}