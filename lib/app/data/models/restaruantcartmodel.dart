// lib/app/data/models/restaurantcartmodel.dart

class RestaurantCartModel {
  final int id;
  final int userId;
  final int restaurantId;
  final int menuId;
  final String itemName;
  final String image;
  final double price;
  final int quantity;
  final double totalPrice;
  final String createdAt;
  final String updatedAt;

  RestaurantCartModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.menuId,
    required this.itemName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantCartModel.fromJson(Map<String, dynamic> json) {
    return RestaurantCartModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      restaurantId:
      int.tryParse(json['restaurant_id']?.toString() ?? '0') ?? 0,
      menuId: int.tryParse(json['menu_id']?.toString() ?? '0') ?? 0,
      itemName: json['item_name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      totalPrice:
      double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'menu_id': menuId,
      'item_name': itemName,
      'image': image,
      'price': price,
      'quantity': quantity,
      'total_price': totalPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  RestaurantCartModel copyWith({
    int? id,
    int? userId,
    int? restaurantId,
    int? menuId,
    String? itemName,
    String? image,
    double? price,
    int? quantity,
    double? totalPrice,
    String? createdAt,
    String? updatedAt,
  }) {
    return RestaurantCartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      menuId: menuId ?? this.menuId,
      itemName: itemName ?? this.itemName,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}