
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyEventsController extends GetxController {
  var isLoading = true.obs;
  var events = <Event>[].obs;

  final box = GetStorage();
  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/eventss";

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;
    final token = box.read("auth_token") ?? "";

    if (token.isEmpty) {
      isLoading.value = false;
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "1" || data['status'] == 1) {
          final loadedEvents = (data['data'] as List)
              .map((e) => Event.fromJson(e))
              .toList();
          events.assignAll(loadedEvents);
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to fetch events");
        }
      } else {
        Get.snackbar("Error", "Server error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final token = box.read("auth_token") ?? "";
    try {
      final response = await http.delete(
        Uri.parse("$apiUrl/$eventId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        events.removeWhere((e) => e.id == eventId);
        Get.snackbar("Success", "Event deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete event");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
class Event {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String location;       // event_location (fallback)
  final String district;       // district field
  final String mainLocation;   // main_location field
  final String bannerImage;
  final String createdByType;
  final String createdById;

  Event({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.district,
    required this.mainLocation,
    required this.bannerImage,
    required this.createdByType,
    required this.createdById,
  });

  /// Time range shown in UI card
  String get time => "$startTime – $endTime";

  /// Priority: district → main_location → event_location
  String get displayLocation {
    if (district.isNotEmpty) return district;
    if (mainLocation.isNotEmpty) return mainLocation;
    return location;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id:            json['id']?.toString() ?? '',
      eventName:     json['event_name']      ?? '',
      startDate:     json['start_date']      ?? '',
      endDate:       json['end_date']        ?? '',
      startTime:     json['start_time']      ?? '',
      endTime:       json['end_time']        ?? '',
      location:      json['event_location']  ?? '',
      district:      json['district']        ?? '',       // ← new
      mainLocation:  json['main_location']   ?? '',       // ← new
      bannerImage:   json['banner_image']    ?? '',
      createdByType: json['created_by_type'] ?? '',
      createdById:   json['created_by_id']?.toString() ?? '',
    );
  }
}