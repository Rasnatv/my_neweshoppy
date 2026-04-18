class NProductDetailModel {
  final bool status;
  final int statusCode;
  final ProductData data;

  NProductDetailModel({
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory NProductDetailModel.fromJson(Map<String, dynamic> json) {
    return NProductDetailModel(
      status: json['status'],
      statusCode: json['status_code'],
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final int productId;
  final String name;
  final String description;
  final Category category;
  final CommonAttributes commonAttributes;
  final List<Variant> variants;

  ProductData({
    required this.productId,
    required this.name,
    required this.description,
    required this.category,
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      commonAttributes:
      CommonAttributes.fromJson(json['common_attributes']),
      variants: (json['variants'] as List)
          .map((e) => Variant.fromJson(e))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CommonAttributes {
  String brand;
  String material;
  String gender;

  CommonAttributes({
    required this.brand,
    required this.material,
    required this.gender,
  });

  factory CommonAttributes.fromJson(Map<String, dynamic> json) {
    return CommonAttributes(
      brand: json['brand'],
      material: json['material'],
      gender: json['gender'],
    );
  }
}

class Variant {
  int? id;
  Map<String, dynamic> attributes;
  String price;
  int stock;
  String image;

  Variant({
    this.id,
    required this.attributes,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      attributes: json['attributes'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
    );
  }
}