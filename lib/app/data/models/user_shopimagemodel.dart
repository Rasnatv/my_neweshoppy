class UserShopDetailModel {
  final String shopName;
  final String image;

  UserShopDetailModel({
    required this.shopName,
    required this.image,
  });

  factory UserShopDetailModel.fromJson(Map<String, dynamic> json) {
    return UserShopDetailModel(
      shopName: json['shop_name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
