

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

class OrderVariant {
  final int variantId;
  final Map<String, String> attributes;
  final double price;      // original price
  final double finalPrice; // discounted price
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
    return OrderVariant(
      variantId: int.tryParse(json['variant_id'].toString()) ?? 0,
      attributes: attrs,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      finalPrice: double.tryParse(json['final_price']?.toString() ?? '') ??
          double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image']?.toString() ?? '',
    );
  }

  // "Size: XXL  ·  Color: Lavender"
  String get displayAttributes => attributes.entries
      .map((e) => '${_cap(e.key)}: ${_cap(e.value)}')
      .join('  ·  ');

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class OrderProduct {
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double total;
  final OrderVariant? variant;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.total,
    this.variant,
  });

  // Use final_price from variant if available
  double get price => variant?.finalPrice ??
      (quantity > 0 ? total / quantity : 0.0);

  // Prefer variant image if non-empty
  String get displayImage =>
      (variant?.image.isNotEmpty == true) ? variant!.image : productImage;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    final variantJson = json['variant'] as Map<String, dynamic>?;
    return OrderProduct(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      variant: variantJson != null ? OrderVariant.fromJson(variantJson) : null,
    );
  }
}