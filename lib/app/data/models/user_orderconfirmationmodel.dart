
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
  final String name;
  final String phone;
  final String address;

  AddressPreview({required this.name, required this.phone, required this.address});

  factory AddressPreview.fromJson(Map<String, dynamic> json) {
    return AddressPreview(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}

class OrderItem {
  final String productId;
  final String variantId;
  final String productName;
  final String image;
  final double price;
  final int quantity;
  final Map<String, String> attributes;

  OrderItem({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.attributes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'].toString(),
      variantId: json['variant_id'].toString(),
      productName: json['product_name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      attributes: json['attributes'] != null
          ? Map<String, String>.from(
        (json['attributes'] as Map)
            .map((k, v) => MapEntry(k.toString(), v.toString())),
      )
          : {},
    );
  }

  /// Returns formatted string like "Size: S • Color: Cream"
  String get formattedAttributes {
    return attributes.entries
        .map((e) => '${_capitalize(e.key)}: ${e.value}')
        .join('  •  ');
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');
}