
class UserOfferProductDetail {
  final int id;
  final String merchantId;
  final String productName;
  final String categoryId;
  final String description;
  final double price;
  final double offerPrice;
  final double discountPercentage;
  final int stockQty;
  final List<String> productImages;
  final Map<String, String> commonAttributes;
  final List<ProductVariant> variants;

  UserOfferProductDetail({
    required this.id,
    required this.merchantId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.offerPrice,
    required this.discountPercentage,
    required this.stockQty,
    required this.productImages,
    required this.commonAttributes,
    required this.variants,
  });

  factory UserOfferProductDetail.fromJson(Map<String, dynamic> json) {

    /// ---------- COMMON ATTRIBUTES ----------
    Map<String, String> commonAttrs = {};

    if (json['product_attributes']?['common_attributes'] != null) {
      final data = json['product_attributes']['common_attributes'];

      data.forEach((key, value) {
        commonAttrs[key.toString()] = value.toString();
      });
    }

    /// ---------- VARIANTS ----------
    List<ProductVariant> variantsList = [];

    if (json['product_attributes']?['variants'] != null) {
      variantsList =
          (json['product_attributes']['variants'] as List)
              .map((e) => ProductVariant.fromJson(e))
              .toList();
    }

    return UserOfferProductDetail(
      id: int.tryParse(json['id'].toString()) ?? 0,
      merchantId: json['merchant_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      description: json['description'] ?? '',

      price:
      double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,

      offerPrice:
      double.tryParse(json['offer_price']?.toString() ?? '0') ?? 0.0,

      discountPercentage:
      double.tryParse(json['discount_percentage']?.toString() ?? '0') ?? 0.0,

      stockQty:
      int.tryParse(json['stock_qty']?.toString() ?? '0') ?? 0,

      productImages:
      List<String>.from(json['product_images'] ?? []),

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
      json['attributes'].forEach((key, value) {
        attrs[key.toString()] = value.toString();
      });
    }

    return ProductVariant(
      attributes: attrs,

      price:
      double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,

      stock:
      int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
    );
  }

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}
