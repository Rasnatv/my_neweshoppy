// ─────────────────────────────────────────────────────────────
//  FILE: data/models/offer_productdetailmodel.dart
//  API : POST /offer-product-details  { "product_id": 93 }
//
//  Response data shape:
//  {
//    "product_id": "93",
//    "product_name": "chappal",
//    "description": "nice with border colour",
//    "product_attributes": {
//      "common_attributes": { "material": "...", "brand": "...", "type": "..." },
//      "variants": [
//        {
//          "attributes": { "colour": "gree", "size": "purple" },
//          "price": 450,
//          "stock": 5,
//          "image": "https://...",
//          "final_price": 337.5
//        }
//      ]
//    },
//    "features": []
//  }
//
//  NOTE: There is NO top-level price / offer_price / discount_percentage /
//  stock_qty / product_images in this response. All of those come from
//  the variants. The model derives them from the first variant as defaults.
// ─────────────────────────────────────────────────────────────

class OfferProductVariant {
  final Map<String, String> attributes; // e.g. {"colour": "gree", "size": "purple"}
  final double price;                   // json: "price"       e.g. 450
  final int stock;                      // json: "stock"       e.g. 5
  final String image;                   // json: "image"       e.g. "https://..."
  final double finalPrice;              // json: "final_price" e.g. 337.5

  OfferProductVariant({
    required this.attributes,
    required this.price,
    required this.stock,
    required this.image,
    required this.finalPrice,
  });

  /// Computed: price - final_price
  double get savedAmount => price - finalPrice;

  /// Computed: ((price - final_price) / price) * 100
  double get discountPercentage =>
      price > 0 ? ((price - finalPrice) / price) * 100 : 0.0;

  factory OfferProductVariant.fromJson(Map<String, dynamic> json) {
    final rawAttrs = json['attributes'] as Map<String, dynamic>? ?? {};
    return OfferProductVariant(
      attributes: rawAttrs.map((k, v) => MapEntry(k, v.toString())),
      price:      double.tryParse(json['price'].toString()) ?? 0.0,
      stock:      int.tryParse(json['stock'].toString()) ?? 0,
      image:      json['image']?.toString() ?? '',
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
    );
  }
}

class ProductAttributes {
  final Map<String, String> commonAttributes; // json: "common_attributes"
  final List<OfferProductVariant> variants;   // json: "variants"

  ProductAttributes({
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    final rawCommon   = json['common_attributes'] as Map<String, dynamic>? ?? {};
    final rawVariants = json['variants'] as List? ?? [];
    return ProductAttributes(
      commonAttributes: rawCommon.map((k, v) => MapEntry(k, v.toString())),
      variants: rawVariants
          .map((e) => OfferProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MerchantOfferProductDetailModel {
  final int productId;                       // json: "product_id"
  final String productName;                  // json: "product_name"
  final String description;                  // json: "description"
  final ProductAttributes productAttributes; // json: "product_attributes"
  final List<dynamic> features;              // json: "features"

  MerchantOfferProductDetailModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.productAttributes,
    required this.features,
  });

  // ── Derived helpers (from first variant, fall back to 0) ─────────────────

  /// Original price from the first variant.
  double get price =>
      productAttributes.variants.isNotEmpty
          ? productAttributes.variants.first.price
          : 0.0;

  /// Offer / final price from the first variant.
  double get offerPrice =>
      productAttributes.variants.isNotEmpty
          ? productAttributes.variants.first.finalPrice
          : 0.0;

  /// Discount percentage from the first variant.
  double get discountPercentage =>
      productAttributes.variants.isNotEmpty
          ? productAttributes.variants.first.discountPercentage
          : 0.0;

  /// Total stock across all variants.
  int get stockQty => productAttributes.variants.fold(
      0, (sum, v) => sum + v.stock);

  /// Saved amount from the first variant.
  double get savedAmount => price - offerPrice;

  /// All variant images (non-empty http URLs), one per variant.
  List<String> get productImages => productAttributes.variants
      .map((v) => v.image)
      .where((img) => img.isNotEmpty && img.startsWith('http'))
      .toList();

  factory MerchantOfferProductDetailModel.fromJson(
      Map<String, dynamic> json) {
    return MerchantOfferProductDetailModel(
      productId:   int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      productAttributes: ProductAttributes.fromJson(
          json['product_attributes'] as Map<String, dynamic>? ?? {}),
      features: json['features'] ?? [],
    );
  }
}