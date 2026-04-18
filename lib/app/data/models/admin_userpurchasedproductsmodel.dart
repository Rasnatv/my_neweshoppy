// ─── Model ────────────────────────────────────────────────────────────────────

class PurchasedProductModel {
  final bool status;
  final int statusCode;
  final String message;
  final int userId;
  final List<PurchasedProduct> data;

  PurchasedProductModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.userId,
    required this.data,
  });

  factory PurchasedProductModel.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'] as Map<String, dynamic>?;
    final productsList = dataObj?['products'] as List<dynamic>? ?? [];

    return PurchasedProductModel(
      status: (json['status'] == 1 || json['status'] == true),
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      userId: dataObj?['user_id'] ?? 0,
      data: productsList
          .map((e) => PurchasedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── Product ──────────────────────────────────────────────────────────────────

class PurchasedProduct {
  final String orderId;
  final String productName;
  final double price;
  final int quantity;
  final double total;

  PurchasedProduct({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory PurchasedProduct.fromJson(Map<String, dynamic> json) {
    return PurchasedProduct(
      orderId: json['order_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }
}