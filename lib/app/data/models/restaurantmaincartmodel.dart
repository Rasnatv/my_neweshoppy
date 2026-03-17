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

// ── restaurantmaincartmodel.dart ─────────────────────────────────────────────

double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0.0;
int    _toInt(dynamic v)    => int.tryParse(v?.toString() ?? '0') ?? 0;

// ── Restaurant ────────────────────────────────────────────────────────────────
class FinalCartRestaurant {
  final int    restaurantId;
  final String restaurantName;
  final String address;

  FinalCartRestaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.address,
  });

  factory FinalCartRestaurant.fromJson(Map<String, dynamic> j) =>
      FinalCartRestaurant(
        restaurantId:   _toInt(j['restaurant_id']),
        restaurantName: j['restaurant_name']?.toString() ?? '',
        address:        j['address']?.toString() ?? '',
      );
}

// ── Booking details ───────────────────────────────────────────────────────────
class FinalCartBookingDetails {
  final int    bookingId;
  final String bookingDate;
  final String timeSlot;
  final String tableNo;
  final String guests;
  final String mealType;
  final String seatingType;

  FinalCartBookingDetails({
    required this.bookingId,
    required this.bookingDate,
    required this.timeSlot,
    required this.tableNo,
    required this.guests,
    required this.mealType,
    required this.seatingType,
  });

  factory FinalCartBookingDetails.fromJson(Map<String, dynamic> j) =>
      FinalCartBookingDetails(
        bookingId:   _toInt(j['booking_id']),
        bookingDate: j['booking_date']?.toString() ?? '',
        timeSlot:    j['time_slot']?.toString() ?? '',
        tableNo:     j['table_no']?.toString() ?? '',
        guests:      j['guests']?.toString() ?? '',
        mealType:    j['meal_type']?.toString() ?? '',
        seatingType: j['seating_type']?.toString() ?? '',
      );

  String get mealLabel {
    final m = mealType.toLowerCase();
    return m.isEmpty ? '' : '${m[0].toUpperCase()}${m.substring(1)}';
  }

  String get seatingLabel {
    final s = seatingType.toLowerCase();
    return s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';
  }
}

// ── Cart item ─────────────────────────────────────────────────────────────────
class FinalCartItem {
  final int    id;
  final int    restaurantId;
  final String itemName;
  final String image;
  final double price;
  final int    quantity;
  final double totalPrice;

  const FinalCartItem({
    required this.id,
    required this.restaurantId,
    required this.itemName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory FinalCartItem.fromJson(Map<String, dynamic> j) => FinalCartItem(
    id:           _toInt(j['id']),
    restaurantId: _toInt(j['restaurant_id']),
    itemName:     j['item_name']?.toString() ?? '',
    image:        j['image']?.toString() ?? '',
    price:        _toDouble(j['price']),
    quantity:     _toInt(j['quantity']),
    totalPrice:   _toDouble(j['total_price']),
  );

  FinalCartItem copyWith({int? quantity}) {
    final q = quantity ?? this.quantity;
    return FinalCartItem(
      id:           id,
      restaurantId: restaurantId,
      itemName:     itemName,
      image:        image,
      price:        price,
      quantity:     q,
      totalPrice:   price * q,
    );
  }
}

// ── Full cart data ────────────────────────────────────────────────────────────
class FinalCartData {
  final FinalCartRestaurant     restaurant;
  final FinalCartBookingDetails? bookingDetails;
  final List<FinalCartItem>     cartItems;
  final double                  grandTotal;

  FinalCartData({
    required this.restaurant,
    required this.bookingDetails,
    required this.cartItems,
    required this.grandTotal,
  });

  factory FinalCartData.fromJson(Map<String, dynamic> j) => FinalCartData(
    restaurant: FinalCartRestaurant.fromJson(
        j['restaurant'] as Map<String, dynamic>),
    bookingDetails: j['booking_details'] != null
        ? FinalCartBookingDetails.fromJson(
        j['booking_details'] as Map<String, dynamic>)
        : null,
    cartItems: (j['cart_items'] as List<dynamic>? ?? [])
        .map((e) => FinalCartItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    grandTotal: _toDouble(j['grand_total']),
  );

  int    get totalItemCount => cartItems.fold(0, (s, i) => s + i.quantity);
  double get cartSubtotal   => cartItems.fold(0.0, (s, i) => s + i.totalPrice);
}

// ── Response wrapper ──────────────────────────────────────────────────────────
class FinalCartResponse {
  final int    status;
  final String message;
  final FinalCartData? data;

  FinalCartResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory FinalCartResponse.fromJson(Map<String, dynamic> j) => FinalCartResponse(
    status:  _toInt(j['status']),
    message: j['message']?.toString() ?? '',
    data: j['data'] != null
        ? FinalCartData.fromJson(j['data'] as Map<String, dynamic>)
        : null,
  );
}