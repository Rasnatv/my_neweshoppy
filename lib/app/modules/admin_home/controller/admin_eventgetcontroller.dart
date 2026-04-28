
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AdminEventGetController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var filteredEvents = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'all'.obs;

  final box = GetStorage();

  final String apiUrl =
      "https://eshoppy.co.in/api/get-all-events-admin-district";

  String get _token => box.read('auth_token')?.toString().trim() ?? '';

  bool _checkAuth() {
    if (_token.isEmpty) {
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  // ───────────────── FETCH EVENTS ─────────────────
  Future<void> fetchEvents() async {
    if (!_checkAuth()) return;

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        events.value = List<Map<String, dynamic>>.from(data['data']);
        applyFilter(selectedFilter.value);
      } else {
        events.clear();
        filteredEvents.clear();
        AppSnackbar.error(
          ApiErrorHandler.handleResponse(response),
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── FILTER ─────────────────
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

  String getCreatorType(Map event) =>
      event['created_by_type'] ?? 'unknown';

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

  // ───────────────── TIME FORMAT ─────────────────
  String formatDisplayTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return '--';

    final formats = [
      'hh:mm a',
      'h:mm a',
      'HH:mm:ss',
      'HH:mm',
      'H:mm',
    ];

    for (final fmt in formats) {
      try {
        final dt = DateFormat(fmt).parse(timeStr.trim());
        return DateFormat('h:mm a').format(dt);
      } catch (_) {}
    }

    return timeStr;
  }

  // ───────────────── DELETE EVENT ─────────────────
  Future<void> deleteEvent(int eventId) async {
    if (!_checkAuth()) return;

    try {
      final response = await http.delete(
        Uri.parse(
            "https://eshoppy.co.in/api/delete-Event-admindistrict"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
        body: {
          "event_id": eventId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        AppSnackbar.success(data['message'] ?? "Deleted successfully");

        events.removeWhere(
              (e) => int.tryParse(e['id'].toString()) == eventId,
        );

        filteredEvents.removeWhere(
              (e) => int.tryParse(e['id'].toString()) == eventId,
        );

        await fetchEvents();
      } else {
        AppSnackbar.error(
          ApiErrorHandler.handleResponse(response),
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }
}