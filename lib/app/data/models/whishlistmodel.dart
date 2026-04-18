
class WishlistItem {
  final int wishlistId;
  final int productId;
  final String name;
  final String price;
  final String? image; // nullable

  WishlistItem({
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.price,
    this.image,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      wishlistId: json['wishlist_id'] as int,
      productId: json['product_id'] as int,
      name: (json['product_name'] ?? 'Unknown') as String,
      price: (json['price'] ?? '0.00') as String,
      image: json['image'] as String?,
    );
  }
}
