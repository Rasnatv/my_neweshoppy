//
// class Product {
//   final int id;
//   final String title;
//   final String description;
//   final double price;
//   final String thumbnail;
//   final double rating;
//   final double? discountPercentage;
//   final int? stock;
//   final String? brand;
//   final String? category; // ✅ Added
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
//     this.category, // ✅ Added
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       price: (json['price'] as num).toDouble(),
//       thumbnail: json['thumbnail'],
//       rating: (json['rating'] as num).toDouble(),
//       discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
//       stock: json['stock'],
//       brand: json['brand'],
//       category: json['category'], // ✅ Added
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
//     'category': category, // ✅ Added
//   };
// }
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;
  double? discountPercentage; // 🔥 OFFER
  final int? stock;
  final String? brand;
  final String? category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    this.discountPercentage,
    this.stock,
    this.brand,
    this.category,
  });

  bool get hasOffer =>
      discountPercentage != null && discountPercentage! > 0;

  double get offerPrice =>
      hasOffer ? price - (price * discountPercentage! / 100) : price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      rating: (json['rating'] as num).toDouble(),
      discountPercentage:
      (json['discountPercentage'] as num?)?.toDouble(),
      stock: json['stock'],
      brand: json['brand'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'thumbnail': thumbnail,
    'rating': rating,
    'discountPercentage': discountPercentage,
    'stock': stock,
    'brand': brand,
    'category': category,
  };
}

