
class UserOfferProductDetail {
  final int productId;
  final int offerId;       // ✅ NEW
  final int type;
  final int variantId;
  final String merchantId;
  final String productName;
  final String categoryId;
  final String description;
  final double discountPercentage;
  final List<String> productImages;
  final Map<String, String> commonAttributes;
  final List<ProductVariant> variants;

  UserOfferProductDetail({
    required this.productId,
    required this.offerId,  // ✅ NEW
    required this.type,
    required this.variantId,
    required this.merchantId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.discountPercentage,
    required this.productImages,
    required this.commonAttributes,
    required this.variants,
  });

  double get price => variants.isNotEmpty ? variants.first.price : 0.0;
  double get offerPrice =>
      variants.isNotEmpty ? variants.first.offerPrice : 0.0;
  int get stockQty => variants.fold(0, (sum, v) => sum + v.stock);

  factory UserOfferProductDetail.fromJson(Map<String, dynamic> json) {
    final Map<String, String> commonAttrs = {};
    if (json['common_attributes'] is Map) {
      (json['common_attributes'] as Map).forEach((key, value) {
        commonAttrs[key.toString()] = value.toString();
      });
    }

    final List<ProductVariant> variantsList = [];
    if (json['variants'] != null) {
      for (final e in (json['variants'] as List)) {
        variantsList.add(ProductVariant.fromJson(e as Map<String, dynamic>));
      }
    }

    final List<String> images = variantsList
        .map((v) => v.image)
        .where((img) => img.isNotEmpty)
        .toList();

    return UserOfferProductDetail(
      productId:
      int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      offerId:                                                          // ✅ NEW
      int.tryParse(json['offer_id']?.toString() ?? '0') ?? 0,      // ✅ NEW
      type: int.tryParse(json['type']?.toString() ?? '0') ?? 0,
      variantId:
      int.tryParse(json['variant_id']?.toString() ?? '0') ?? 0,
      merchantId: json['merchant_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      discountPercentage: double.tryParse(
          json['discount_percentage']?.toString() ?? '0') ??
          0.0,
      productImages: images,
      commonAttributes: commonAttrs,
      variants: variantsList,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ProductVariant {
  final int variantId;
  // ✅ REMOVED: type field — no longer present in variant-level API response
  final Map<String, String> attributes;
  final double price;
  final double offerPrice;
  final int stock;
  final String image;

  String imagePath;
  bool imageUpdated;

  ProductVariant({
    required this.variantId,
    required this.attributes,
    required this.price,
    required this.offerPrice,
    required this.stock,
    required this.image,
    this.imagePath = '',
    this.imageUpdated = false,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final Map<String, String> attrs = {};

    final color = json['attributes']?['color']?.toString() ?? '';  // ✅ FIX: read from nested 'attributes' map
    if (color.isNotEmpty) attrs['color'] = color;

    final size = json['attributes']?['size']?.toString() ?? '';    // ✅ FIX: read from nested 'attributes' map
    if (size.isNotEmpty) attrs['size'] = size;

    return ProductVariant(
      variantId:
      int.tryParse(json['variant_id']?.toString() ?? '0') ?? 0,
      // ✅ REMOVED: type parsing
      attributes: attrs,
      price:
      double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      offerPrice:
      double.tryParse(json['offer_price']?.toString() ?? '0') ?? 0.0,
      stock:
      int.tryParse(json['stock_qty']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString() ?? '',
      imagePath: json['image']?.toString() ?? '',
    );
  }

  String getDisplayName() {
    if (attributes.isEmpty) return 'Variant';
    return attributes.values.join(' / ');
  }
}