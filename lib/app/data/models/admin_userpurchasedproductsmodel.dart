
class PurchasedProductModel {
  final bool status;
  final String message;
  final List<OrderItem> data;

  PurchasedProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PurchasedProductModel.fromJson(Map<String, dynamic> json) {
    return PurchasedProductModel(
      status: json['status'] == true || json['status'] == 1,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderItem {
  final String orderId;
  final String orderDate;
  final double totalAmount;
  final List<PurchasedProduct> items;

  OrderItem({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: json['order_id'] ?? '',
      orderDate: json['order_date'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PurchasedProduct.fromJson(e))
          .toList(),
    );
  }
}

class PurchasedProduct {
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double total;

  PurchasedProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory PurchasedProduct.fromJson(Map<String, dynamic> json) {
    return PurchasedProduct(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }
}