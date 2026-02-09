// ============== MODELS ==============

class UserOfferProductDetail {
  final int id;
  final String merchantId;
  final String offerName;
  final String offerBanner;
  final String productName;
  final String categoryId;
  final double price;
  final double offerPrice;
  final int discountPercentage;
  final int stockQty;
  final List<String> productImages;
  final Map<String, String> commonAttributes;
  final List<ProductVariant> variants;

  UserOfferProductDetail({
    required this.id,
    required this.merchantId,
    required this.offerName,
    required this.offerBanner,
    required this.productName,
    required this.categoryId,
    required this.price,
    required this.offerPrice,
    required this.discountPercentage,
    required this.stockQty,
    required this.productImages,
    required this.commonAttributes,
    required this.variants,
  });

  factory UserOfferProductDetail.fromJson(Map<String, dynamic> json) {
    // Parse common attributes
    Map<String, String> commonAttrs = {};
    if (json['product_attributes'] != null &&
        json['product_attributes']['common_attributes'] != null) {
      final commonData = json['product_attributes']['common_attributes'];
      commonData.forEach((key, value) {
        commonAttrs[key.toString()] = value.toString();
      });
    }

    // Parse variants
    List<ProductVariant> variantsList = [];
    if (json['product_attributes'] != null &&
        json['product_attributes']['variants'] != null) {
      final variantsData = json['product_attributes']['variants'] as List;
      variantsList = variantsData.map((v) => ProductVariant.fromJson(v)).toList();
    }

    return UserOfferProductDetail(
      id: json['id'] ?? 0,
      merchantId: json['merchant_id']?.toString() ?? '',
      offerName: json['offer_name'] ?? '',
      offerBanner: json['offer_banner'] ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      offerPrice: double.tryParse(json['offer_price']?.toString() ?? '0') ?? 0.0,
      discountPercentage: json['discount_percentage'] ?? 0,
      stockQty: json['stock_qty'] ?? 0,
      productImages: List<String>.from(json['product_images'] ?? []),
      commonAttributes: commonAttrs,
      variants: variantsList,
    );
  }
}

class ProductVariant {
  final Map<String, String> attributes;
  final double price;
  final int stock;

  ProductVariant({
    required this.attributes,
    required this.price,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    Map<String, String> attrs = {};
    if (json['attributes'] != null) {
      final attrsData = json['attributes'];
      attrsData.forEach((key, value) {
        attrs[key.toString()] = value.toString();
      });
    }

    return ProductVariant(
      attributes: attrs,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}