import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../data/errors/api_error.dart';
import '../merchantlogin/widget/successwidget.dart';

// ── Model ──────────────────────────────────────────────────────────────────

class BookingItem {
  final int bookingId;
  final int restaurantId;
  final String restaurantName;
  final int menuItemId;
  final String itemName;
  final String image;
  final double price;
  final int guests;
  final String bookingDate;
  final String mealType;
  final String timeSlot;
  final String tableNo;
  final DateTime createdAt;

  BookingItem({
    required this.bookingId,
    required this.restaurantId,
    required this.restaurantName,
    required this.menuItemId,
    required this.itemName,
    required this.image,
    required this.price,
    required this.guests,
    required this.bookingDate,
    required this.mealType,
    required this.timeSlot,
    required this.tableNo,
    required this.createdAt,
  });

  factory BookingItem.fromJson(
      Map<String, dynamic> json, int restaurantId, String restaurantName) {
    return BookingItem(
      bookingId: json['booking_id'] as int,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      menuItemId: json['menu_item_id'] as int,
      itemName: json['food_name'] as String,
      image: json['image'] as String,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      guests: json['guests'] as int,
      bookingDate: json['booking_date'] as String,
      mealType: json['meal_type'] as String,
      timeSlot: json['time_slot'] as String,
      tableNo: json['table_no'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// ── Controller ─────────────────────────────────────────────────────────────

class BookingController extends GetxController {
  final _box = GetStorage();

  final RxList<BookingItem> bookings = <BookingItem>[].obs;
  final RxBool isLoading = false.obs;

  /// Groups bookings by restaurantId preserving API order
  Map<int, List<BookingItem>> get groupedByRestaurant {
    final map = <int, List<BookingItem>>{};
    for (final item in bookings) {
      map.putIfAbsent(item.restaurantId, () => []).add(item);
    }
    return map;
  }

  double get grandTotal =>
      bookings.fold(0.0, (sum, b) => sum + b.price * b.guests);

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
        Uri.parse('https://eshoppy.co.in/api/user/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        if (decoded['status'] == 1) {
          final List<dynamic> restaurants = decoded['data'] as List;
          final List<BookingItem> allItems = [];

          for (final restaurant in restaurants) {
            final int restaurantId = restaurant['restaurant_id'] as int;
            final String restaurantName =
            restaurant['restaurant_name'] as String;
            final List<dynamic> orders = restaurant['orders'] as List;

            for (final order in orders) {
              allItems.add(BookingItem.fromJson(
                  order as Map<String, dynamic>, restaurantId, restaurantName));
            }
          }

          bookings.assignAll(allItems);
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