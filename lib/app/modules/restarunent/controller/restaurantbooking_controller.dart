
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../controller/restaurantcartcontroller.dart';


class TimeSlotModel {
  final String time;
  final bool isActive; // 1 = selectable, 0 = past/disabled

  TimeSlotModel({required this.time, required this.isActive});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    final raw    = json['is_active'];
    final active = raw == 1 || raw == true || raw.toString() == '1';
    return TimeSlotModel(time: json['time']?.toString() ?? '', isActive: active);
  }

  bool get isSelectable => isActive;
  bool get isPast       => !isActive;
}

class MealModel {
  final String mealType;
  final List<TimeSlotModel> timeSlots;

  MealModel({required this.mealType, required this.timeSlots});

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final slots = (json['time_slots'] as List? ?? [])
        .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return MealModel(
      mealType:  json['meal_type']?.toString() ?? '',
      timeSlots: slots,
    );
  }
}

/// Holds the auto-allocated result from /get-tables-by-guests.
/// seatingType : e.g. "indoor" — taken from API, sent as-is to confirm.
/// tableNames  : comma-separated string, e.g. "T1,T2,T3" — sent as table_name.
class AllocatedTable {
  final String seatingType;
  final String tableNames;

  AllocatedTable({required this.seatingType, required this.tableNames});
}

class RestaurantBookingController extends GetxController {
  static const String _baseUrl = 'https://eshoppy.co.in/api';

