
class CartItem {
  final int id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: int.parse(json['id'].toString()),
      productId: json['product_id'].toString(),
      productName: json['product_name'].toString(),
      productImage: json['product_image'].toString(),
      price: double.parse(json['price'].toString()),
      quantity: int.parse(json['quantity'].toString()),
    );
  }
}
