import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyEventsController extends GetxController {
  var isLoading = true.obs;
  var events = <Event>[].obs;

  final box = GetStorage();
  final String apiUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/events";

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
          List<Event> loadedEvents = [];
          for (var e in data['data']) {
            loadedEvents.add(Event.fromJson(e));
          }
          events.assignAll(loadedEvents);
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to fetch events");
        }
      } else {
        Get.snackbar("Error", "Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

class Event {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String time;
  final String location;
  final String bannerImage;
  final String createdByType;
  final String createdById;

  Event({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.location,
    required this.bannerImage,
    required this.createdByType,
    required this.createdById,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['event_name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      time: json['time'],
      location: json['event_location'],
      bannerImage: json['banner_image'],
      createdByType: json['created_by_type'],
      createdById: json['created_by_id'],
    );
  }
}