  final _box = GetStorage();
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept':       'application/json',
    if (_authToken.isNotEmpty) 'Authorization': 'Bearer $_authToken',
  };

  // ── Observables ──────────────────────────────────────────────────────────────

  final RxList<MealModel>            meals       = <MealModel>[].obs;
  final RxList<Map<String, dynamic>> bookingRows = <Map<String, dynamic>>[].obs;

  /// ✅ Auto-allocated table result — no user selection ever needed.
  final Rx<AllocatedTable?> allocatedTable = Rx<AllocatedTable?>(null);

  final RxBool isLoadingSlots  = false.obs;
  final RxBool isLoadingTables = false.obs;
  final RxBool isSaving        = false.obs;

  final RxInt guests     = RxInt(1);
  final RxInt maxGuests  = RxInt(99);
  final RxInt totalSeats = RxInt(0);

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString     errorMessage = ''.obs;

  // ── Derived ──────────────────────────────────────────────────────────────────

  int get restaurantId {
    final args = Get.arguments;
    if (args is Map) {
      return int.tryParse(args['restaurant_id']?.toString() ?? '0') ?? 0;
    }
    return 0;
  }

  String get _menuIds {
    if (!Get.isRegistered<Restaurantcartcontroller>()) return '';
    final items =
    Get.find<Restaurantcartcontroller>().itemsForRestaurant(restaurantId);
    return items.map((e) => e.menuId.toString()).join(',');
  }

  List<TimeSlotModel> timeSlotsForRow(int index) {
    if (index >= meals.length) return [];
    return meals[index].timeSlots;
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchSlots();
    ever(selectedDate, (_) => fetchSlots());
    debounce(guests, (_) => fetchTableAllocation(),
        time: const Duration(milliseconds: 600));
  }
  Future<void> fetchSlots() async {
    isLoadingSlots.value = true;
    errorMessage.value   = '';
    meals.clear();
    bookingRows.clear();

    try {
      final body = jsonEncode({
        'restaurant_id': restaurantId,
        'booking_date':  _ddmmyyyy(selectedDate.value),
        'menu_ids':      _menuIds,
      });

      debugPrint('▶ fetchSlots → $body');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/bookings'),
        headers: _headers,
        body: body,
      );

      debugPrint('◀ fetchSlots [${response.statusCode}] → ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['status'] == 1) {
          final rawMeals = (data['data']?['meals'] as List?) ?? [];
          final parsed   = rawMeals
              .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
              .toList();

          meals.value = parsed;
          // bookingRows only tracks timeSlot per meal — seating/table are auto
          bookingRows.value = parsed
              .map((m) => <String, dynamic>{
            'mealType': m.mealType,
            'timeSlot': '',
          })
              .toList();
        } else {
          errorMessage.value =
              data['message']?.toString() ?? 'No slots available.';
        }
      } else {
        final err = ApiErrorHandler.handleResponse(response);
        errorMessage.value = err;
        AppSnackbar.error(err);
      }
    } catch (e) {
      final err = ApiErrorHandler.handleException(e);
      errorMessage.value = err;
      AppSnackbar.error(err);
      debugPrint('fetchSlots error: $e');
    } finally {
      isLoadingSlots.value = false;
      if (meals.isNotEmpty) fetchTableAllocation();
    }
  }


  Future<void> fetchTableAllocation() async {
    if (restaurantId == 0) return;
    isLoadingTables.value = true;
    allocatedTable.value  = null;

    try {
      final body = jsonEncode({
        'restaurant_id': restaurantId,
        'guests':        guests.value,
      });

      debugPrint('▶ fetchTableAllocation → $body');

      final response = await http.post(
        Uri.parse('$_baseUrl/get-tables-by-guests'),
        headers: _headers,
        body: body,
      );

      debugPrint(
          '◀ fetchTableAllocation [${response.statusCode}] → ${response.body}');

      if (response.statusCode == 200) {
        final data     = jsonDecode(response.body) as Map<String, dynamic>;
        final dataBody = (data['data'] as Map<String, dynamic>?) ?? {};

        totalSeats.value =
            int.tryParse(dataBody['total_seats']?.toString() ?? '0') ?? 0;

        if (data['status'] == 1) {
          maxGuests.value = totalSeats.value > 0 ? totalSeats.value : 99;

          final allocationList = (dataBody['allocation'] as List?) ?? [];

          // Collect ALL tables across ALL allocation entries
          final List<String> allTables   = [];
          String             seatingType = 'indoor'; // safe default

          for (final entry in allocationList) {
            final map = entry as Map<String, dynamic>;

            // Use seating_type from the first non-empty entry
            final rawType = map['seating_type']?.toString().trim() ?? '';
            if (rawType.isNotEmpty) seatingType = rawType.toLowerCase();

            final rawTables = (map['tables_used'] as List? ?? [])
                .map((t) => t.toString().trim())
                .where((t) => t.isNotEmpty)
                .toList();

            for (final t in rawTables) {
              if (!allTables.contains(t)) allTables.add(t);
            }
          }

          if (allTables.isNotEmpty) {
            // ✅ e.g. seatingType="indoor", tableNames="T1,T2,T3"
            allocatedTable.value = AllocatedTable(
              seatingType: seatingType,
              tableNames:  allTables.join(','),
            );
          }
        } else {
          // Not enough seats — cap guests
          final cap = totalSeats.value;
          if (cap > 0 && guests.value > cap) guests.value = cap;
          maxGuests.value = cap > 0 ? cap : 1;
          AppSnackbar.error(
              data['message']?.toString() ?? 'Not enough seats available');
        }
      }
    } catch (e) {
      debugPrint('fetchTableAllocation error: $e');
    } finally {
      isLoadingTables.value = false;
    }
  }

  // ── Time slot setter ──────────────────────────────────────────────────────────

  void setTimeSlot(int index, String slot) {
    if (index >= bookingRows.length) return;
    final row       = Map<String, dynamic>.from(bookingRows[index]);
    row['timeSlot'] = slot;
    bookingRows[index] = row;
    bookingRows.refresh();
  }

  Future<bool> confirmAndSave() async {
    if (allocatedTable.value == null) {
      AppSnackbar.error('Table allocation not ready. Please wait.');
      return false;
    }

    final filledRows = bookingRows
        .where((r) => (r['timeSlot'] ?? '').toString().isNotEmpty)
        .toList();

    if (filledRows.isEmpty) {
      AppSnackbar.error('Please select a time slot for at least one meal.');
      return false;
    }

    isSaving.value = true;

    try {
      final payload = jsonEncode({
        'restaurant_id': restaurantId,
        'guests':        guests.value,
        'booking_date':  _yyyymmdd(selectedDate.value),
        'bookings': filledRows
            .map((r) => {
          // ✅ Always use auto-allocated values — no user input
          'seating_type': allocatedTable.value!.seatingType,
          'meal_type':    r['mealType'],
          'time_slot':    r['timeSlot'],
          'table_name':   allocatedTable.value!.tableNames,
        })
            .toList(),
      });

      debugPrint('▶ confirmAndSave → $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant-booking/confirm'),
        headers: _headers,
        body: payload,
      );

      debugPrint(
          '◀ confirmAndSave [${response.statusCode}] → ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 1) return true;
        AppSnackbar.error(
            data['message']?.toString() ?? 'Booking failed. Try again.');
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
      debugPrint('confirmAndSave error: $e');
    } finally {
      isSaving.value = false;
    }

    return false;
  }

  // ── Date helpers ──────────────────────────────────────────────────────────────

  String _ddmmyyyy(DateTime d) => '${_p(d.day)}-${_p(d.month)}-${d.year}';
  String _yyyymmdd(DateTime d) => '${d.year}-${_p(d.month)}-${_p(d.day)}';
  String _p(int n) => n.toString().padLeft(2, '0');
}