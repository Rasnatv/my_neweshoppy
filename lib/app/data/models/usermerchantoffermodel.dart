
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