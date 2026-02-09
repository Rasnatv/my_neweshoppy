class UserOfferModel {
  final int merchant_id;
  final int discountPercentage;
  final String image;
  final String shopName;

  UserOfferModel({
    required this. merchant_id,
    required this.discountPercentage,
    required this.image,
    required this.shopName,
  });

  factory UserOfferModel.fromJson(Map<String, dynamic> json) {
    return UserOfferModel(
      merchant_id :json['merchant_id'],
      discountPercentage: json['discount_percentage'],
      image: json['image'],
      shopName: json['shop_name'],
    );
  }
}
