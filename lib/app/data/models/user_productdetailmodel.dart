

class ProductDetailModel {
  final int productId;
  final int type;
  final String productName;
  final String description;
  final int categoryId;
  final Map<String, dynamic> commonAttributes;
  final List<ProductVariantModel> variants;

  ProductDetailModel({
    required this.productId,
    required this.type,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final rawAttrs = json['common_attributes'];
    final Map<String, dynamic> commonAttrs =
    (rawAttrs is Map) ? Map<String, dynamic>.from(rawAttrs) : {};

    return ProductDetailModel(
      productId: json['product_id'] ?? 0,
      type: json['type'] ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id'] ?? 0,
      commonAttributes: commonAttrs,
      variants: (json['variants'] as List? ?? [])
          .map<ProductVariantModel>((e) => ProductVariantModel.fromJson(e))
          .toList(),
    );
  }
}

class ProductVariantModel {
  final int variantId;
  final int type;
  final String image;
  final double price;
  final int stock;
  final Map<String, dynamic> attributes;

  ProductVariantModel({
    required this.variantId,
    required this.type,
    required this.image,
    required this.price,
    required this.stock,
    required this.attributes,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final rawAttrs = json['attributes'];
    final Map<String, dynamic> attrs =
    (rawAttrs is Map) ? Map<String, dynamic>.from(rawAttrs) : {};

    return ProductVariantModel(
      variantId: json['variant_id'] ?? 0,
      type: json['type'] ?? 0,
      image: json['image'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
      attributes: attrs,
    );
  }
}
