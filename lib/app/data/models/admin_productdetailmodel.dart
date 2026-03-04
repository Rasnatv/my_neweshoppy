class ProductVariant {
  final Map<String, dynamic> attributes;
  final double price;
  final int stock;

  ProductVariant({
    required this.attributes,
    required this.price,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      stock: (json['stock'] is int)
          ? json['stock'] as int
          : int.tryParse(json['stock'].toString()) ?? 0,
    );
  }
}

class ProductAttributes {
  final Map<String, dynamic> commonAttributes;
  final List<ProductVariant> variants;

  ProductAttributes({
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    return ProductAttributes(
      commonAttributes:
      Map<String, dynamic>.from(json['common_attributes'] ?? {}),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AdminSingleOfferProductModel {
  final int id;
  final int offerId;
  final String offerName;
  final String discountPercentage;
  final String merchantId;
  final String merchantName;
  final String productName;
  final String description;
  final String categoryId;
  final String stockQty;
  final String originalPrice;
  final double offerPrice;
  final List<String> productImages;
  final ProductAttributes? productAttributes;
  final String? features;
  final String createdAt;
  final String updatedAt;

  AdminSingleOfferProductModel({
    required this.id,
    required this.offerId,
    required this.offerName,
    required this.discountPercentage,
    required this.merchantId,
    required this.merchantName,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.stockQty,
    required this.originalPrice,
    required this.offerPrice,
    required this.productImages,
    this.productAttributes,
    this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminSingleOfferProductModel.fromJson(Map<String, dynamic> json) {
    return AdminSingleOfferProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      offerId: json['offer_id'] is int
          ? json['offer_id'] as int
          : int.tryParse(json['offer_id'].toString()) ?? 0,
      offerName: json['offer_name']?.toString() ?? '',
      discountPercentage: json['discount_percentage']?.toString() ?? '0',
      merchantId: json['merchant_id']?.toString() ?? '',
      merchantName: json['merchant_name']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      stockQty: json['stock_qty']?.toString() ?? '0',
      originalPrice: json['original_price']?.toString() ?? '0',
      offerPrice: (json['offer_price'] is num)
          ? (json['offer_price'] as num).toDouble()
          : double.tryParse(json['offer_price'].toString()) ?? 0.0,
      productImages: (json['product_images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      productAttributes: json['product_attributes'] != null
          ? ProductAttributes.fromJson(
          json['product_attributes'] as Map<String, dynamic>)
          : null,
      features: json['features']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}