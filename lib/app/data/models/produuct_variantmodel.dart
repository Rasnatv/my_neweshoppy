//
// class ProductVariant {
//   String? title;
//   double? price;
//   int? stock;
//   String? imagePath;
//   Map<String, dynamic> attributes; // Changed from features to attributes for clarity
//
//   ProductVariant({
//     this.title,
//     this.price,
//     this.stock,
//     this.imagePath,
//     Map<String, dynamic>? attributes,
//   }) : attributes = attributes ?? {};
//
//   // Generate a display name from attributes
//   String getDisplayName() {
//     if (title != null && title!.isNotEmpty) return title!;
//
//     List<String> parts = [];
//     attributes.forEach((key, value) {
//       if (value != null && value.toString().isNotEmpty &&
//           key != 'Price' && key != 'Stock') {
//         parts.add(value.toString());
//       }
//     });
//     return parts.isEmpty ? 'Variant' : parts.join(' - ');
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title ?? getDisplayName(),
//       'price': price,
//       'stock': stock,
//       'imagePath': imagePath,
//       'attributes': attributes,
//     };
//   }
// }
class ProductVariant {
  String? title;
  double? price;
  int? stock;
  String? imagePath;
  Map<String, dynamic> attributes;

  ProductVariant({
    this.title,
    this.price,
    this.stock,
    this.imagePath,
    required this.attributes,
  });

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.entries.map((e) => "${e.value}").join(" / ");
  }
}
