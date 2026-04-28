//
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/errors/api_error.dart';
// import '../../../data/models/userslotbooking.model.dart';
// import '../../merchantlogin/widget/successwidget.dart'; // ← adjust path
//
// class RestaurantBookingController extends GetxController {
//   late final int restaurantId;
//
//   // ─── Selections ───────────────────────────────────────────────────────
//   var guests       = 1.obs;
//   var selectedDate = DateTime.now().obs;
//
//   // ─── API data ─────────────────────────────────────────────────────────
//   var meals         = <MealSlot>[].obs;
//   var seatingGroups = <SeatingTableGroup>[].obs;
//
//   // ─── One RxMap row per meal ───────────────────────────────────────────
//   var bookingRows = <RxMap<String, String>>[].obs;
//
//   // ─── UI state ─────────────────────────────────────────────────────────
//   var isLoadingSlots  = false.obs;
//   var isLoadingTables = false.obs;
//   var isSaving        = false.obs;
//   var errorMessage    = "".obs;
//
//   // ─── Holds the confirmed summary ──────────────────────────────────────
//   BookingSummary? currentSummary;
//
//   final String _base = "https://eshoppy.co.in/api";
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//
//     restaurantId = (args is Map && args["restaurant_id"] != null)
//         ? (args["restaurant_id"] as num).toInt()
//         : 0;
//
//     debugPrint("── restaurantId = $restaurantId");
//
//     fetchTimeSlots();
//     ever(selectedDate, (_) => _buildRowsFromMeals());
//     ever(guests,       (_) => _fetchTablesByGuests());
//   }
//
//   // ─── Safe JSON decode ─────────────────────────────────────────────────
//   Map<String, dynamic> _safe(String body) {
//     try {
//       final d = jsonDecode(body);
//       if (d is Map<String, dynamic>) return d;
//       return {"status": 0, "message": "Unexpected response", "data": d};
//     } catch (_) {
//       return {"status": 0, "message": "Invalid JSON", "data": null};
//     }
//   }
//
//   // ─── 1. Fetch meals + time-slots ──────────────────────────────────────
//   Future<void> fetchTimeSlots() async {
//     try {
//       isLoadingSlots.value = true;
//       errorMessage.value   = "";
//
//       final token = _token();
//       final body  = jsonEncode({"restaurant_id": restaurantId});
//
//       debugPrint("── SLOTS REQUEST  body=$body");
//
//       final res = await http.post(
//         Uri.parse("$_base/restaurant/bookings"),
//         headers: _headers(token),
//         body: body,
//       );
//
//
//       if (res.statusCode == 200) {
//         final parsed = TimeSlotsResponse.fromJson(_safe(res.body));
//
//         if (parsed.status == 1 && parsed.data != null) {
//           meals.value = parsed.data!.meals;
//           _buildRowsFromMeals();
//           await _fetchTablesByGuests();
//         } else {
//           final msg = parsed.message.isNotEmpty
//               ? parsed.message
//               : "No slots found.";
//           errorMessage.value = msg;
//           AppSnackbar.warning(msg);
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(res);
//         errorMessage.value = msg;
//         AppSnackbar.error(msg);
//       }
//     } catch (e, st) {
//       final msg = ApiErrorHandler.handleException(e);
//       errorMessage.value = msg;
//       AppSnackbar.error(msg);
//       debugPrintStack(stackTrace: st, label: "fetchTimeSlots");
//     } finally {
//       isLoadingSlots.value = false;
//     }
//   }
//
//   // ─── 2. Fetch tables by guest count ───────────────────────────────────
//   Future<void> _fetchTablesByGuests() async {
//     if (meals.isEmpty) return;
//     try {
//       isLoadingTables.value = true;
//       errorMessage.value    = "";
//
//       final token = _token();
//       final body  = jsonEncode({
//         "restaurant_id": restaurantId,
//         "guests":        guests.value,
//       });
//
//       debugPrint("── TABLES REQUEST  body=$body");
//
//       final res = await http.post(
//         Uri.parse("$_base/get-tables-by-guests"),
//         headers: _headers(token),
//         body: body,
//       );
//
//       debugPrint("── TABLES RESPONSE ${res.statusCode} ${res.body}");
//
//       if (res.statusCode == 200) {
//         final parsed = GetTablesByGuestsResponse.fromJson(_safe(res.body));
//
//         if (parsed.status == 1) {
//           seatingGroups.value = parsed.data;
//           for (final row in bookingRows) {
//             row["tableName"] = "";
//           }
//           bookingRows.refresh();
//         } else {
//           final msg = parsed.message.isNotEmpty
//               ? parsed.message
//               : "No tables found.";
//           errorMessage.value = msg;
//           AppSnackbar.warning(msg);
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(res);
//         errorMessage.value = msg;
//         AppSnackbar.error(msg);
//       }
//     } catch (e, st) {
//       final msg = ApiErrorHandler.handleException(e);
//       errorMessage.value = msg;
//       AppSnackbar.error(msg);
//       debugPrintStack(stackTrace: st, label: "_fetchTablesByGuests");
//     } finally {
//       isLoadingTables.value = false;
//     }
//   }
//
//   // ─── Build one row per meal ───────────────────────────────────────────
//   void _buildRowsFromMeals() {
//     bookingRows.value = meals
//         .map((m) => RxMap<String, String>({
//       "mealType":    m.mealType,
//       "seatingType": "",
//       "timeSlot":    "",
//       "tableName":   "",
//     }))
//         .toList();
//   }
//
//   // ─── Derived ──────────────────────────────────────────────────────────
//   List<String> get availableSeatingTypes =>
//       seatingGroups.map((g) => g.seatingType).toSet().toList();
//
//   List<String> tablesForRow(int i) {
//     if (i >= bookingRows.length) return [];
//     final s = bookingRows[i]["seatingType"] ?? "";
//     if (s.isEmpty) return [];
//     return seatingGroups
//         .where((g) => g.seatingType.toLowerCase() == s.toLowerCase())
//         .expand((g) => g.tables)
//         .toList();
//   }
//
//   List<String> timeSlotsForRow(int i) {
//     if (i >= bookingRows.length) return [];
//     final m = bookingRows[i]["mealType"] ?? "";
//     return meals
//         .firstWhereOrNull(
//             (x) => x.mealType.toLowerCase() == m.toLowerCase())
//         ?.timeSlots ??
//         [];
//   }
//
//   // ─── Row setters ──────────────────────────────────────────────────────
//   void setSeating(int i, String v) {
//     if (i >= bookingRows.length) return;
//     bookingRows[i]["seatingType"] = v;
//     bookingRows[i]["tableName"]   = "";
//     bookingRows.refresh();
//   }
//
//   void setTimeSlot(int i, String v) {
//     if (i >= bookingRows.length) return;
//     bookingRows[i]["timeSlot"] = v;
//     bookingRows.refresh();
//   }
//
//   void setTable(int i, String v) {
//     if (i >= bookingRows.length) return;
//     bookingRows[i]["tableName"] = v;
//     bookingRows.refresh();
//   }
//
//   // ─── Filter only fully completed rows ─────────────────────────────────
//   List<BookingEntry> _completedEntries() {
//     debugPrint("── _completedEntries: checking ${bookingRows.length} rows");
//     for (int i = 0; i < bookingRows.length; i++) {
//       final r = bookingRows[i];
//       debugPrint(
//           "  row[$i] meal=${r['mealType']} "
//               "seating=${r['seatingType']} "
//               "time=${r['timeSlot']} "
//               "table=${r['tableName']}");
//     }
//     final result = bookingRows
//         .where((r) =>
//     (r["seatingType"] ?? "").isNotEmpty &&
//         (r["mealType"]    ?? "").isNotEmpty &&
//         (r["timeSlot"]    ?? "").isNotEmpty &&
//         (r["tableName"]   ?? "").isNotEmpty)
//         .map((r) => BookingEntry(
//       seatingType: r["seatingType"]!,
//       mealType:    r["mealType"]!,
//       timeSlot:    r["timeSlot"]!,
//       tableName:   r["tableName"]!,
//     ))
//         .toList();
//     debugPrint("── _completedEntries: ${result.length} complete");
//     for (final e in result) {
//       debugPrint(
//           "  ✅ meal=${e.mealType} "
//               "seating=${e.seatingType} "
//               "time=${e.timeSlot} "
//               "table=${e.tableName}");
//     }
//     return result;
//   }
//
//   // ─── Build summary ────────────────────────────────────────────────────
//   BookingSummary? buildSummary() {
//     final entries = _completedEntries();
//     if (entries.isEmpty) return null;
//
//     currentSummary = BookingSummary(
//       restaurantId: restaurantId,
//       guests:       guests.value,
//       bookingDate:  _date(selectedDate.value),
//       bookings: entries
//           .map((e) => CartBookingItem(
//         seatingType: e.seatingType,
//         mealType:    e.mealType,
//         timeSlot:    e.timeSlot,
//         tableName:   e.tableName,
//       ))
//           .toList(),
//     );
//
//     debugPrint("── buildSummary: ${currentSummary!.bookings.length} bookings");
//     for (final b in currentSummary!.bookings) {
//       debugPrint(
//           "  📦 meal=${b.mealType} "
//               "seating=${b.seatingType} "
//               "time=${b.timeSlot} "
//               "table=${b.tableName}");
//     }
//
//     return currentSummary;
//   }
//
//   // ─── Save to DB ───────────────────────────────────────────────────────
//   Future<bool> confirmAndSave() async {
//     final summary = currentSummary;
//     if (summary == null || summary.bookings.isEmpty) {
//       const msg = "No booking data found.";
//       errorMessage.value = msg;
//       AppSnackbar.warning(msg);
//       return false;
//     }
//
//     try {
//       isSaving.value = true;
//       final token = _token();
//
//       debugPrint("── CONFIRM: sending ${summary.bookings.length} booking(s)");
//       for (final b in summary.bookings) {
//         debugPrint(
//             "  📤 meal=${b.mealType} "
//                 "seating=${b.seatingType} "
//                 "time=${b.timeSlot} "
//                 "table=${b.tableName}");
//       }
//
//       final body = jsonEncode({
//         "restaurant_id": summary.restaurantId,
//         "guests":        summary.guests,
//         "booking_date":  summary.bookingDate,
//         "bookings": summary.bookings
//             .map((b) => {
//           "seating_type": b.seatingType,
//           "meal_type":    b.mealType,
//           "time_slot":    b.timeSlot,
//           "table_name":   b.tableName,
//         })
//             .toList(),
//       });
//
//       debugPrint("── CONFIRM FULL BODY: $body");
//
//       final res = await http.post(
//         Uri.parse("$_base/restaurant-booking/confirm"),
//         headers: _headers(token),
//         body: body,
//       );
//
//       debugPrint("── CONFIRM RESPONSE ${res.statusCode} ${res.body}");
//
//       if (res.statusCode == 200) {
//         final parsed = ConfirmBookingResponse.fromJson(_safe(res.body));
//
//         if (parsed.status == 1) {
//           AppSnackbar.success(
//             parsed.message.isNotEmpty
//                 ? parsed.message
//                 : "Booking confirmed successfully!",
//           );
//           currentSummary = null;
//           return true;
//         } else {
//           final msg = parsed.message.isNotEmpty
//               ? parsed.message
//               : "Booking failed.";
//           errorMessage.value = msg;
//           AppSnackbar.error(msg);
//           return false;
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(res);
//         errorMessage.value = msg;
//         AppSnackbar.error(msg);
//         return false;
//       }
//     } catch (e, st) {
//       final msg = ApiErrorHandler.handleException(e);
//       errorMessage.value = msg;
//       AppSnackbar.error(msg);
//       debugPrintStack(stackTrace: st, label: "confirmAndSave");
//       return false;
//     } finally {
//       isSaving.value = false;
//     }
//   }
//
//   // ─── Helpers ──────────────────────────────────────────────────────────
//   String _token() {
//     final t = GetStorage().read<String>("auth_token") ?? "";
//     debugPrint("── TOKEN: '$t'");
//     return t;
//   }
//
//   Map<String, String> _headers(String token) => {
//     "Content-Type": "application/json",
//     "Accept":       "application/json",
//     if (token.isNotEmpty) "Authorization": "Bearer $token",
//   };
//
//   String _date(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}"
//           "-${d.day.toString().padLeft(2, '0')}";
// }
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

  // ─── Selections ───────────────────────────────────────────────────────
  var guests    = 1.obs;
  var maxGuests = 99.obs; // tightened by API response

  var selectedDate = DateTime.now().obs;

  // ─── API data ─────────────────────────────────────────────────────────
  var meals         = <MealSlot>[].obs;
  var seatingGroups = <SeatingTableGroup>[].obs;

  // ─── One RxMap row per meal ───────────────────────────────────────────
  var bookingRows = <RxMap<String, String>>[].obs;

  // ─── UI state ─────────────────────────────────────────────────────────
  var isLoadingSlots  = false.obs;
  var isLoadingTables = false.obs;
  var isSaving        = false.obs;
  var errorMessage    = "".obs;

  // ─── Holds the confirmed summary ──────────────────────────────────────
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

  // ─── Safe JSON decode ─────────────────────────────────────────────────
  Map<String, dynamic> _safe(String body) {
    try {
      final d = jsonDecode(body);
      if (d is Map<String, dynamic>) return d;
      return {"status": 0, "message": "Unexpected response", "data": d};
    } catch (_) {
      return {"status": 0, "message": "Invalid JSON", "data": null};
    }
  }

  // ─── 1. Fetch meals + time-slots ──────────────────────────────────────
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
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      errorMessage.value = msg;
      AppSnackbar.error(msg);
      debugPrintStack(stackTrace: st, label: "fetchTimeSlots");
    } finally {
      isLoadingSlots.value = false;
    }
  }

  // ─── 2. Fetch tables by guest count ───────────────────────────────────
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
          // ✅ Tables found for this guest count — valid
          seatingGroups.value = parsed.data;
          if (guests.value > maxGuests.value) {
            maxGuests.value = guests.value;
          }
          for (final row in bookingRows) {
            row["tableName"] = "";
          }
          bookingRows.refresh();
        } else {
          // ❌ No tables — guest count exceeds capacity, clamp back
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
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      errorMessage.value = msg;
      AppSnackbar.error(msg);
      debugPrintStack(stackTrace: st, label: "_fetchTablesByGuests");
    } finally {
      isLoadingTables.value = false;
    }
  }

  // ─── Build one row per meal ───────────────────────────────────────────
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

  // ─── Derived ──────────────────────────────────────────────────────────
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

  // ─── Row setters ──────────────────────────────────────────────────────
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

  // ─── Filter only fully completed rows ─────────────────────────────────
  List<BookingEntry> _completedEntries() {
    debugPrint("── _completedEntries: checking ${bookingRows.length} rows");
    for (int i = 0; i < bookingRows.length; i++) {
      final r = bookingRows[i];
      debugPrint(
          "  row[$i] meal=${r['mealType']} "
              "seating=${r['seatingType']} "
              "time=${r['timeSlot']} "
              "table=${r['tableName']}");
    }
    final result = bookingRows
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
    debugPrint("── _completedEntries: ${result.length} complete");
    for (final e in result) {
      debugPrint(
          "  ✅ meal=${e.mealType} "
              "seating=${e.seatingType} "
              "time=${e.timeSlot} "
              "table=${e.tableName}");
    }
    return result;
  }

  // ─── Build summary ────────────────────────────────────────────────────
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

    debugPrint("── buildSummary: ${currentSummary!.bookings.length} bookings");
    for (final b in currentSummary!.bookings) {
      debugPrint(
          "  📦 meal=${b.mealType} "
              "seating=${b.seatingType} "
              "time=${b.timeSlot} "
              "table=${b.tableName}");
    }

    return currentSummary;
  }

  // ─── Save to DB ───────────────────────────────────────────────────────
  Future<bool> confirmAndSave() async {
    final summary = currentSummary;
    if (summary == null || summary.bookings.isEmpty) {
      const msg = "No booking data found.";
      errorMessage.value = msg;
      AppSnackbar.warning(msg);
      return false;
    }

    try {
      isSaving.value = true;
      final token = _token();

      debugPrint("── CONFIRM: sending ${summary.bookings.length} booking(s)");
      for (final b in summary.bookings) {
        debugPrint(
            "  📤 meal=${b.mealType} "
                "seating=${b.seatingType} "
                "time=${b.timeSlot} "
                "table=${b.tableName}");
      }

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
          AppSnackbar.success(
            parsed.message.isNotEmpty
                ? parsed.message
                : "Booking confirmed successfully!",
          );
          currentSummary = null;
          return true;
        } else {
          final msg = parsed.message.isNotEmpty
              ? parsed.message
              : "Booking failed.";
          errorMessage.value = msg;
          AppSnackbar.error(msg);
          return false;
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(res);
        errorMessage.value = msg;
        AppSnackbar.error(msg);
        return false;
      }
    } catch (e, st) {
      final msg = ApiErrorHandler.handleException(e);
      errorMessage.value = msg;
      AppSnackbar.error(msg);
      debugPrintStack(stackTrace: st, label: "confirmAndSave");
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────
  String _token() {
    final t = GetStorage().read<String>("auth_token") ?? "";
    debugPrint("── TOKEN: '$t'");
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