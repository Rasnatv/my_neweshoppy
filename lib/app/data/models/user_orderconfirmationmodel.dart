class OrderConfirmationModel {
  final AddressPreview address;
  final List<OrderItem> items;
  final double totalAmount;

  OrderConfirmationModel({
    required this.address,
    required this.items,
    required this.totalAmount,
  });

  factory OrderConfirmationModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationModel(
      address: AddressPreview.fromJson(json['address']),
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }
}

class AddressPreview {
  final int addressId;
  final String name;
  final String phone;
  final String address;

  AddressPreview({
    required this.addressId,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory AddressPreview.fromJson(Map<String, dynamic> json) {
    return AddressPreview(
      addressId: int.parse(json['address_id'].toString()),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class OrderItem {
  final int productId;
  final String productName;
  final String image;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: int.parse(json['product_id'].toString()),
      productName: json['product_name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}