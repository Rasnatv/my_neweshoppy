
class WishlistItem {
  final int wishlistId;
  final int productId;
  final String name;
  final String? image;
  final int type; // 0 = normal product, 1 = offer product

  // type 0 — normal product
  final String price;

  // type 1 — offer product only
  final String? originalPrice;
  final String? offerPrice;

  WishlistItem({
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.image,
    required this.type,
    required this.price,
    this.originalPrice,
    this.offerPrice,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    final int type = json['type'] ?? 0;

    return WishlistItem(
      wishlistId: json['wishlist_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['product_name'] ?? '',
      image: json['image'],
      type: type,

      // ✅ type 0 → "price" field | type 1 → "offer_price" field
      price: type == 0
          ? (json['price'] ?? '0').toString()
          : (json['offer_price'] ?? '0').toString(),

      // ✅ only for offer products
      originalPrice: type == 1
          ? (json['original_price'] ?? '0').toString()
          : null,
      offerPrice: type == 1
          ? (json['offer_price'] ?? '0').toString()
          : null,
    );
  }
}
