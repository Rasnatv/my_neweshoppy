class Shop {
  final int id;
  final String name;
  final String phone;
  final DateTime registeredAt;

  Shop({
    required this.id,
    required this.name,
    required this.phone,
    required this.registeredAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] ?? 0,
      name: json['shop_name'] ?? '',
      phone: json['phone_no_1'] ?? '',
      registeredAt: DateTime.parse(json['registered']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': name,
      'phone_no_1': phone,
      'registered': registeredAt.toIso8601String(),
    };
  }
}