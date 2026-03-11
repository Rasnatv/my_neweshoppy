// ── CART MODEL ─────────────────────────────────────────────────────────────────
// File: lib/models/cart_model.dart

class MainCartItemModel {
  final String itemName;
  final String image;
  final double price;
  final int quantity;
  final double totalPrice;

  MainCartItemModel({
    required this.itemName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory MainCartItemModel.fromJson(Map<String, dynamic> json) {
    return MainCartItemModel(
      itemName: json['item_name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'item_name': itemName,
    'image': image,
    'price': price,
    'quantity': quantity,
    'total_price': totalPrice,
  };
}

class MainCartRestaurantModel {
  final int restaurantId;
  final String restaurantName;
  final String restaurantLocation;
  final double subtotal;
  final List<MainCartItemModel> items;

  MainCartRestaurantModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLocation,
    required this.subtotal,
    required this.items,
  });

  factory MainCartRestaurantModel.fromJson(Map<String, dynamic> json) {
    return MainCartRestaurantModel(
      restaurantId: json['restaurant_id'] ?? 0,
      restaurantName: json['restaurant_name'] ?? '',
      restaurantLocation: json['restaurant_location'] ?? '',
      subtotal: (json['subtotal'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((item) => MainCartItemModel.fromJson(item))
          .toList(),
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get tax => subtotal * 0.05;
  double get total => subtotal + tax;
}

class MainCartResponseModel {
  final int status;
  final String message;
  final List<MainCartRestaurantModel> restaurants;
  final double grandTotal;

  MainCartResponseModel({
    required this.status,
    required this.message,
    required this.restaurants,
    required this.grandTotal,
  });

  factory MainCartResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MainCartResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      restaurants: (data['restaurants'] as List<dynamic>)
          .map((r) => MainCartRestaurantModel.fromJson(r))
          .toList(),
      grandTotal: (data['grand_total'] as num).toDouble(),
    );
  }

  int get totalItemCount =>
      restaurants.fold(0, (sum, r) => sum + r.itemCount);
}