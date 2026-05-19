
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../data/errors/api_error.dart';
import '../merchantlogin/widget/successwidget.dart';

// ── Models ─────────────────────────────────────────────────────────────────

class BookingOrder {
  final int bookingId;
  final int menuItemId;
  final String foodName;
  final double price;
  final int quantity;
  final double totalPrice;
  final String image;
  final String mealType;
  final String tableNo;
  final DateTime createdAt;

  BookingOrder({
    required this.bookingId,
    required this.menuItemId,
    required this.foodName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.image,
    required this.mealType,
    required this.tableNo,
    required this.createdAt,
  });

  factory BookingOrder.fromJson(Map<String, dynamic> json) {
    return BookingOrder(
      bookingId: json['booking_id'] as int,
      menuItemId: json['menu_item_id'] as int,
      foodName: json['food_name'] as String,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'] as int,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      image: json['image'] as String,
      mealType: json['meal_type'] as String,
      tableNo: json['table_no'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class BookingTimeSlot {
  final String timeSlot;
  final int guests;       // moved up from order level
  final double total;     // slot-level total (replaces time_total)
  final List<BookingOrder> orders;

  BookingTimeSlot({
    required this.timeSlot,
    required this.guests,
    required this.total,
    required this.orders,
  });

  factory BookingTimeSlot.fromJson(Map<String, dynamic> json) {
    return BookingTimeSlot(
      timeSlot: json['time_slot'] as String,
      guests: json['guests'] as int,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      orders: (json['orders'] as List)
          .map((o) => BookingOrder.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BookingDate {
  final String bookingDate;
  final List<BookingTimeSlot> timeSlots;

  BookingDate({
    required this.bookingDate,
    required this.timeSlots,
  });

  double get dateTotal =>
      timeSlots.fold(0.0, (s, t) => s + t.total);

  factory BookingDate.fromJson(Map<String, dynamic> json) {
    return BookingDate(
      bookingDate: json['booking_date'] as String,
      timeSlots: (json['time_slots'] as List)
          .map((t) => BookingTimeSlot.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BookingRestaurant {
  final int restaurantId;
  final String restaurantName;
  final List<BookingDate> dates;

  BookingRestaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.dates,
  });

  double get restaurantTotal =>
      dates.fold(0.0, (s, d) => s + d.dateTotal);

  int get totalOrders => dates.fold(
      0,
          (s, d) =>
      s + d.timeSlots.fold(0, (s2, t) => s2 + t.orders.length));

  factory BookingRestaurant.fromJson(Map<String, dynamic> json) {
    return BookingRestaurant(
      restaurantId: json['restaurant_id'] as int,
      restaurantName: json['restaurant_name'] as String,
      dates: (json['dates'] as List)
          .map((d) => BookingDate.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── Controller ─────────────────────────────────────────────────────────────

class BookingController extends GetxController {
  final _box = GetStorage();

  final RxList<BookingRestaurant> restaurants = <BookingRestaurant>[].obs;
  final RxBool isLoading = false.obs;

  bool get isEmpty => restaurants.isEmpty;

  double get grandTotal =>
      restaurants.fold(0.0, (s, r) => s + r.restaurantTotal);

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;

    try {
      final token = _box.read<String>('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('https://entenaadu.co.in/api/user/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        if (decoded['status'] == 1) {
          final List<dynamic> data = decoded['data'] as List;
          restaurants.assignAll(
            data.map((r) =>
                BookingRestaurant.fromJson(r as Map<String, dynamic>)),
          );
        } else {
          final msg = decoded['message']?.toString() ?? '';
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(msg);
    } finally {
      isLoading.value = false;
    }
  }
}