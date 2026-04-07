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
      items: (json['items'] as List)
          .map((e) => OrderProduct.fromJson(e))
          .toList(),
    );
  }
}

class OrderProduct {
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double total;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }
}