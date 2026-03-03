class UserOfferModel {
  final int offer_id;
  final int merchant_id;
  final String discountPercentage;
  final String image;
  final String shopName;

  UserOfferModel({
    required this. offer_id,
   required this. merchant_id,
    required this.discountPercentage,
    required this.image,
    required this.shopName,
  });

  factory UserOfferModel.fromJson(Map<String, dynamic> json) {
    return UserOfferModel(
      merchant_id: json['merchant_id'],
      offer_id :json['offer_id'],
      discountPercentage: json['discount_percentage'],
      image: json['image'],
      shopName: json['shop_name'],
    );
  }
}
