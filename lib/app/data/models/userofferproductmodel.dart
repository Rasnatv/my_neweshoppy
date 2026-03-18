
class UserOfferProductModel {
  final int id;
  final String productName;
  final String productImage;
  final String originalPrice;
  final String offerPrice;

  UserOfferProductModel({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.originalPrice,
    required this.offerPrice,
  });

  factory UserOfferProductModel.fromJson(Map<String, dynamic> json) {
    return UserOfferProductModel(
      id: json['id'],
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      originalPrice: json['original_price'] ?? '0.00',
      offerPrice: json['offer_price'] ?? '0.00',
    );
  }
}