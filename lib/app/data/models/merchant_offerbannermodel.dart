

class MerchantOffersviewmodel {
  final int offerId;               // API sends int → use int
  final double discountPercentage; // API sends "25.00" string → use double
  final String offerBanner;

  MerchantOffersviewmodel({
    required this.offerId,
    required this.discountPercentage,
    required this.offerBanner,
  });

  factory MerchantOffersviewmodel.fromJson(Map<String, dynamic> json) {
    return MerchantOffersviewmodel(
      offerId: _parseInt(json['offer_id']),
      discountPercentage: _parseDouble(json['discount_percentage']),
      offerBanner: json['offer_banner']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offer_id': offerId,
      'discount_percentage': discountPercentage,
      'offer_banner': offerBanner,
    };
  }

  // ── Safe parsers (handles int, double, or String from API) ───────────────
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}