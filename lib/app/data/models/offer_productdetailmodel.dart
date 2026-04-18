// ─── Model ────────────────────────────────────────────────────────────────────

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

class MOfferProductDetail {
  final int offerProductId;
  final String productName;
  final String description;
  final Map<String, String> commonAttributes;
  final List<MOfferVariant> variants;
  final List<dynamic> features;

  MOfferProductDetail({
    required this.offerProductId,
    required this.productName,
    required this.description,
    required this.commonAttributes,
    required this.variants,
    required this.features,
  });

  factory MOfferProductDetail.fromJson(Map<String, dynamic> json) {
    // common_attributes lives inside product_attributes
    Map<String, String> commonAttrs = {};
    final productAttributes = json['product_attributes'];
    if (productAttributes != null && productAttributes is Map) {
      final raw = productAttributes['common_attributes'];
      if (raw != null && raw is Map) {
        raw.forEach((k, v) =>
        commonAttrs[k.toString()] = v?.toString() ?? '');
      }
    }

    // variants live inside product_attributes
    List<MOfferVariant> variantsList = [];
    if (productAttributes != null && productAttributes is Map) {
      final rawVariants = productAttributes['variants'];
      if (rawVariants != null && rawVariants is List) {
        variantsList =
            rawVariants.map((v) => MOfferVariant.fromJson(v)).toList();
      }
    }

    return MOfferProductDetail(
      offerProductId:
      int.tryParse(json['offer_product_id']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      commonAttributes: commonAttrs,
      variants: variantsList,
      features: json['features'] ?? [],
    );
  }
}

class MOfferVariant {
  final Map<String, String> attributes;
   double price;
   int stock;
  String imagePath; // mutable — can be replaced with local file path
  final double finalPrice;
  bool imageUpdated;

  MOfferVariant({
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