class MerchantOrderAddress {
  final String name;
  final String phone;
  final String address;

  MerchantOrderAddress({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory MerchantOrderAddress.fromJson(Map<String, dynamic> json) {
    return MerchantOrderAddress(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class MerchantOrderModel {
  final int orderId;
  final String orderDate;
  final MerchantOrderAddress address;
  final List<MerchantOrderProduct> products;
  final double totalAmount;

  MerchantOrderModel({
    required this.orderId,
    required this.orderDate,
    required this.address,
    required this.products,
    required this.totalAmount,
  });

  factory MerchantOrderModel.fromJson(Map<String, dynamic> json) {
    return MerchantOrderModel(
      orderId: json['order_id'],
      orderDate: json['order_date'] ?? '',
      address: MerchantOrderAddress.fromJson(json['address'] ?? {}),
      products: (json['products'] as List)
          .map((e) => MerchantOrderProduct.fromJson(e))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }
}

class MerchantOrderProduct {
  final int productId;
  final String productName;
  final String image;
  final double price;
  final int quantity;
  final double total;

  MerchantOrderProduct({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory MerchantOrderProduct.fromJson(Map<String, dynamic> json) {
    return MerchantOrderProduct(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
      total: (json['total'] as num).toDouble(),
    );
  }
}