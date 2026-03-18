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

  Map<String, dynamic> toJson() => {
    'status': status,
    'status_code': statusCode,
    'message': message,
    'data': data?.toJson(),
  };
}

class mProductDetail {
  final int productId;
  final String productName;
  final String description;
  final String category;
  final String? merchant;
  final CommonAttributes commonAttributes;
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
    return mProductDetail(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      merchant: json['merchant'],
      commonAttributes: CommonAttributes.fromJson(json['common_attributes'] ?? {}),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((v) => mProductVariant.fromJson(v))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'description': description,
    'category': category,
    'merchant': merchant,
    'common_attributes': commonAttributes.toJson(),
    'variants': variants.map((v) => v.toJson()).toList(),
  };
}

class CommonAttributes {
  final String material;
  final String brand;
  final String type;

  CommonAttributes({
    required this.material,
    required this.brand,
    required this.type,
  });

  factory CommonAttributes.fromJson(Map<String, dynamic> json) {
    return CommonAttributes(
      material: json['material'] ?? '',
      brand: json['brand'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'material': material,
    'brand': brand,
    'type': type,
  };
}

class mProductVariant {
  final int variantId;
  final mVariantAttributes attributes;
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
    return mProductVariant(
      variantId: json['variant_id'] ?? 0,
      attributes: mVariantAttributes.fromJson(json['attributes'] ?? {}),
      price: json['price'] ?? '0.00',
      stock: json['stock'] ?? '0',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'variant_id': variantId,
    'attributes': attributes.toJson(),
    'price': price,
    'stock': stock,
    'image': image,
  };
}

class mVariantAttributes {
  final String colour;
  final String size;

  mVariantAttributes({
    required this.colour,
    required this.size,
  });

  factory mVariantAttributes.fromJson(Map<String, dynamic> json) {
    return mVariantAttributes(
      colour: json['colour'] ?? '',
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'colour': colour,
    'size': size,
  };
}