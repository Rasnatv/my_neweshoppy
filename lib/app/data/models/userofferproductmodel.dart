
class UserOfferProductModel {
  final int id;
  final String productName;
  final String productImage;
  final int type;
  final String originalPrice;
  final String offerPrice;

  UserOfferProductModel({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.type,
    required this.originalPrice,
    required this.offerPrice,
  });

  factory UserOfferProductModel.fromJson(Map<String, dynamic> json) {
    return UserOfferProductModel(
      id: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      type: json['type'] ?? 0,
      originalPrice: json['original_price'] ?? '0.00',
      offerPrice: json['offer_price'] ?? '0.00',
    );
  }
}