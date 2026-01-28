class WishlistItem {
  final int wishlistId;
  final int productId;
  final String name;
  final String price;
  final String image;

  WishlistItem({
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      wishlistId: json['wishlist_id'],
      productId: json['product_id'],
      name: json['product_name'],
      price: json['price'],
      image: json['image'],
    );
  }
}
