class MerchantOfferProductModel {
  final int productId;
  final String productName;
  final String productImage;
  final double realPrice;
  final double offerPrice;

  MerchantOfferProductModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.realPrice,
    required this.offerPrice,
  });

  double get savedAmount => realPrice - offerPrice;

  double get discountPercent =>
      double.parse(((savedAmount / realPrice) * 100).toStringAsFixed(0));

  factory MerchantOfferProductModel.fromJson(Map<String, dynamic> json) {
    return MerchantOfferProductModel(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      productImage: json['product_image']?.toString() ?? '',
      realPrice: double.tryParse(json['real_price'].toString()) ?? 0.0,
      offerPrice: double.tryParse(json['offer_price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'real_price': realPrice.toString(),
      'offer_price': offerPrice.toString(),
    };
  }
}