// class ProductVariant {
//   String? title;
//   double? price;
//   int? stock;
//   String? imagePath;
//   Map<String, String> features;
//
//   ProductVariant({this.title, this.price, this.stock, this.imagePath, required this.features});
// }
//
// class Product {
//   String? name;
//   String? category;
//   List<ProductVariant> variants;
//
//   Product({this.name, this.category, required this.variants});
// }
class ProductVariant {
  String? title;
  double? price;
  int? stock;
  String? imagePath;
  Map<String, dynamic> features;

  ProductVariant({
    this.title,
    this.price,
    this.stock,
    this.imagePath,
    required this.features,
  });
}
