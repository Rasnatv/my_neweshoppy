class ProductDetailModel {
  final int productId;
  final String productName;
  final String description;
  final Map<String, dynamic> commonAttributes;
  final List<ProductVariantModel> variants;

  ProductDetailModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productId: json['product_id'],
      productName: json['product_name'],
      description: json['description'] ?? '',
      commonAttributes: json['common_attributes'] ?? {},
      variants: (json['variants'] as List)
          .map((e) => ProductVariantModel.fromJson(e))
          .toList(),
    );
  }
}

class ProductVariantModel {
  final int variantId;
  final String image;
  final String price;
  final String stock;
  final Map<String, dynamic> attributes;

  ProductVariantModel({
    required this.variantId,
    required this.image,
    required this.price,
    required this.stock,
    required this.attributes,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variant_id'],
      image: json['image'],
      price: json['price'],
      stock: json['stock'],
      attributes: json['attributes'] ?? {},
    );
  }
}

