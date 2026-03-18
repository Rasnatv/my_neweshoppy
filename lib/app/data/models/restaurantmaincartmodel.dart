// // ── CART MODEL ─────────────────────────────────────────────────────────────────
// // File: lib/models/cart_model.dart
//
// class MainCartItemModel {
//   final String itemName;
//   final String image;
//   final double price;
//   final int quantity;
//   final double totalPrice;
//
//   MainCartItemModel({
//     required this.itemName,
//     required this.image,
//     required this.price,
//     required this.quantity,
//     required this.totalPrice,
//   });
//
//   factory MainCartItemModel.fromJson(Map<String, dynamic> json) {
//     return MainCartItemModel(
//       itemName: json['item_name'] ?? '',
//       image: json['image'] ?? '',
//       price: (json['price'] as num).toDouble(),
//       quantity: json['quantity'] ?? 1,
//       totalPrice: (json['total_price'] as num).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'item_name': itemName,
//     'image': image,
//     'price': price,
//     'quantity': quantity,
//     'total_price': totalPrice,
//   };
// }
//
// class MainCartRestaurantModel {
//   final int restaurantId;
//   final String restaurantName;
//   final String restaurantLocation;
//   final double subtotal;
//   final List<MainCartItemModel> items;
//
//   MainCartRestaurantModel({
//     required this.restaurantId,
//     required this.restaurantName,
//     required this.restaurantLocation,
//     required this.subtotal,
//     required this.items,
//   });
//
//   factory MainCartRestaurantModel.fromJson(Map<String, dynamic> json) {
//     return MainCartRestaurantModel(
//       restaurantId: json['restaurant_id'] ?? 0,
//       restaurantName: json['restaurant_name'] ?? '',
//       restaurantLocation: json['restaurant_location'] ?? '',
//       subtotal: (json['subtotal'] as num).toDouble(),
//       items: (json['items'] as List<dynamic>)
//           .map((item) => MainCartItemModel.fromJson(item))
//           .toList(),
//     );
//   }
//
//   int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
//
//   double get tax => subtotal * 0.05;
//   double get total => subtotal + tax;
// }
//
// class MainCartResponseModel {
//   final int status;
//   final String message;
//   final List<MainCartRestaurantModel> restaurants;
//   final double grandTotal;
//
//   MainCartResponseModel({
//     required this.status,
//     required this.message,
//     required this.restaurants,
//     required this.grandTotal,
//   });
//
//   factory MainCartResponseModel.fromJson(Map<String, dynamic> json) {
//     final data = json['data'] as Map<String, dynamic>;
//     return MainCartResponseModel(
//       status: json['status'] ?? 0,
//       message: json['message'] ?? '',
//       restaurants: (data['restaurants'] as List<dynamic>)
//           .map((r) => MainCartRestaurantModel.fromJson(r))
//           .toList(),
//       grandTotal: (data['grand_total'] as num).toDouble(),
//     );
//   }
//
//   int get totalItemCount =>
//       restaurants.fold(0, (sum, r) => sum + r.itemCount);
// }
// ── restaurantmaincartmodel.dart ─────────────────────────────────────────────
// Matches: POST /restaurant/final-cart
// Response shape:
// {
//   "status": 1,
//   "message": "...",
//   "data": {
//     "restaurant":      { restaurant_id, restaurant_name, address },
//     "booking_details": { booking_id, booking_date, time_slot, table_no,
//                          guests, meal_type, seating_type },
//     "cart_items":      [ { id, user_id, restaurant_id, menu_id, item_name,
//                            image, price, quantity, total_price, ... } ],
//     "grand_total": 405
//   }
// }
// ─────────────────────────────────────────────────────────────────────────────
// ── restaurantmaincartmodel.dart ──────────────────────────────────────────────

// ── restaurantmaincartmodel.dart ──────────────────────────────────────────────
// ── restaurant_finalcart_model.dart ──────────────────────────────────────────

class FinalCartResponseModel {
  final int status;
  final String message;
  final List<FinalCartRestaurantModel> data;

  FinalCartResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FinalCartResponseModel.fromJson(Map<String, dynamic> json) {
    return FinalCartResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FinalCartRestaurantModel.fromJson(e))
          .toList(),
    );
  }
}

class FinalCartRestaurantModel {
  final int restaurantId;
  final String restaurantName;
  final String restaurantLocation;
  final List<FinalCartBookingModel> bookings;

  FinalCartRestaurantModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLocation,
    required this.bookings,
  });

  factory FinalCartRestaurantModel.fromJson(Map<String, dynamic> json) {
    return FinalCartRestaurantModel(
      restaurantId: int.tryParse(json['restaurant_id'].toString()) ?? 0,
      restaurantName: json['restaurant_name'] ?? '',
      restaurantLocation: json['restaurant_location'] ?? '',
      bookings: (json['bookings'] as List<dynamic>? ?? [])
          .map((e) => FinalCartBookingModel.fromJson(e))
          .toList(),
    );
  }

  /// Total across all bookings in this restaurant
  double get restaurantTotal =>
      bookings.fold(0.0, (sum, b) => sum + b.bookingTotal);

  /// Total item count across all bookings
  int get totalItemCount =>
      bookings.fold(0, (sum, b) => sum + b.items.length);
}

class FinalCartBookingModel {
  final int bookingId;
  final String bookingDate;
  final String timeSlot;
  final String tableNo;
  final List<FinalCartItemModel> items;
  final double bookingTotal;

  FinalCartBookingModel({
    required this.bookingId,
    required this.bookingDate,
    required this.timeSlot,
    required this.tableNo,
    required this.items,
    required this.bookingTotal,
  });

  factory FinalCartBookingModel.fromJson(Map<String, dynamic> json) {
    return FinalCartBookingModel(
      bookingId: int.tryParse(json['booking_id'].toString()) ?? 0,
      bookingDate: json['booking_date'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      tableNo: json['table_no'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => FinalCartItemModel.fromJson(e))
          .toList(),
      bookingTotal:
      double.tryParse(json['booking_total'].toString()) ?? 0.0,
    );
  }
}

class FinalCartItemModel {
  final String itemImage;
  final String itemName;
  final double price;
  final int quantity;
  final double totalPrice;

  FinalCartItemModel({
    required this.itemImage,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory FinalCartItemModel.fromJson(Map<String, dynamic> json) {
    return FinalCartItemModel(
      itemImage: json['item_image'] ?? '',
      itemName: json['item_name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
    );
  }

  /// Full image URL helper  — adjust base URL as needed
  String get imageUrl =>
      'https://rasma.astradevelops.in/e_shoppyy/public/$itemImage';
}