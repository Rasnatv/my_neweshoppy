
class ProductModel {
  final int productId;
  final String name;
  final String description;
  final CategoryModel category;
  final Map<String, dynamic> commonAttributes;
  final List<VariantModel> variants;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.category,
    required this.commonAttributes,
    required this.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ── FIX 1: common_attributes can be [] (List) when empty ──
    final rawAttrs = json['common_attributes'];
    final Map<String, dynamic> commonAttrs =
    (rawAttrs is Map) ? Map<String, dynamic>.from(rawAttrs) : {};

    return ProductModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: CategoryModel.fromJson(
          json['category'] as Map<String, dynamic>),
      commonAttributes: commonAttrs,
      variants: (json['variants'] as List)
          .map((v) => VariantModel.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── CategoryModel ─────────────────────────────────────────────────────────────
class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

// ── VariantModel ──────────────────────────────────────────────────────────────
class VariantModel {
  final int id;
  final Map<String, dynamic> attributes;
  final double price;
  final int stock;
  final String? image;

  VariantModel({
    required this.id,
    required this.attributes,
    required this.price,
    required this.stock,
    this.image,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
    id: json['id'] as int,
    attributes: Map<String, dynamic>.from(
        json['attributes'] as Map),
    // ── FIX 2: price comes as String "120.00" from API ──
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    stock: json['stock'] as int,
    image: json['image'] as String?,
  );
}
