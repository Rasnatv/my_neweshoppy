class AdminViewOfferModel {
  final int offerId;
  final String shopName;
  final String offerBanner;
  final String discountPercentage;

  AdminViewOfferModel({
    required this.offerId,
    required this.shopName,
    required this.offerBanner,
    required this.discountPercentage,
  });

  factory AdminViewOfferModel.fromJson(Map<String, dynamic> json) {
    return AdminViewOfferModel(
      offerId: json['offer_id'],
      shopName: json['shop_name'],
      offerBanner: json['offer_banner'],
      discountPercentage: json['discount_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offer_id': offerId,
      'shop_name': shopName,
      'offer_banner': offerBanner,
      'discount_percentage': discountPercentage,
    };
  }
}