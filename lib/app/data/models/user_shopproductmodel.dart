
class UserShopProductModel {
  final int productId;
  final String productName;
  final String image;
  final String price;
  final int type; // 0 = simple, 1 = variant

  UserShopProductModel({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.type,
  });

  factory UserShopProductModel.fromJson(Map<String, dynamic> json) {
    return UserShopProductModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      image: json['image'] ?? '',

      // handle int + string safely
      price: json['price'] == null
          ? "0"
          : json['price'].toString(),

      type: json['type'] ?? 0,
    );
  }
}