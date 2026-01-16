// class AdminCategoryModel {
//   final int id;
//   final String name;
//   final String image;
//   final List<String> attributes;
//
//   AdminCategoryModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.attributes,
//   });
//
//   factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
//     return AdminCategoryModel(
//       id: json['id'],
//       name: json['name'],
//       image: json['image'],
//       attributes: List<String>.from(json['attributes']),
//     );
//   }
// }
class AdminCategoryModel {
  final int id;
  final String name;
  final String image;

  final List<String> commonAttributes;
  final List<String> variantAttributes;
  final List<String> legacyAttributes;

  AdminCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.commonAttributes,
    required this.variantAttributes,
    required this.legacyAttributes,
  });

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'];

    List<String> common = [];
    List<String> variant = [];
    List<String> legacy = [];

    if (attrs is Map<String, dynamic>) {
      common = List<String>.from(attrs['common'] ?? []);
      variant = List<String>.from(attrs['variant'] ?? []);
    } else if (attrs is List) {
      legacy = List<String>.from(attrs);
    }

    return AdminCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      commonAttributes: common,
      variantAttributes: variant,
      legacyAttributes: legacy,
    );
  }
}
