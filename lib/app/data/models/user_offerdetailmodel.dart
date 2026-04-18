
class UserOfferProductDetail {
  final int id;
  final String merchantId;
  final String productName;
  final String categoryId;
  final String description;
  final double discountPercentage;
  final List<String> productImages;
  final Map<String, String> commonAttributes;
  final List<ProductVariant> variants;

  UserOfferProductDetail({
    required this.id,
    required this.merchantId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.discountPercentage,
    required this.productImages,
    required this.commonAttributes,
    required this.variants,
  });

  // ── Computed from first variant (fallback) ─────────────────
  double get price => variants.isNotEmpty ? variants.first.price : 0.0;
  double get offerPrice => variants.isNotEmpty ? variants.first.offerPrice : 0.0;
  int get stockQty => variants.fold(0, (sum, v) => sum + v.stock);

  factory UserOfferProductDetail.fromJson(Map<String, dynamic> json) {

    Map<String, String> commonAttrs = {};
    if (json['common_attributes'] != null &&
        json['common_attributes'] is Map) {
      (json['common_attributes'] as Map).forEach((key, value) {
        commonAttrs[key.toString()] = value.toString();
      });
    }

    // ── variants: directly under data ─────────────────────
    List<ProductVariant> variantsList = [];
    if (json['variants'] != null) {
      variantsList = (json['variants'] as List)
          .map((e) => ProductVariant.fromJson(e))
          .toList();
    }

    // ── productImages: collected from each variant's image ─
    final images = variantsList
        .map((v) => v.image)
        .where((img) => img.isNotEmpty)
        .toList();

    return UserOfferProductDetail(
      id: int.tryParse(json['id'].toString()) ?? 0,
      merchantId: json['merchant_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      description: json['description'] ?? '',
      discountPercentage:
      double.tryParse(json['discount_percentage']?.toString() ?? '0') ?? 0.0,
      productImages: images,
      commonAttributes: commonAttrs,
      variants: variantsList,
    );
  }
}

class ProductVariant {
  final Map<String, String> attributes; // colour + size as key-value
  final double price;
  final double offerPrice; // ← each variant has its own offer price
  final int stock;
  final String image; // ← each variant has its own image

  ProductVariant({
    required this.attributes,
    required this.price,
    required this.offerPrice,
    required this.stock,
    required this.image,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    // ── Build attributes from flat colour/size fields ──────
    Map<String, String> attrs = {};
    if (json['colour'] != null && json['colour'].toString().isNotEmpty) {
      attrs['colour'] = json['colour'].toString();
    }
    if (json['size'] != null && json['size'].toString().isNotEmpty) {
      attrs['size'] = json['size'].toString();
    }

    return ProductVariant(
      attributes: attrs,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      offerPrice:
      double.tryParse(json['offer_price']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(json['stock_qty']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }

  String getDisplayName() {
    if (attributes.isEmpty) return 'Variant';
    return attributes.values.join(' - ');
  }
}