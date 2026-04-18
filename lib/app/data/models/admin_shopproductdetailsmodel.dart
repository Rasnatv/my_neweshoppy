//
// class mAdminProductDetailModel {
//   final bool status;
//   final int statusCode;
//   final String message;
//   final mProductDetail? data;
//
//   mAdminProductDetailModel({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     this.data,
//   });
//
//   factory mAdminProductDetailModel.fromJson(Map<String, dynamic> json) {
//     return mAdminProductDetailModel(
//       status: json['status'] ?? false,
//       statusCode: json['status_code'] ?? 0,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? mProductDetail.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'status_code': statusCode,
//     'message': message,
//     'data': data?.toJson(),
//   };
// }
//
// class mProductDetail {
//   final int productId;
//   final String productName;
//   final String description;
//   final String category;
//   final String? merchant;
//   final CommonAttributes commonAttributes;
//   final List<mProductVariant> variants;
//
//   mProductDetail({
//     required this.productId,
//     required this.productName,
//     required this.description,
//     required this.category,
//     this.merchant,
//     required this.commonAttributes,
//     required this.variants,
//   });
//
//   factory mProductDetail.fromJson(Map<String, dynamic> json) {
//     return mProductDetail(
//       productId: json['product_id'] is int
//           ? json['product_id']
//           : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
//       productName: json['product_name']?.toString() ?? '',
//       description: json['description']?.toString() ?? '',
//       category: json['category']?.toString() ?? '',
//       merchant: json['merchant']?.toString(),
//       commonAttributes:
//       CommonAttributes.fromJson(json['common_attributes'] ?? {}),
//       variants: (json['variants'] as List<dynamic>?)
//           ?.map((v) => mProductVariant.fromJson(v))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'product_id': productId,
//     'product_name': productName,
//     'description': description,
//     'category': category,
//     'merchant': merchant,
//     'common_attributes': commonAttributes.toJson(),
//     'variants': variants.map((v) => v.toJson()).toList(),
//   };
// }
//
// class CommonAttributes {
//   final String material;
//   final String brand;
//   final String type;
//
//   CommonAttributes({
//     required this.material,
//     required this.brand,
//     required this.type,
//   });
//
//   factory CommonAttributes.fromJson(Map<String, dynamic> json) {
//     return CommonAttributes(
//       material: json['material']?.toString() ?? '',
//       brand: json['brand']?.toString() ?? '',
//       type: json['type']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'material': material,
//     'brand': brand,
//     'type': type,
//   };
// }
//
// class mProductVariant {
//   final int variantId;
//   final mVariantAttributes attributes;
//   final String price;
//   final String stock;
//   final String image;
//
//   mProductVariant({
//     required this.variantId,
//     required this.attributes,
//     required this.price,
//     required this.stock,
//     required this.image,
//   });
//
//   factory mProductVariant.fromJson(Map<String, dynamic> json) {
//     return mProductVariant(
//       variantId: json['variant_id'] is int
//           ? json['variant_id']
//           : int.tryParse(json['variant_id']?.toString() ?? '0') ?? 0,
//       attributes: mVariantAttributes.fromJson(json['attributes'] ?? {}),
//       // ✅ Safe conversion: handles int, double, or String from API
//       price: json['price']?.toString() ?? '0.00',
//       stock: json['stock']?.toString() ?? '0',
//       image: json['image']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'variant_id': variantId,
//     'attributes': attributes.toJson(),
//     'price': price,
//     'stock': stock,
//     'image': image,
//   };
// }
//
// class mVariantAttributes {
//   final String colour;
//   final String size;
//
//   mVariantAttributes({
//     required this.colour,
//     required this.size,
//   });
//
//   factory mVariantAttributes.fromJson(Map<String, dynamic> json) {
//     return mVariantAttributes(
//       colour: json['colour']?.toString() ?? '',
//       size: json['size']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'colour': colour,
//     'size': size,
//   };
// }
class mAdminProductDetailModel {
  final bool status;
  final int statusCode;
  final String message;
  final mProductDetail? data;

  mAdminProductDetailModel({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory mAdminProductDetailModel.fromJson(Map<String, dynamic> json) {
    return mAdminProductDetailModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? mProductDetail.fromJson(json['data']) : null,
    );
  }
}

class mProductDetail {
  final int productId;
  final String productName;
  final String description;
  final String category;
  final String? merchant;
  final Map<String, String> commonAttributes; // ← dynamic
  final List<mProductVariant> variants;

  mProductDetail({
    required this.productId,
    required this.productName,
    required this.description,
    required this.category,
    this.merchant,
    required this.commonAttributes,
    required this.variants,
  });

  factory mProductDetail.fromJson(Map<String, dynamic> json) {
    // Safely handle both [] and {}
    Map<String, String> commonAttrs = {};
    final raw = json['common_attributes'];
    if (raw != null && raw is Map) {
      raw.forEach((k, v) => commonAttrs[k.toString()] = v?.toString() ?? '');
    }

    return mProductDetail(
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      merchant: json['merchant']?.toString(),
      commonAttributes: commonAttrs,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((v) => mProductVariant.fromJson(v))
          .toList() ??
          [],
    );
  }
}

class mProductVariant {
  final int variantId;
  final Map<String, String> attributes; // ← dynamic
  final String price;
  final String stock;
  final String image;

  mProductVariant({
    required this.variantId,
    required this.attributes,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory mProductVariant.fromJson(Map<String, dynamic> json) {
    Map<String, String> attrs = {};
    final raw = json['attributes'];
    if (raw != null && raw is Map) {
      raw.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty) {
          attrs[k.toString()] = v.toString();
        }
      });
    }

    return mProductVariant(
      variantId: int.tryParse(json['variant_id']?.toString() ?? '0') ?? 0,
      attributes: attrs,
      price: json['price']?.toString() ?? '0.00',
      stock: json['stock']?.toString() ?? '0',
      image: json['image']?.toString() ?? '',
    );
  }
}
