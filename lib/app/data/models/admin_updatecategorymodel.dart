class CategoryModel {
  final int id;
  final String name;
  final String image;
  final CategoryAttributes attributes;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.attributes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      attributes: CategoryAttributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'attributes': attributes.toJson(),
    };
  }
}

class CategoryAttributes {
  final List<String> common;
  final List<String> variant;

  CategoryAttributes({
    required this.common,
    required this.variant,
  });

  factory CategoryAttributes.fromJson(Map<String, dynamic> json) {
    return CategoryAttributes(
      common: List<String>.from(json['common'] ?? []),
      variant: List<String>.from(json['variant'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'common': common,
      'variant': variant,
    };
  }
}

// ── Response wrapper ─────────────────────────────────────────────────────────

class GetCategoryResponse {
  final bool status;
  final int statusCode;
  final String message;
  final CategoryModel? data;

  GetCategoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory GetCategoryResponse.fromJson(Map<String, dynamic> json) {
    return GetCategoryResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null ? CategoryModel.fromJson(json['data']) : null,
    );
  }
}

class UpdateCategoryResponse {
  final bool status;
  final int statusCode;
  final String message;
  final CategoryModel? data;

  UpdateCategoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UpdateCategoryResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCategoryResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null ? CategoryModel.fromJson(json['data']) : null,
    );
  }
}