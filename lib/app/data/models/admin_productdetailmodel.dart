
class ProductVariant {
  final Map<String, dynamic> attributes;
  final double price;
  final double finalPrice;
  final int stock;
  final String image;

  ProductVariant({
    required this.attributes,
    required this.price,
    required this.finalPrice,
    required this.stock,
    required this.image,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      finalPrice: (json['final_price'] is num)
          ? (json['final_price'] as num).toDouble()
          : double.tryParse(json['final_price'].toString()) ?? 0.0,
      stock: (json['stock'] is int)
          ? json['stock'] as int
          : int.tryParse(json['stock'].toString()) ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }

  String get displayName {
    if (attributes.isEmpty) return 'Variant';
    return attributes.values.join(' - ');
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
  final ProductAttributes? productAttributes;
  final String? features;

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
    this.productAttributes,
    this.features,
  });

  // ── Computed getters from variants ─────────────────────────
  List<String> get productImages =>
      productAttributes?.variants
          .map((v) => v.image)
          .where((img) => img.isNotEmpty)
          .toList() ??
          [];

  int get totalStock =>
      productAttributes?.variants
          .fold(0, (sum, v) => sum! + v.stock) ??
          0;

  double get originalPrice =>
      productAttributes?.variants.isNotEmpty == true
          ? productAttributes!.variants.first.price
          : 0.0;

  double get offerPrice =>
      productAttributes?.variants.isNotEmpty == true
          ? productAttributes!.variants.first.finalPrice
          : 0.0;

  factory AdminSingleOfferProductModel.fromJson(
      Map<String, dynamic> json) {
    return AdminSingleOfferProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      offerId: json['offer_id'] is int
          ? json['offer_id'] as int
          : int.tryParse(json['offer_id'].toString()) ?? 0,
      offerName: json['offer_name']?.toString() ?? '',
      discountPercentage:
      json['discount_percentage']?.toString() ?? '0',
      merchantId: json['merchant_id']?.toString() ?? '',
      merchantName: json['merchant_name']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      productAttributes: json['product_attributes'] != null
          ? ProductAttributes.fromJson(
          json['product_attributes'] as Map<String, dynamic>)
          : null,
      features: json['features']?.toString(),
    );
  }
}
// admin_productdetailmodel.dart
//
// class AdminSingleOfferProductModel {
//   final int id;
//   final int offerId;
//   final String offerName;
//   final String discountPercentage;
//   final int merchantId;
//   final String merchantName;
//   final String productName;
//   final String description;
//   final int categoryId;
//   final ProductAttributes? productAttributes;
//
//   AdminSingleOfferProductModel({
//     required this.id,
//     required this.offerId,
//     required this.offerName,
//     required this.discountPercentage,
//     required this.merchantId,
//     required this.merchantName,
//     required this.productName,
//     required this.description,
//     required this.categoryId,
//     this.productAttributes,
//   });
//
//   // ✅ Images come from variants — there is no top-level product_images in the API
//   List<String> get productImages =>
//       productAttributes?.variants
//           .map((v) => v.image)
//           .where((img) => img.isNotEmpty)
//           .toList() ??
//           [];
//
//   factory AdminSingleOfferProductModel.fromJson(Map<String, dynamic> j) {
//     return AdminSingleOfferProductModel(
//       id:                   (j['id'] as num).toInt(),
//       offerId:              (j['offer_id'] as num).toInt(),
//       offerName:            j['offer_name']?.toString() ?? '',
//       discountPercentage:   j['discount_percentage']?.toString() ?? '0',
//       merchantId:           (j['merchant_id'] as num).toInt(),
//       merchantName:         j['merchant_name']?.toString() ?? '',
//       productName:          j['product_name']?.toString() ?? '',
//       description:          j['description']?.toString() ?? '',
//       categoryId:           (j['category_id'] as num).toInt(),
//       productAttributes: j['product_attributes'] == null
//           ? null
//           : ProductAttributes.fromJson(
//           j['product_attributes'] as Map<String, dynamic>),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// class ProductAttributes {
//   final Map<String, dynamic> commonAttributes;
//   final List<ProductVariant> variants;
//
//   ProductAttributes({
//     required this.commonAttributes,
//     required this.variants,
//   });
//
//   factory ProductAttributes.fromJson(Map<String, dynamic> j) {
//     return ProductAttributes(
//       commonAttributes: (j['common_attributes'] is Map)
//           ? Map<String, dynamic>.from(j['common_attributes'] as Map)
//           : {},
//       variants: (j['variants'] as List? ?? [])
//           .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// class ProductVariant {
//   final Map<String, dynamic> attributes;
//   final double price;
//   final int stock;
//   final String image;
//   final double finalPrice;
//
//   ProductVariant({
//     required this.attributes,
//     required this.price,
//     required this.stock,
//     required this.image,
//     required this.finalPrice,
//   });
//
//   factory ProductVariant.fromJson(Map<String, dynamic> j) {
//     return ProductVariant(
//       attributes: (j['attributes'] is Map)
//           ? Map<String, dynamic>.from(j['attributes'] as Map)
//           : {},
//       price:      (j['price'] as num).toDouble(),
//       stock:      (j['stock'] as num).toInt(),
//       image:      j['image']?.toString() ?? '',
//       finalPrice: (j['final_price'] as num).toDouble(),
//     );
//   }
// }
