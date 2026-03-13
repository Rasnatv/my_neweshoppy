class NMerchantOfferProductModels {
  final int productId;             // json: "product_id"           e.g. "93"
  final String productName;        // json: "product_name"         e.g. "chappal"
  final String productImage;       // json: "image"                e.g. "https://..."
  final double realPrice;          // json: "original_price"       e.g. "450.00"
  final double offerPrice;         // json: "discount_price"       e.g. "337.50"
  final double discountPercentage; // json: "discount_percentage"  e.g. "25.00"

  NMerchantOfferProductModels({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.realPrice,
    required this.offerPrice,
    required this.discountPercentage,
  });

  /// Computed: original_price - discount_price
  double get savedAmount => realPrice - offerPrice;

  factory NMerchantOfferProductModels.fromJson(Map<String, dynamic> json) {
    return NMerchantOfferProductModels(
      productId:
      int.tryParse(json['product_id'].toString()) ?? 0,
      productName:
      json['product_name']?.toString() ?? '',
      productImage:
      json['image']?.toString() ?? '',
      realPrice:
      double.tryParse(json['original_price'].toString()) ?? 0.0,
      offerPrice:
      double.tryParse(json['discount_price'].toString()) ?? 0.0,
      discountPercentage:
      double.tryParse(json['discount_percentage'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id':          productId,
    'product_name':        productName,
    'image':               productImage,
    'original_price':      realPrice,
    'discount_price':      offerPrice,
    'discount_percentage': discountPercentage,
  };
}