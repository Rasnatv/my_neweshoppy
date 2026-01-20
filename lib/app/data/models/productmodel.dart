//
// class Product {
//   final int id;
//   final String title;
//   final String description;
//   final double price;
//   final String thumbnail;
//   final double rating;
//   double? discountPercentage; // 🔥 OFFER
//   final int? stock;
//   final String? brand;
//   final String? category;
//
//   Product({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.thumbnail,
//     required this.rating,
//     this.discountPercentage,
//     this.stock,
//     this.brand,
//     this.category,
//   });
//
//   bool get hasOffer =>
//       discountPercentage != null && discountPercentage! > 0;
//
//   double get offerPrice =>
//       hasOffer ? price - (price * discountPercentage! / 100) : price;
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       price: (json['price'] as num).toDouble(),
//       thumbnail: json['thumbnail'],
//       rating: (json['rating'] as num).toDouble(),
//       discountPercentage:
//       (json['discountPercentage'] as num?)?.toDouble(),
//       stock: json['stock'],
//       brand: json['brand'],
//       category: json['category'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'description': description,
//     'price': price,
//     'thumbnail': thumbnail,
//     'rating': rating,
//     'discountPercentage': discountPercentage,
//     'stock': stock,
//     'brand': brand,
//     'category': category,
//   };
// }
//
class Product {
  final int productId;
  final String name;
  final String description;
  final Map<String, dynamic> commonAttributes;
  final List<Variant> variants;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.commonAttributes,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      commonAttributes: json['common_attributes'] ?? {},
      variants: (json['variants'] as List? ?? [])
          .map((e) => Variant.fromJson(e))
          .toList(),
    );
  }
}

class Variant {
  int? id;
  String size;
  String color;
  String price;
  String stock;

  Variant({
    this.id,
    required this.size,
    required this.color,
    required this.price,
    required this.stock,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      size: json['attributes']?['size'] ?? '',
      color: json['attributes']?['color'] ?? '',
      price: json['price'].toString(),
      stock: json['stock'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "attributes": {
        "size": size,
        "color": color,
      },
      "price": int.parse(price),
      "stock": int.parse(stock),
    };
  }
}
