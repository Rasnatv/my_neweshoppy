class AdminOfferProductModel {
  final int id;
  final String productName;
  final String stockQty;
  final String originalPrice;
  final double offerPrice;
  final String discountPercentage;
  final String productImage;

  AdminOfferProductModel({
    required this.id,
    required this.productName,
    required this.stockQty,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercentage,
    required this.productImage,
  });

  factory AdminOfferProductModel.fromJson(Map<String, dynamic> json) {
    return AdminOfferProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      stockQty: json['stock_qty']?.toString() ?? '0',
      originalPrice: json['original_price']?.toString() ?? '0',
      offerPrice: (json['offer_price'] is num)
          ? (json['offer_price'] as num).toDouble()
          : double.tryParse(json['offer_price'].toString()) ?? 0.0,
      discountPercentage: json['discount_percentage']?.toString() ?? '0',
      productImage: json['product_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_name': productName,
    'stock_qty': stockQty,
    'original_price': originalPrice,
    'offer_price': offerPrice,
    'discount_percentage': discountPercentage,
    'product_image': productImage,
  };
}