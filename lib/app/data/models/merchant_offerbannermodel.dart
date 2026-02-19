class MerchantOffersviewmodel {
  final int offerId;
  final int discountPercentage;
  final String offerBanner;

  MerchantOffersviewmodel({
    required this.offerId,
    required this.discountPercentage,
    required this.offerBanner,
  });

  factory MerchantOffersviewmodel.fromJson(Map<String, dynamic> json) {
    return MerchantOffersviewmodel(
      offerId: json['offer_id'] ,
      discountPercentage: json['discount_percentage'],
      offerBanner: json['offer_banner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offer_id': offerId,
      'discount_percentage': discountPercentage,
      'offer_banner': offerBanner,
    };
  }
}