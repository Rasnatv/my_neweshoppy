class OfferProductVariant {
  final Map<String, String> attributes;
  final double price;
  final int stock;

  OfferProductVariant({
    required this.attributes,
    required this.price,
    required this.stock,
  });

  factory OfferProductVariant.fromJson(Map<String, dynamic> json) {
    final rawAttrs = json['attributes'] as Map<String, dynamic>? ?? {};
    return OfferProductVariant(
      attributes: rawAttrs.map((k, v) => MapEntry(k, v.toString())),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
    );
  }
}

class ProductAttributes {
  final Map<String, String> commonAttributes;
  final List<OfferProductVariant> variants;

  ProductAttributes({
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    final rawCommon =
        json['common_attributes'] as Map<String, dynamic>? ?? {};
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
  final int offerProductId;
  final String productName;
  final String description;
  final String categoryId;
  final double price;
  final double offerPrice;
  final double discountPercentage;
  final int stockQty;
  final List<String> productImages;
  final ProductAttributes productAttributes;
  final List<dynamic> features;

  MerchantOfferProductDetailModel({
    required this.offerProductId,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.offerPrice,
    required this.discountPercentage,
    required this.stockQty,
    required this.productImages,
    required this.productAttributes,
    required this.features,
  });

  double get savedAmount => price - offerPrice;

  factory MerchantOfferProductDetailModel.fromJson(
      Map<String, dynamic> json) {
    return MerchantOfferProductDetailModel(
      offerProductId:
      int.tryParse(json['offer_product_id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      offerPrice: double.tryParse(json['offer_price'].toString()) ?? 0.0,
      discountPercentage:
      double.tryParse(json['discount_percentage'].toString()) ?? 0.0,
      stockQty: int.tryParse(json['stock_qty'].toString()) ?? 0,
      productImages: (json['product_images'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      productAttributes: ProductAttributes.fromJson(
          json['product_attributes'] as Map<String, dynamic>? ?? {}),
      features: json['features'] as List? ?? [],
    );
  }
}