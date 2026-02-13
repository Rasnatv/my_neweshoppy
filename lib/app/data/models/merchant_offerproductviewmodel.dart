class MerchantViewOfferProduct {
  final int offerId;
  final String productName;
  final String productImage;
  final String realPrice;
  final String offerPrice;

  MerchantViewOfferProduct({
    required this.offerId,
    required this.productName,
    required this.productImage,
    required this.realPrice,
    required this.offerPrice,
  });

  factory MerchantViewOfferProduct.fromJson(Map<String, dynamic> json) {
    return MerchantViewOfferProduct(
      offerId: json['offer_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      realPrice: json['real_price'],
      offerPrice: json['offer_price'],
    );
  }
}
