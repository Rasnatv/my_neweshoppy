
class WishlistItem {
  final int wishlistId;
  final int productId;
  final int type;
  final String name;
  final String? image;
  final String price;          // type 0 → price | type 1 → offer_price
  final String? originalPrice; // type 1 only
  final String? offerPrice;    // type 1 only

  WishlistItem({
    required this.wishlistId,
    required this.productId,
    required this.type,
    required this.name,
    this.image,
    required this.price,
    this.originalPrice,
    this.offerPrice,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    final int type = json['type'] ?? 0;

    // ✅ type 0 uses 'price', type 1 uses 'offer_price' as main price
    final String price = type == 1
        ? (json['offer_price']?.toString() ?? '0')
        : (json['price']?.toString() ?? '0');

    return WishlistItem(
      wishlistId:    json['wishlist_id'] ?? 0,
      productId:     json['product_id'] ?? 0,
      type:          type,
      name:          json['product_name'] ?? '',   // ✅ API sends 'product_name'
      image:         json['image'],
      price:         price,
      originalPrice: json['original_price']?.toString(),
      offerPrice:    json['offer_price']?.toString(),
    );
  }
}