// import 'package:innsouls_flutter/app/data/models/productmodel.dart';
//
//
// class Order {
//   final String name;
//   final String address;
//   final String phone;
//   final String paymentMethod;
//   final List<Product> products;
//   final DateTime timestamp;
//
//   Order({
//     required this.name,
//     required this.address,
//     required this.phone,
//     required this.paymentMethod,
//     required this.products,
//     required this.timestamp,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'address': address,
//     'phone': phone,
//     'paymentMethod': paymentMethod,
//     'products': products.map((p) => p.toJson()).toList(),
//     'timestamp': timestamp.toIso8601String(),
//   };
//
//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//     name: json['name'],
//     address: json['address'],
//     phone: json['phone'],
//     paymentMethod: json['paymentMethod'],
//     products: (json['products'] as List)
//         .map((p) => Product.fromJson(p))
//         .toList(),
//     timestamp: DateTime.parse(json['timestamp']),
//   );
// }
