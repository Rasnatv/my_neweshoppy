


class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final int type;
  final double price;
  final double offerPrice;
  final double offerPercentage;
  final double finalPrice;
  final int quantity;
  final double itemTotal;
  final int stock;

  // ✅ VARIANT
  final int? variantId;
  final Map<String, dynamic>? attributes;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.type,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.finalPrice,
    required this.quantity,
    required this.itemTotal,
    required this.stock,
    this.variantId,
    this.attributes,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variant = json['variant'] as Map<String, dynamic>?;

    return CartItem(
      productId: json['product_id']?.toString() ?? '',
      productName: json['name'] ?? '',
      type: int.tryParse(json['type'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      itemTotal: double.tryParse(json['item_total'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 999,

      // ✅ All pulled from variant, not root
      productImage: variant?['image'] ?? '',
      price: double.tryParse(variant?['price'].toString() ?? '') ?? 0.0,
      offerPrice: double.tryParse(variant?['offer_price'].toString() ?? '') ?? 0.0,
      offerPercentage: double.tryParse(variant?['offer_percentage'].toString() ?? '') ?? 0.0,
      finalPrice: double.tryParse(variant?['final_price'].toString() ?? '') ?? 0.0,

      // ✅ Variant fields
      variantId: variant?['variant_id'],
      attributes: variant?['attributes'],
    );
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    int? type,
    double? price,
    double? offerPrice,
    double? offerPercentage,
    double? finalPrice,
    int? quantity,
    double? itemTotal,
    int? stock,
    int? variantId,
    Map<String, dynamic>? attributes,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      type: type ?? this.type,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      finalPrice: finalPrice ?? this.finalPrice,
      quantity: quantity ?? this.quantity,
      itemTotal: itemTotal ?? this.itemTotal,
      stock: stock ?? this.stock,
      variantId: variantId ?? this.variantId,
      attributes: attributes ?? this.attributes,
    );
  }
}
