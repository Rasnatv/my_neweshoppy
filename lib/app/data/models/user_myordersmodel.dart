
class MyOrdersModel {
  final String orderId;
  final String orderDate;
  final double totalAmount;
  final List<OrderProduct> items;

  MyOrdersModel({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
  });

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) {
    return MyOrdersModel(
      orderId: json['order_id'] ?? '',
      orderDate: json['order_date'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      items: (json['items'] as List? ?? [])
          .map((e) => OrderProduct.fromJson(e))
          .toList(),
    );
  }
}

// ── Variant ──────────────────────────────────────────────────────────────────
class OrderVariant {
  final int variantId;
  final Map<String, String> attributes;
  final double price;
  final double finalPrice;
  final String image;

  OrderVariant({
    required this.variantId,
    required this.attributes,
    required this.price,
    required this.finalPrice,
    required this.image,
  });

  factory OrderVariant.fromJson(Map<String, dynamic> json) {
    final Map<String, String> attrs = {};
    if (json['attributes'] is Map) {
      (json['attributes'] as Map).forEach((k, v) {
        attrs[k.toString()] = v.toString();
      });
    }

    final price = double.tryParse(json['price'].toString()) ?? 0.0;

    return OrderVariant(
      variantId: int.tryParse(json['variant_id'].toString()) ?? 0,
      attributes: attrs,
      price: price,
      // API doesn't return final_price — fall back to price
      finalPrice: double.tryParse(json['final_price']?.toString() ?? '') ?? price,
      image: json['image']?.toString() ?? '',
    );
  }

  String get displayAttributes => attributes.entries
      .map((e) => '${_cap(e.key)}: ${_cap(e.value)}')
      .join('  ·  ');

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Product ───────────────────────────────────────────────────────────────────
class OrderProduct {
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double total;
  final int type;           // ✅ NEW — 0 = normal, 1 = offer
  final OrderVariant? variant;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.total,
    required this.type,
    this.variant,
  });

  /// Unit price — prefer variant.finalPrice, else derive from total
  double get price =>
      variant?.finalPrice ?? (quantity > 0 ? total / quantity : 0.0);

  /// Prefer variant image over product image
  String get displayImage =>
      (variant?.image.isNotEmpty == true) ? variant!.image : productImage;

  /// Whether a discount exists on this item
  bool get hasDiscount =>
      variant != null && variant!.finalPrice < variant!.price;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    final variantJson = json['variant'] as Map<String, dynamic>?;
    return OrderProduct(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      type: int.tryParse(json['type'].toString()) ?? 0, // ✅
      variant: variantJson != null ? OrderVariant.fromJson(variantJson) : null,
    );
  }
}