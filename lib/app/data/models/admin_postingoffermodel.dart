// lib/data/models/offer_models.dart

// ── Create Offer API response ─────────────────────────────────────────────────

class CreateOfferResponse {
  final int status;
  final String message;
  final CreateOfferData? data;

  CreateOfferResponse({required this.status, required this.message, this.data});

  factory CreateOfferResponse.fromJson(Map<String, dynamic> json) {
    return CreateOfferResponse(
      status: int.tryParse(json['status'].toString()) ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CreateOfferData.fromJson(json['data']) : null,
    );
  }
}

class CreateOfferData {
  final int offerId;
  final double discountPercentage;
  final String offerBanner;

  CreateOfferData({
    required this.offerId,
    required this.discountPercentage,
    required this.offerBanner,
  });

  factory CreateOfferData.fromJson(Map<String, dynamic> json) {
    return CreateOfferData(
      offerId: json['offer_id'] ?? 0,
      discountPercentage: double.tryParse(json['discount_percentage'].toString()) ?? 0.0,
      offerBanner: json['offer_banner'] ?? '',
    );
  }
}

// ── Add Offer Products API response ──────────────────────────────────────────

class AddOfferProductsResponse {
  final int status;
  final String message;
  final List<AddedOfferProduct> data;

  AddOfferProductsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddOfferProductsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    return AddOfferProductsResponse(
      status: int.tryParse(json['status'].toString()) ?? 0,
      message: json['message'] ?? '',
      data: rawList
          .map((e) => AddedOfferProduct.fromJson(e['product'] as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AddedOfferProduct {
  final int id;
  final int offerId;
  final int productId;
  final String name;
  final String? description;
  final int categoryId;
  final double price;
  final double discountAmount;
  final double finalPrice;
  final List<String> images;
  final Map<String, dynamic> commonAttributes;
  final List<AddedOfferVariant> variants;

  AddedOfferProduct({
    required this.id,
    required this.offerId,
    required this.productId,
    required this.name,
    this.description,
    required this.categoryId,
    required this.price,
    required this.discountAmount,
    required this.finalPrice,
    required this.images,
    required this.commonAttributes,
    required this.variants,
  });

  factory AddedOfferProduct.fromJson(Map<String, dynamic> json) {
    return AddedOfferProduct(
      id: json['id'] ?? 0,
      offerId: json['offer_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      categoryId: json['category_id'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      discountAmount: double.tryParse(json['discount_amount'].toString()) ?? 0.0,
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      commonAttributes: (json['common_attributes'] as Map<String, dynamic>?) ?? {},
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => AddedOfferVariant.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AddedOfferVariant {
  final Map<String, String> attributes;
  final double price;
  final int stock;

  AddedOfferVariant({required this.attributes, required this.price, required this.stock});

  factory AddedOfferVariant.fromJson(Map<String, dynamic> json) {
    return AddedOfferVariant(
      attributes: (json['attributes'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }
}

// ── Local UI variant model ────────────────────────────────────────────────────

class OfferProductVariant {
  Map<String, String> attributes;
  double? price;
  int? stock;
  String? imagePath;
  String? imageBase64;

  OfferProductVariant({
    required this.attributes,
    this.price,
    this.stock,
    this.imagePath,
    this.imageBase64,
  });

  String getDisplayName() {
    if (attributes.isEmpty) return 'Variant';
    return attributes.entries.map((e) => '${e.key}: ${e.value}').join(' · ');
  }

  double? computeOfferPrice(double discountPercentage) {
    if (price == null || price! <= 0) return null;
    return price! - (price! * discountPercentage / 100);
  }
}

// ── Category config (defines attributes per category) ────────────────────────

class CategoryConfig {
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  CategoryConfig({required this.commonAttributes, required this.variantAttributes});
}

// ── API Category model ────────────────────────────────────────────────────────

class ApiCategory {
  final int id;
  final String name;

  ApiCategory({required this.id, required this.name});

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}