
class MerchantOfferProductModels {
  final int productId;
  final String productName;
  final String productImage;
  final double realPrice;
  final double offerPrice;
  final double discountPercentage;

  MerchantOfferProductModels({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.realPrice,
    required this.offerPrice,
    required this.discountPercentage,
  });

  double get savedAmount => realPrice - offerPrice;

  factory MerchantOfferProductModels.fromJson(Map<String, dynamic> json) {
    return MerchantOfferProductModels(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',

      // ✅ CORRECT FIELD
      productImage: json['image']?.toString() ?? '',

      // ✅ CORRECT FIELD
      realPrice:
      double.tryParse(json['original_price'].toString()) ?? 0.0,

      // ✅ CORRECT FIELD
      offerPrice:
      double.tryParse(json['discount_price'].toString()) ?? 0.0,

      // ✅ CORRECT FIELD
      discountPercentage:
      double.tryParse(json['discount_percentage'].toString()) ?? 0.0,
    );
  }
}