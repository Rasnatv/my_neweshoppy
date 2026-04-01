
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminEventGetController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var filteredEvents = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'all'.obs;

  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/get-all-events-admin-district";

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final token = box.read('auth_token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        events.value = List<Map<String, dynamic>>.from(data['data']);
        applyFilter(selectedFilter.value);
      } else {
        events.clear();
        filteredEvents.clear();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load events");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    if (filter == 'all') {
      filteredEvents.value = events;
    } else {
      filteredEvents.value =
          events.where((e) => e['created_by_type'] == filter).toList();
    }
  }

  String getPostedByLabel(String type) {
    switch (type) {
      case 'admin':
        return 'Admin';
      case 'district_admin':
        return 'District Admin';
      case 'area_admin':
        return 'Area Admin';
      case 'merchant':
        return 'Merchant';
      default:
        return 'Unknown';
    }
  }

  String getCreatorType(Map event) => event['created_by_type'] ?? 'unknown';

  String getAreaInfo(Map event) {
    final district = (event['district'] ?? '').toString().trim();
    final mainLocation = (event['main_location'] ?? '').toString().trim();
    final eventLocation = (event['event_location'] ?? '').toString().trim();

    if (district.isNotEmpty && mainLocation.isNotEmpty) {
      return '$mainLocation, $district';
    } else if (district.isNotEmpty) {
      return district;
    } else if (mainLocation.isNotEmpty) {
      return mainLocation;
    } else if (eventLocation.isNotEmpty) {
      return eventLocation;
    }
    return 'N/A';
  }

  // ─── Time display formatter ───────────────────────────────────────────────
  // Converts any API time string to 12-hour format.
  // "14:46" → "2:46 PM" | "09:00" → "9:00 AM" | "11:00 AM" → "11:00 AM"
  String formatDisplayTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return '--';

    final formats = [
      'hh:mm a',  // "09:00 AM" / "01:46 PM"
      'h:mm a',   // "9:00 AM"  / "1:46 PM"
      'HH:mm:ss', // "14:46:00"
      'HH:mm',    // "14:46"
      'H:mm',     // "9:00"
    ];

    for (final fmt in formats) {
      try {
        final dt = DateFormat(fmt).parse(timeStr.trim());
        return DateFormat('h:mm a').format(dt); // h = no leading zero
      } catch (_) {}
    }

    return timeStr; // fallback: return raw if all parsers fail
  }
  // Future<void> deleteEvent(int eventId) async {
  //   try {
  //     final token = box.read('auth_token');
  //
  //     isLoading.value = true;
  //
  //     final response = await http.delete(
  //       Uri.parse(
  //           "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-Event-admindistrict"),
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: {
  //         "event_id": eventId.toString(),
  //       },
  //     );
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && data['status'] == true) {
  //       Get.snackbar("Success", data['message']);
  //
  //       // Remove deleted event locally (fast UI update)
  //       events.removeWhere((e) => e['id'] == eventId);
  //       filteredEvents.removeWhere((e) => e['id'] == eventId);
  //
  //       // OR you can refresh from API:
  //       // await fetchEvents();
  //
  //     } else {
  //       Get.snackbar("Error", data['message'] ?? "Delete failed");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to delete event");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> deleteEvent(int eventId) async {
    try {
      final token = box.read('auth_token');

      final response = await http.delete(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-Event-admindistrict"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "event_id": eventId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        Get.snackbar("Success", data['message']);

        // ✅ 1. Remove instantly from UI
        events.removeWhere(
              (e) => int.tryParse(e['id'].toString()) == eventId,
        );

        filteredEvents.removeWhere(
              (e) => int.tryParse(e['id'].toString()) == eventId,
        );

        // ✅ 2. Refresh from API (IMPORTANT)
        await fetchEvents();

      } else {
        Get.snackbar("Error", data['message'] ?? "Delete failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete event");
    }
  }



}