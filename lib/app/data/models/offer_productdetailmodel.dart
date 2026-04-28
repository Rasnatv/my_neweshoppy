
class MOfferProductDetailModel {
  final bool status;
  final int statusCode;
  final String message;
  final MOfferProductDetail? data;

  MOfferProductDetailModel({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory MOfferProductDetailModel.fromJson(Map<String, dynamic> json) {
    return MOfferProductDetailModel(
      status: (json['status'] == 1 || json['status'] == true),
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? MOfferProductDetail.fromJson(json['data'])
          : null,
    );
  }
}

// ─── Detail ───────────────────────────────────────────────────────────────────

class MOfferProductDetail {
  final int offerProductId;
  final int offerId;
  final String productName;
  final String description;
  final int categoryId;
  final double price;
  final double offerPrice;
  final int discountPercentage;
  final double discountAmount;
  final Map<String, String> commonAttributes;
  final List<MOfferVariant> variants;
  final List<dynamic> features;

  MOfferProductDetail({
    required this.offerProductId,
    required this.offerId,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.offerPrice,
    required this.discountPercentage,
    required this.discountAmount,
    required this.commonAttributes,
    required this.variants,
    required this.features,
  });

  factory MOfferProductDetail.fromJson(Map<String, dynamic> json) {
    // ✅ Detail API returns "product_id", update response returns "offer_product_id"
    // Handle both so fromJson works for both API responses.
    final rawId = json['offer_product_id'] ?? json['product_id'];

    Map<String, String> commonAttrs = {};
    final rawCommon = json['common_attributes'];
    if (rawCommon != null && rawCommon is Map) {
      rawCommon.forEach(
            (k, v) => commonAttrs[k.toString()] = v?.toString() ?? '',
      );
    }

    List<MOfferVariant> variantsList = [];
    final rawVariants = json['variants'];
    if (rawVariants != null && rawVariants is List) {
      variantsList =
          rawVariants.map((v) => MOfferVariant.fromJson(v)).toList();
    }

    // ✅ Derive discount_percentage from top-level if present,
    // otherwise compute from first variant's price vs final_price.
    int discountPct =
        int.tryParse(json['discount_percentage']?.toString() ?? '0') ?? 0;
    if (discountPct == 0 && variantsList.isNotEmpty) {
      final v = variantsList[0];
      if (v.price > 0 && v.finalPrice > 0 && v.finalPrice < v.price) {
        discountPct = ((1 - v.finalPrice / v.price) * 100).round();
      }
    }

    // ✅ Derive offerPrice: prefer top-level offer_price,
    // fallback to first variant's final_price.
    double offerPriceVal =
        double.tryParse(json['offer_price']?.toString() ?? '0') ??
            double.tryParse(json['final_price']?.toString() ?? '0') ??
            0.0;
    if (offerPriceVal == 0 && variantsList.isNotEmpty) {
      offerPriceVal = variantsList[0].finalPrice;
    }

    return MOfferProductDetail(
      offerProductId: int.tryParse(rawId?.toString() ?? '0') ?? 0,
      offerId: int.tryParse(json['offer_id']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      offerPrice: offerPriceVal,
      discountPercentage: discountPct,
      discountAmount:
      double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0.0,
      commonAttributes: commonAttrs,
      variants: variantsList,
      features: json['features'] ?? [],
    );
  }
}

// ─── Variant ──────────────────────────────────────────────────────────────────

class MOfferVariant {
  final int? variantId;
  final Map<String, String> attributes;
  double price;
  int stock;
  String imagePath;
  final double finalPrice;
  bool imageUpdated;

  MOfferVariant({
    this.variantId,
    required this.attributes,
    required this.price,
    required this.stock,
    required this.imagePath,
    required this.finalPrice,
    this.imageUpdated = false,
  });

  factory MOfferVariant.fromJson(Map<String, dynamic> json) {
    Map<String, String> attrs = {};
    final raw = json['attributes'];
    if (raw != null && raw is Map) {
      raw.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty) {
          attrs[k.toString()] = v.toString();
        }
      });
    }

    return MOfferVariant(
      // ✅ FIX: detail API uses "id", update response uses "variant_id" — handle both
      variantId: int.tryParse(
          (json['variant_id'] ?? json['id'])?.toString() ?? ''),
      attributes: attrs,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      imagePath: json['image']?.toString() ?? '',
      finalPrice:
      double.tryParse(json['final_price']?.toString() ?? '0') ?? 0.0,
    );
  }

  String getDisplayName() {
    if (attributes.isEmpty) return 'Variant';
    return attributes.values.join(' - ');
  }
}