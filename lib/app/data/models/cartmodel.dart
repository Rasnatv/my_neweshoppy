//
// class CartItem {
//   final String productId;
//   final String productName;
//   final String productImage;
//   final int type; // 0 = normal, 1 = offer
//   final double price;        // original_price
//   final double offerPrice;   // offer_price
//   final double offerPercentage;
//   final double finalPrice;   // what customer actually pays
//   final int quantity;
//   final double itemTotal;
//
//   CartItem({
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.type,
//     required this.price,
//     required this.offerPrice,
//     required this.offerPercentage,
//     required this.finalPrice,
//     required this.quantity,
//     required this.itemTotal,
//   });
//
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       productId: json['product_id'].toString(),
//       productName: json['name'] ?? '',
//       productImage: json['image'] ?? '',
//       type: int.tryParse(json['type'].toString()) ?? 0,
//       price: double.tryParse(json['price'].toString()) ?? 0.0,
//       offerPrice: double.tryParse(json['offer_price'].toString()) ?? 0.0,
//       offerPercentage: double.tryParse(json['offer_percentage'].toString()) ?? 0.0,
//       finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
//       quantity: int.tryParse(json['quantity'].toString()) ?? 1,
//       itemTotal: double.tryParse(json['item_total'].toString()) ?? 0.0,
//     );
//   }
//
//   CartItem copyWith({
//     String? productId,
//     String? productName,
//     String? productImage,
//     int? type,
//     double? price,
//     double? offerPrice,
//     double? offerPercentage,
//     double? finalPrice,
//     int? quantity,
//     double? itemTotal,
//   }) {
//     return CartItem(
//       productId: productId ?? this.productId,
//       productName: productName ?? this.productName,
//       productImage: productImage ?? this.productImage,
//       type: type ?? this.type,
//       price: price ?? this.price,
//       offerPrice: offerPrice ?? this.offerPrice,
//       offerPercentage: offerPercentage ?? this.offerPercentage,
//       finalPrice: finalPrice ?? this.finalPrice,
//       quantity: quantity ?? this.quantity,
//       itemTotal: itemTotal ?? this.itemTotal,
//     );
//   }
// }
class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final int type;
  final double price;
  final double offerPrice;
  final double offerPercentage;
  final double finalPrice;
  final int quantity;
  final double itemTotal;
  final int stock; // ✅ NEW

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.type,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.finalPrice,
    required this.quantity,
    required this.itemTotal,
    required this.stock, // ✅ NEW
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'].toString(),
      productName: json['name'] ?? '',
      productImage: json['image'] ?? '',
      type: int.tryParse(json['type'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      offerPrice: double.tryParse(json['offer_price'].toString()) ?? 0.0,
      offerPercentage: double.tryParse(json['offer_percentage'].toString()) ?? 0.0,
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      itemTotal: double.tryParse(json['item_total'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0, // ✅ NEW
    );
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    int? type,
    double? price,
    double? offerPrice,
    double? offerPercentage,
    double? finalPrice,
    int? quantity,
    double? itemTotal,
    int? stock, // ✅ NEW
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      type: type ?? this.type,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      finalPrice: finalPrice ?? this.finalPrice,
      quantity: quantity ?? this.quantity,
      itemTotal: itemTotal ?? this.itemTotal,
      stock: stock ?? this.stock, // ✅ NEW
    );
  }
}