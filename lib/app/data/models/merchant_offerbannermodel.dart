class MerchantOffer {
  final String merchantId;
  final int discount;
  final String banner;

  MerchantOffer({
    required this.merchantId,
    required this.discount,
    required this.banner,
  });

  factory MerchantOffer.fromJson(Map<String, dynamic> json) {
    return MerchantOffer(
      merchantId: json['merchant_id'].toString(),
      discount: json['discount_percentage'],
      banner: json['offer_banner'],
    );
  }
}
