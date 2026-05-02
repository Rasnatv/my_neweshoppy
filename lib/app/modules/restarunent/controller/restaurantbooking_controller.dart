
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../../data/models/userslotbooking.model.dart';
import '../../merchantlogin/widget/successwidget.dart';

class RestaurantBookingController extends GetxController {
  late final int restaurantId;

  var guests    = 1.obs;
  var maxGuests = 99.obs;
  var selectedDate = DateTime.now().obs;

  var meals         = <MealSlot>[].obs;
  var seatingGroups = <SeatingTableGroup>[].obs;
  var bookingRows   = <RxMap<String, String>>[].obs;

  var isLoadingSlots  = false.obs;
  var isLoadingTables = false.obs;
  var isSaving        = false.obs;
  var errorMessage    = "".obs;

  BookingSummary? currentSummary;

  final String _base = "https://eshoppy.co.in/api";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    restaurantId = (args is Map && args["restaurant_id"] != null)
        ? (args["restaurant_id"] as num).toInt()
        : 0;
    debugPrint("── restaurantId = $restaurantId");
    fetchTimeSlots();
    ever(selectedDate, (_) => _buildRowsFromMeals());
    ever(guests,       (_) => _fetchTablesByGuests());
  }

  Map<String, dynamic> _safe(String body) {
    try {
      final d = jsonDecode(body);
      if (d is Map<String, dynamic>) return d;
      return {"status": 0, "message": "Unexpected response", "data": d};
    } catch (_) {
      return {"status": 0, "message": "Invalid JSON", "data": null};
    }
  }

  Future<void> fetchTimeSlots() async {
    try {
      isLoadingSlots.value = true;
      errorMessage.value   = "";

      final token = _token();
      final body  = jsonEncode({"restaurant_id": restaurantId});
      debugPrint("── SLOTS REQUEST  body=$body");

      final res = await http.post(
        Uri.parse("$_base/restaurant/bookings"),
        headers: _headers(token),
        body: body,
      );

      if (res.statusCode == 200) {
        final parsed = TimeSlotsResponse.fromJson(_safe(res.body));
        if (parsed.status == 1 && parsed.data != null) {
          meals.value = parsed.data!.meals;
          _buildRowsFromMeals();
          await _fetchTablesByGuests();
        } else {
          final msg = parsed.message.isNotEmpty
              ? parsed.message
              : "No slots found.";
          errorMessage.value = msg;
          AppSnackbar.warning(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(res);
        if (msg.isNotEmpty) {
          errorMessage.value = msg;
          AppSnackbar.error(msg);
        }
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) {
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
      debugPrintStack(stackTrace: st, label: "fetchTimeSlots");
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> _fetchTablesByGuests() async {
    if (meals.isEmpty) return;
    try {
      isLoadingTables.value = true;
      errorMessage.value    = "";

      final token = _token();
      final body  = jsonEncode({
        "restaurant_id": restaurantId,
        "guests":        guests.value,
      });
      debugPrint("── TABLES REQUEST  body=$body");

      final res = await http.post(
        Uri.parse("$_base/get-tables-by-guests"),
        headers: _headers(token),
        body: body,
      );
      debugPrint("── TABLES RESPONSE ${res.statusCode} ${res.body}");

      if (res.statusCode == 200) {
        final parsed = GetTablesByGuestsResponse.fromJson(_safe(res.body));
        if (parsed.status == 1 && parsed.data.isNotEmpty) {
          seatingGroups.value = parsed.data;
          if (guests.value > maxGuests.value) {
            maxGuests.value = guests.value;
          }
          for (final row in bookingRows) {
            row["tableName"] = "";
          }
          bookingRows.refresh();
        } else {
          seatingGroups.value = [];
          maxGuests.value     = guests.value - 1;
          if (guests.value > 1) guests.value--;
          for (final row in bookingRows) {
            row["tableName"]   = "";
            row["seatingType"] = "";
          }
          bookingRows.refresh();
          final msg = parsed.message.isNotEmpty
              ? parsed.message
              : "No tables available for that many guests.";
          errorMessage.value = msg;
          AppSnackbar.warning(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(res);
        if (msg.isNotEmpty) {
          errorMessage.value = msg;
          AppSnackbar.error(msg);
        }
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) {
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
      debugPrintStack(stackTrace: st, label: "_fetchTablesByGuests");
    } finally {
      isLoadingTables.value = false;
    }
  }

  void _buildRowsFromMeals() {
    bookingRows.value = meals
        .map((m) => RxMap<String, String>({
      "mealType":    m.mealType,
      "seatingType": "",
      "timeSlot":    "",
      "tableName":   "",
    }))
        .toList();
  }

  List<String> get availableSeatingTypes =>
      seatingGroups.map((g) => g.seatingType).toSet().toList();

  List<String> tablesForRow(int i) {
    if (i >= bookingRows.length) return [];
    final s = bookingRows[i]["seatingType"] ?? "";
    if (s.isEmpty) return [];
    return seatingGroups
        .where((g) => g.seatingType.toLowerCase() == s.toLowerCase())
        .expand((g) => g.tables)
        .toList();
  }

  List<String> timeSlotsForRow(int i) {
    if (i >= bookingRows.length) return [];
    final m = bookingRows[i]["mealType"] ?? "";
    return meals
        .firstWhereOrNull(
            (x) => x.mealType.toLowerCase() == m.toLowerCase())
        ?.timeSlots ??
        [];
  }

  void setSeating(int i, String v) {
    if (i >= bookingRows.length) return;
    bookingRows[i]["seatingType"] = v;
    bookingRows[i]["tableName"]   = "";
    bookingRows.refresh();
  }

  void setTimeSlot(int i, String v) {
    if (i >= bookingRows.length) return;
    bookingRows[i]["timeSlot"] = v;
    bookingRows.refresh();
  }

  void setTable(int i, String v) {
    if (i >= bookingRows.length) return;
    bookingRows[i]["tableName"] = v;
    bookingRows.refresh();
  }

  List<BookingEntry> _completedEntries() {
    return bookingRows
        .where((r) =>
    (r["seatingType"] ?? "").isNotEmpty &&
        (r["mealType"]    ?? "").isNotEmpty &&
        (r["timeSlot"]    ?? "").isNotEmpty &&
        (r["tableName"]   ?? "").isNotEmpty)
        .map((r) => BookingEntry(
      seatingType: r["seatingType"]!,
      mealType:    r["mealType"]!,
      timeSlot:    r["timeSlot"]!,
      tableName:   r["tableName"]!,
    ))
        .toList();
  }

  BookingSummary? buildSummary() {
    final entries = _completedEntries();
    if (entries.isEmpty) return null;
    currentSummary = BookingSummary(
      restaurantId: restaurantId,
      guests:       guests.value,
      bookingDate:  _date(selectedDate.value),
      bookings: entries
          .map((e) => CartBookingItem(
        seatingType: e.seatingType,
        mealType:    e.mealType,
        timeSlot:    e.timeSlot,
        tableName:   e.tableName,
      ))
          .toList(),
    );
    return currentSummary;
  }

  // ── Single entry point — UI calls ONLY this ───────────────────────────
  Future<bool> confirmAndSave() async {
    // ✅ Build summary here — NOT in the UI
    final summary = buildSummary();
    if (summary == null || summary.bookings.isEmpty) {
      AppSnackbar.warning(
        "Please complete at least one meal (seating type, time slot and table).",
      );
      return false;
    }

    try {
      isSaving.value = true;
      final token = _token();

      final body = jsonEncode({
        "restaurant_id": summary.restaurantId,
        "guests":        summary.guests,
        "booking_date":  summary.bookingDate,
        "bookings": summary.bookings
            .map((b) => {
          "seating_type": b.seatingType,
          "meal_type":    b.mealType,
          "time_slot":    b.timeSlot,
          "table_name":   b.tableName,
        })
            .toList(),
      });

      debugPrint("── CONFIRM FULL BODY: $body");

      final res = await http.post(
        Uri.parse("$_base/restaurant-booking/confirm"),
        headers: _headers(token),
        body: body,
      );

      debugPrint("── CONFIRM RESPONSE ${res.statusCode} ${res.body}");

      if (res.statusCode == 200) {
        final parsed = ConfirmBookingResponse.fromJson(_safe(res.body));
        if (parsed.status == 1) {
          // ✅ Success
          AppSnackbar.success(
            parsed.message.isNotEmpty
                ? parsed.message
                : "Booking confirmed successfully!",
          );
          currentSummary = null;
          return true;
        } else {
          // 🟡 API returned status=0 — always a warning
          final msg = parsed.message.isNotEmpty
              ? parsed.message
              : "Booking failed.";
          errorMessage.value = msg;
          AppSnackbar.warning(msg);
          return false;
        }
      } else {
        // 🔴 Real HTTP error
        final msg = ApiErrorHandler.handleResponse(res);
        if (msg.isNotEmpty) {
          errorMessage.value = msg;
          AppSnackbar.error(msg);
        }
        return false;
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) {
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
      debugPrintStack(stackTrace: st, label: "confirmAndSave");
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  String _token() {
    final t = GetStorage().read<String>("auth_token") ?? "";
    return t;
  }

  Map<String, String> _headers(String token) => {
    "Content-Type": "application/json",
    "Accept":       "application/json",
    if (token.isNotEmpty) "Authorization": "Bearer $token",
  };

  String _date(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}"
          "-${d.day.toString().padLeft(2, '0')}";
}