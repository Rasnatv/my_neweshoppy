//
// class Product {
//   final int productId;
//   final String name;
//   final String description;
//   final Map<String, dynamic> commonAttributes;
//   final List<Variant> variants;
//
//   Product({
//     required this.productId,
//     required this.name,
//     required this.description,
//     required this.commonAttributes,
//     required this.variants,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['product_id'],
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       commonAttributes: json['common_attributes'] ?? {},
//       variants: (json['variants'] as List? ?? [])
//           .map((e) => Variant.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class Variant {
//   int? id;
//   String size;
//   String color;
//   String price;
//   String stock;
//
//   Variant({
//     this.id,
//     required this.size,
//     required this.color,
//     required this.price,
//     required this.stock,
//   });
//
//   factory Variant.fromJson(Map<String, dynamic> json) {
//     return Variant(
//       id: json['id'],
//       size: json['attributes']?['size'] ?? '',
//       color: json['attributes']?['color'] ?? '',
//       price: json['price'].toString(),
//       stock: json['stock'].toString(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) "id": id,
//       "attributes": {
//         "size": size,
//         "color": color,
//       },
//       "price": int.parse(price),
//       "stock": int.parse(stock),
//     };
//   }
// }
