class CategoryApiModel {
  final int id;
  final String name;
  final String image;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  CategoryApiModel({
    required this.id,
    required this.name,
    required this.image,
    required this.commonAttributes,
    required this.variantAttributes,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      commonAttributes:
      List<String>.from(json['attributes']?['common'] ?? []),
      variantAttributes:
      List<String>.from(json['attributes']?['variant'] ?? []),
    );
  }
}

class CategoryConfig {
  final int id;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  CategoryConfig({
    required this.id,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}
