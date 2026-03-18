class ShopProduct {
  final int id;
  final String productName;
  final String price;
  final String image;
  final int variantsCount;

  ShopProduct({
    required this.id,
    required this.productName,
    required this.price,
    required this.image,
    required this.variantsCount,
  });

  factory ShopProduct.fromJson(Map<String, dynamic> json) {
    return ShopProduct(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      price: json['price'] ?? '0.00',
      image: json['image'] ?? '',
      variantsCount: json['variants_count'] ?? 0,
    );
  }
}