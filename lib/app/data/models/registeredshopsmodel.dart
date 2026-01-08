class Shop {
  final String name;
  final String phone;
  final DateTime registeredAt;

  Shop({
    required this.name,
    required this.phone,
    required this.registeredAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['shop_name'] ?? '',
      phone: json['phone_no_1'] ?? '',
      registeredAt: DateTime.parse(json['registered']),
    );
  }
}
