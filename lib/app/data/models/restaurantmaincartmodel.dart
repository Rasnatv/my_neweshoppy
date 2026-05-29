//
// class FinalCartResponseModel {
//   final int status;
//   final String message;
//   final List<FinalCartRestaurantModel> data;
//
//   FinalCartResponseModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory FinalCartResponseModel.fromJson(Map<String, dynamic> json) {
//     return FinalCartResponseModel(
//       status: json['status'] ?? 0,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>? ?? [])
//           .map((e) => FinalCartRestaurantModel.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class FinalCartRestaurantModel {
//   final int restaurantId;
//   final String restaurantName;
//   final String restaurantLocation;
//   final List<FinalCartBookingModel> bookings;
//
//   FinalCartRestaurantModel({
//     required this.restaurantId,
//     required this.restaurantName,
//     required this.restaurantLocation,
//     required this.bookings,
//   });
//
//   factory FinalCartRestaurantModel.fromJson(Map<String, dynamic> json) {
//     return FinalCartRestaurantModel(
//       restaurantId: int.tryParse(json['restaurant_id'].toString()) ?? 0,
//       restaurantName: json['restaurant_name'] ?? '',
//       restaurantLocation: json['restaurant_location'] ?? '',
//       bookings: (json['bookings'] as List<dynamic>? ?? [])
//           .map((e) => FinalCartBookingModel.fromJson(e))
//           .toList(),
//     );
//   }
//
//   /// Total across all bookings in this restaurant
//   double get restaurantTotal =>
//       bookings.fold(0.0, (sum, b) => sum + b.bookingTotal);
//
//   /// Total item count across all bookings
//   int get totalItemCount =>
//       bookings.fold(0, (sum, b) => sum + b.items.length);
// }
//
// class FinalCartBookingModel {
//   final int bookingId;
//   final String bookingDate;
//   final String timeSlot;
//   final String tableNo;
//   final List<FinalCartItemModel> items;
//   final double bookingTotal;
//
//   FinalCartBookingModel({
//     required this.bookingId,
//     required this.bookingDate,
//     required this.timeSlot,
//     required this.tableNo,
//     required this.items,
//     required this.bookingTotal,
//   });
//
//   factory FinalCartBookingModel.fromJson(Map<String, dynamic> json) {
//     return FinalCartBookingModel(
//       bookingId: int.tryParse(json['booking_id'].toString()) ?? 0,
//       bookingDate: json['booking_date'] ?? '',
//       timeSlot: json['time_slot'] ?? '',
//       tableNo: json['table_no'] ?? '',
//       items: (json['items'] as List<dynamic>? ?? [])
//           .map((e) => FinalCartItemModel.fromJson(e))
//           .toList(),
//       bookingTotal:
//       double.tryParse(json['booking_total'].toString()) ?? 0.0,
//     );
//   }
// }
//
// class FinalCartItemModel {
//   final String cartId;
//   final String itemImage;
//   final String itemName;
//   final double price;
//   final int quantity;
//   final double totalPrice;
//
//   FinalCartItemModel({
//     required this.itemImage,
//     required this.itemName,
//     required this.price,
//     required this.quantity,
//     required this.totalPrice, required this.cartId,
//   });
//
//   factory FinalCartItemModel.fromJson(Map<String, dynamic> json) {
//     return FinalCartItemModel(
//       itemImage: json['item_image'] ?? '',
//       itemName: json['item_name'] ?? '',
//       price: double.tryParse(json['price'].toString()) ?? 0.0,
//       quantity: int.tryParse(json['quantity'].toString()) ?? 0,
//       totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
//       cartId: json['cart_id']?.toString() ?? '',
//     );
//   }
//
//
// }
import 'dart:convert';

class FinalCartResponseModel {
  final int status;
  final String message;
  final List<FinalCartRestaurantModel> data;

  FinalCartResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FinalCartResponseModel.fromJson(
      Map<String, dynamic> json) {
    return FinalCartResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => FinalCartRestaurantModel.fromJson(e),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
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

  factory FinalCartRestaurantModel.fromJson(
      Map<String, dynamic> json) {
    return FinalCartRestaurantModel(
      restaurantId:
      int.tryParse(
          json['restaurant_id'].toString()) ??
          0,

      restaurantName:
      json['restaurant_name'] ?? '',

      restaurantLocation:
      json['restaurant_location'] ?? '',

      bookings:
      (json['bookings'] as List<dynamic>? ?? [])
          .map(
            (e) =>
            FinalCartBookingModel.fromJson(e),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'restaurant_location': restaurantLocation,
      'bookings':
      bookings.map((e) => e.toJson()).toList(),
    };
  }

  /// Restaurant total price
  double get restaurantTotal =>
      bookings.fold(
        0.0,
            (sum, booking) =>
        sum + booking.bookingTotal,
      );

  /// Total item count
  int get totalItemCount =>
      bookings.fold(
        0,
            (sum, booking) =>
        sum + booking.items.length,
      );
}

class FinalCartBookingModel {
  /// nullable because API returns null
  final int? bookingId;

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

  factory FinalCartBookingModel.fromJson(
      Map<String, dynamic> json) {
    return FinalCartBookingModel(
      bookingId:
      json['booking_id'] == null
          ? null
          : int.tryParse(
        json['booking_id'].toString(),
      ),

      bookingDate:
      json['booking_date'] ?? '',

      timeSlot:
      json['time_slot'] ?? '',

      tableNo:
      json['table_no'] ?? '',

      items:
      (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) =>
            FinalCartItemModel.fromJson(e),
      )
          .toList(),

      bookingTotal:
      double.tryParse(
          json['booking_total'].toString()) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'booking_date': bookingDate,
      'time_slot': timeSlot,
      'table_no': tableNo,
      'items': items.map((e) => e.toJson()).toList(),
      'booking_total': bookingTotal,
    };
  }
}

class FinalCartItemModel {
  final String cartId;
  final String itemImage;
  final String itemName;
  final double price;
  final int quantity;
  final double totalPrice;

  FinalCartItemModel({
    required this.cartId,
    required this.itemImage,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory FinalCartItemModel.fromJson(
      Map<String, dynamic> json) {
    return FinalCartItemModel(
      cartId:
      json['cart_id']?.toString() ?? '',

      itemImage:
      json['item_image'] ?? '',

      itemName:
      json['item_name'] ?? '',

      price:
      double.tryParse(
          json['price'].toString()) ??
          0.0,

      quantity:
      int.tryParse(
          json['quantity'].toString()) ??
          0,

      totalPrice:
      double.tryParse(
          json['total_price'].toString()) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'item_image': itemImage,
      'item_name': itemName,
      'price': price,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}