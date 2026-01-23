// class UserShopProductModel {
//   final int productId;
//   final String productName;
//   final String image;
//   final String price;
//
//   UserShopProductModel({
//     required this.productId,
//     required this.productName,
//     required this.image,
//     required this.price,
//   });
//
//   factory UserShopProductModel.fromJson(Map<String, dynamic> json) {
//     return UserShopProductModel(
//       productId: json['product_id'] ?? 0,
//       productName: json['product_name'] ?? '',
//       image: json['image'] ?? '',
//       price: json['price'] ?? '',
//     );
//   }
// }
class UserShopProductModel {
  final int productId;
  final String productName;
  final String? image;
  final String price;

  UserShopProductModel({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
  });

  factory UserShopProductModel.fromJson(Map<String, dynamic> json) {
    return UserShopProductModel(
      productId: json['product_id'],
      productName: json['product_name'] ?? '',
      image: json['image'],
      price: json['price'] == null || json['price'] == 0
          ? "0"
          : json['price'].toString(),
    );
  }
}
