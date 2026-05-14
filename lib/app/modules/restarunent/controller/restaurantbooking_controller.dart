
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

  /// is_active == 1  → active / selectable
  /// is_active == 0  → past   / disabled  (cannot be tapped)
  final bool isActive;

  TimeSlotModel({required this.time, required this.isActive});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    final raw = json['is_active'];
    final active = raw == 1 || raw == true || raw.toString() == '1';
    return TimeSlotModel(
      time: json['time']?.toString() ?? '',
      isActive: active,
    );
  }

  bool get isSelectable => isActive;  // tap is allowed only when active
  bool get isPast       => !isActive; // drives strikethrough in the UI
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
      mealType: json['meal_type']?.toString() ?? '',
      timeSlots: slots,
    );
  }
}

/// One seating group as returned by /get-tables-by-guests
class SeatingGroup {
  final String seatingType; // "indoor" | "outdoor"
  final List<String> tables;

  SeatingGroup({required this.seatingType, required this.tables});
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

class RestaurantBookingController extends GetxController {
  static const String _baseUrl = 'https://eshoppy.co.in/api';

  final _box = GetStorage();

  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken.isNotEmpty) 'Authorization': 'Bearer $_authToken',
  };

  // ── Observables ─────────────────────────────────────────────────────────────

  final RxList<MealModel>              meals         = <MealModel>[].obs;
  final RxList<Map<String, dynamic>>   bookingRows   = <Map<String, dynamic>>[].obs;
  final RxList<SeatingGroup>           seatingGroups = <SeatingGroup>[].obs;

  final RxBool isLoadingSlots  = false.obs;
  final RxBool isLoadingTables = false.obs;
  final RxBool isSaving        = false.obs;

  final RxInt  guests    = RxInt(1);
  final RxInt  maxGuests = RxInt(99);
  final RxInt  totalSeats = RxInt(0);

  final Rx<DateTime> selectedDate  = DateTime.now().obs;
  final RxString     errorMessage  = ''.obs;

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

  List<String> get availableSeatingTypes =>
      seatingGroups.map((g) => g.seatingType).toList();

  List<TimeSlotModel> timeSlotsForRow(int index) {
    if (index >= meals.length) return [];
    return meals[index].timeSlots;
  }

  List<String> tablesForRow(int index) {
    if (index >= bookingRows.length) return [];
    final chosen = bookingRows[index]['seatingType']?.toString() ?? '';
    if (chosen.isEmpty) return [];
    try {
      return seatingGroups
          .firstWhere(
            (g) => g.seatingType.toLowerCase() == chosen.toLowerCase(),
      )
          .tables;
    } catch (_) {
      return [];
    }
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchSlots();

    // Re-fetch slots whenever date changes
    ever(selectedDate, (_) => fetchSlots());

    // Re-fetch table allocation (debounced) whenever guests changes
    debounce(
      guests,
          (_) => fetchTableAllocation(),
      time: const Duration(milliseconds: 600),
    );
  }

  // ── FETCH SLOTS ───────────────────────────────────────────────────────────────
  // POST /restaurant/bookings
  // Body : { restaurant_id, booking_date (DD-MM-YYYY), menu_ids }
  // is_active: 0 = past/disabled, 1 = active/selectable

  Future<void> fetchSlots() async {
    isLoadingSlots.value = true;
    errorMessage.value   = '';
    meals.clear();
    bookingRows.clear();

    try {
      final body = jsonEncode({
        'restaurant_id': restaurantId,
        'booking_date' : _ddmmyyyy(selectedDate.value),
        'menu_ids'     : _menuIds,
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
          bookingRows.value = parsed
              .map(
                (m) => <String, dynamic>{
              'mealType'   : m.mealType,
              'timeSlot'   : '',
              'seatingType': '',
              'tableName'  : '',
            },
          )
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

  // ── FETCH TABLE ALLOCATION ───────────────────────────────────────────────────
  // POST /get-tables-by-guests
  // Body    : { restaurant_id, guests }
  // Success : { status:1, data:{ total_seats, guests,
  //               allocation:[ { seating_type:"indoor", tables_used:["T1","T2"] } ] } }
  // Fail    : { status:0, message:"Not enough seats available",
  //               data:{ total_seats, guests, allocation:[] } }

  Future<void> fetchTableAllocation() async {
    if (restaurantId == 0) return;
    isLoadingTables.value = true;
    seatingGroups.clear();

    // Reset seating + table selections in every row
    for (int i = 0; i < bookingRows.length; i++) {
      final row = Map<String, dynamic>.from(bookingRows[i]);
      row['seatingType'] = '';
      row['tableName']   = '';
      bookingRows[i]     = row;
    }
    bookingRows.refresh();

    try {
      final body = jsonEncode({
        'restaurant_id': restaurantId,
        'guests'       : guests.value,
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
          maxGuests.value =
          totalSeats.value > 0 ? totalSeats.value : 99;

          final allocationList =
              (dataBody['allocation'] as List?) ?? [];

          final List<SeatingGroup> groups = [];

          for (final entry in allocationList) {
            final map      = entry as Map<String, dynamic>;
            final rawType  = map['seating_type']?.toString().toLowerCase() ?? '';
            final rawTables = (map['tables_used'] as List? ?? [])
                .map((t) => t.toString())
            // Deduplicate within a group
                .fold<List<String>>([], (acc, t) {
              if (!acc.contains(t)) acc.add(t);
              return acc;
            });

            if (rawTables.isNotEmpty) {
              groups.add(SeatingGroup(
                seatingType: rawType.isNotEmpty ? rawType : 'indoor',
                tables: rawTables,
              ));
            }
          }

          seatingGroups.value = groups;
        } else {
          // Not enough seats — cap guests at total_seats
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

  // ── Row setters ──────────────────────────────────────────────────────────────

  void setTimeSlot(int index, String slot) {
    if (index >= bookingRows.length) return;
    final row    = Map<String, dynamic>.from(bookingRows[index]);
    row['timeSlot'] = slot;
    bookingRows[index] = row;
    bookingRows.refresh();
  }

  void setSeating(int index, String seatingType) {
    if (index >= bookingRows.length) return;
    final row           = Map<String, dynamic>.from(bookingRows[index]);
    row['seatingType']  = seatingType;
    row['tableName']    = ''; // reset table when seating type changes
    bookingRows[index]  = row;
    bookingRows.refresh();
  }

  void setTable(int index, String tableName) {
    if (index >= bookingRows.length) return;
    final row          = Map<String, dynamic>.from(bookingRows[index]);
    row['tableName']   = tableName;
    bookingRows[index] = row;
    bookingRows.refresh();
  }

  // ── CONFIRM BOOKING ──────────────────────────────────────────────────────────
  // POST /restaurant-booking/confirm
  // Body:
  // {
  //   "restaurant_id": 21,
  //   "guests"       : 6,
  //   "booking_date" : "2026-05-13",          ← YYYY-MM-DD
  //   "bookings": [
  //     {
  //       "seating_type": "indoor",
  //       "meal_type"   : "breakfast",
  //       "time_slot"   : "09:16 AM - 09:36 AM",
  //       "table_name"  : "T2"
  //     }
  //   ]
  // }

  Future<bool> confirmAndSave() async {
    // Only rows that have a time slot selected are included
    final filledRows = bookingRows
        .where((r) => (r['timeSlot'] ?? '').toString().isNotEmpty)
        .toList();

    if (filledRows.isEmpty) {
      AppSnackbar.error('Please select a time slot for at least one meal.');
      return false;
    }

    // Each filled row must also have seating type + table
    for (final row in filledRows) {
      final meal = _capitalize(row['mealType']?.toString() ?? '');
      if ((row['seatingType'] ?? '').toString().isEmpty) {
        AppSnackbar.error('Select a seating type for $meal.');
        return false;
      }
      if ((row['tableName'] ?? '').toString().isEmpty) {
        AppSnackbar.error('Select a table for $meal.');
        return false;
      }
    }

    isSaving.value = true;

    try {
      final payload = jsonEncode({
        'restaurant_id': restaurantId,
        'guests'       : guests.value,
        'booking_date' : _yyyymmdd(selectedDate.value), // YYYY-MM-DD
        'bookings'     : filledRows
            .map(
              (r) => {
            'seating_type': r['seatingType'],
            'meal_type'   : r['mealType'],
            'time_slot'   : r['timeSlot'],
            'table_name'  : r['tableName'],
          },
        )
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

  // ── Date helpers ─────────────────────────────────────────────────────────────

  /// DD-MM-YYYY  — for /restaurant/bookings
  String _ddmmyyyy(DateTime d) =>
      '${_p(d.day)}-${_p(d.month)}-${d.year}';

  /// YYYY-MM-DD  — for /restaurant-booking/confirm
  String _yyyymmdd(DateTime d) =>
      '${d.year}-${_p(d.month)}-${_p(d.day)}';

  String _p(int n) => n.toString().padLeft(2, '0');

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}