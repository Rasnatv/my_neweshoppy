//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class AdminEventAddController extends GetxController {
//   var events = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;
//
//   final eventName = TextEditingController();
//   final description = TextEditingController();
//   final eventLocation = TextEditingController();
//
//   final startDate = ''.obs;
//   final endDate = ''.obs;
//   final eventTime = ''.obs;
//
//   final bannerImage = Rx<File?>(null);
//
//   final box = GetStorage();
//   final ImagePicker picker = ImagePicker();
//
//   DateTime? _selectedStartDate;
//
//   // ---------------- IMAGE PICK (NO SIZE CHECK) ----------------
//   Future<void> pickBannerImage() async {
//     final img = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );
//
//     if (img == null) return;
//
//     bannerImage.value = File(img.path);
//   }
//
//   void removeBannerImage() {
//     bannerImage.value = null;
//   }
//
//   // ---------------- START DATE ----------------
//   Future<void> pickStartDate(BuildContext context) async {
//     final date = await showDatePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2035),
//       initialDate: DateTime.now(),
//     );
//
//     if (date != null) {
//       _selectedStartDate = date;
//       startDate.value = _formatDate(date);
//       endDate.value = '';
//     }
//   }
//
//   // ---------------- END DATE ----------------
//   Future<void> pickEndDate(BuildContext context) async {
//     if (_selectedStartDate == null) {
//       Get.snackbar("Error", "Select start date first");
//       return;
//     }
//
//     final date = await showDatePicker(
//       context: context,
//       firstDate: _selectedStartDate!,
//       lastDate: DateTime(2035),
//       initialDate: _selectedStartDate!,
//     );
//
//     if (date != null) {
//       endDate.value = _formatDate(date);
//     }
//   }
//
//   // ---------------- TIME ----------------
//   Future<void> pickTime(BuildContext context) async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (time != null) {
//       final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//       final minute = time.minute.toString().padLeft(2, '0');
//       final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//
//       eventTime.value = "$hour:$minute $period";
//     }
//   }
//
//   // ---------------- ADD EVENT ----------------
//   Future<void> addEvent() async {
//     if (eventName.text.isEmpty ||
//         eventLocation.text.isEmpty ||
//         startDate.value.isEmpty ||
//         endDate.value.isEmpty ||
//         eventTime.value.isEmpty ||
//         bannerImage.value == null) {
//       Get.snackbar("Error", "All fields are required");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final token = box.read('auth_token');
//       final imgBytes = await bannerImage.value!.readAsBytes();
//
//       final body = {
//         "event_name": eventName.text.trim(),
//         "start_date": startDate.value,
//         "end_date": endDate.value,
//         "time": eventTime.value,
//         "event_location": eventLocation.text.trim(),
//         "banner_image":
//         "data:image/jpeg;base64,${base64Encode(imgBytes)}",
//         if (description.text.isNotEmpty)
//           "description": description.text.trim(),
//       };
//
//       final response = await http.post(
//         Uri.parse(
//             "https://rasma.astradevelops.in/e_shoppyy/public/api/create-event"),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${token.toString().trim()}",
//         },
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         clearForm();
//         await fetchEvents();
//         Get.back(result: true);
//         Get.snackbar("Success", "Event added successfully");
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ---------------- DELETE EVENT ----------------
//   Future<void> deleteEvent(String id) async {
//     final token = box.read('auth_token');
//
//     final confirm = await Get.dialog<bool>(
//       AlertDialog(
//         title: const Text("Delete Event"),
//         content: const Text("Are you sure?"),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(result: false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Get.back(result: true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm != true) return;
//
//     try {
//       isLoading.value = true;
//
//       await http.delete(
//         Uri.parse(
//             "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event/$id"),
//         headers: {
//           "Authorization": "Bearer ${token.toString().trim()}",
//         },
//       );
//
//       events.removeWhere((e) => e['id'].toString() == id);
//       Get.snackbar("Deleted", "Event removed");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ---------------- FETCH EVENTS ----------------
//   Future<void> fetchEvents() async {
//     final token = box.read('auth_token');
//     if (token == null) return;
//
//     final response = await http.get(
//       Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
//       headers: {
//         "Authorization": "Bearer ${token.toString().trim()}",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       events.value =
//       List<Map<String, dynamic>>.from(data['events'] ?? []);
//     }
//   }
//
//   // ---------------- CLEAR FORM ----------------
//   void clearForm() {
//     eventName.clear();
//     description.clear();
//     eventLocation.clear();
//     startDate.value = '';
//     endDate.value = '';
//     eventTime.value = '';
//     bannerImage.value = null;
//     _selectedStartDate = null;
//   }
//
//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
// }
//
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminEventAddController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final eventName = TextEditingController();
  final description = TextEditingController();
  final eventLocation = TextEditingController();

  final startDate = ''.obs;
  final endDate = ''.obs;
  final eventTime = ''.obs;

  final bannerImage = Rx<File?>(null);

  final box = GetStorage();
  final ImagePicker picker = ImagePicker();

  DateTime? _selectedStartDate;

  // ---------------- IMAGE PICK ----------------
  Future<void> pickBannerImage() async {
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) bannerImage.value = File(img.path);
  }

  void removeBannerImage() {
    bannerImage.value = null;
  }

  // ---------------- START DATE ----------------
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      _selectedStartDate = date;
      startDate.value = _formatDate(date);
      endDate.value = ''; // reset end date
    }
  }

  // ---------------- END DATE ----------------
  Future<void> pickEndDate(BuildContext context) async {
    if (_selectedStartDate == null) {
      Get.snackbar("Error", "Select start date first");
      return;
    }
    final date = await showDatePicker(
      context: context,
      firstDate: _selectedStartDate!,
      lastDate: DateTime(2035),
      initialDate: _selectedStartDate!,
    );
    if (date != null) endDate.value = _formatDate(date);
  }

  // ---------------- TIME ----------------
  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      eventTime.value = "$hour:$minute $period";
    }
  }

  // ---------------- ADD EVENT ----------------
  Future<void> addEvent() async {
    if (eventName.text.isEmpty ||
        eventLocation.text.isEmpty ||
        startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        eventTime.value.isEmpty ||
        bannerImage.value == null) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      isLoading.value = true;
      final token = box.read('auth_token');
      if (token == null) {
        Get.snackbar("Session Expired", "Please login again");
        return;
      }

      final imgBytes = await bannerImage.value!.readAsBytes();

      final body = {
        "event_name": eventName.text.trim(),
        "start_date": startDate.value,
        "end_date": endDate.value,
        "time": eventTime.value,
        "event_location": eventLocation.text.trim(),
        "banner_image": "data:image/jpeg;base64,${base64Encode(imgBytes)}",
        if (description.text.isNotEmpty) "description": description.text.trim(),
      };

      final response = await http.post(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/create-event"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token.trim()}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearForm();
        await fetchEvents(); // refresh events automatically
        Get.back(result: true);
        Get.snackbar("Success", "Event added successfully");
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar("Error", res['message'] ?? "Failed to add event");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- DELETE EVENT ----------------
  Future<void> deleteEvent(String id) async {
    final token = box.read('auth_token');
    if (token == null) {
      Get.snackbar("Session Expired", "Please login again");
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event/$id"),
        headers: {"Authorization": "Bearer ${token.trim()}"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        events.removeWhere((e) => e['id'].toString() == id);
        Get.snackbar("Deleted", "Event removed");
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar("Error", res['message'] ?? "Failed to delete event");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- FETCH EVENTS ----------------
  Future<void> fetchEvents() async {
    final token = box.read('auth_token');
    if (token == null) {
      Get.snackbar("Session Expired", "Please login again");
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
        headers: {"Authorization": "Bearer ${token.trim()}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        events.value = List<Map<String, dynamic>>.from(data['events'] ?? []);
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar("Error", res['message'] ?? "Failed to fetch events");
      }
    } catch (_) {
      Get.snackbar("Error", "Failed to fetch events");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- CLEAR FORM ----------------
  void clearForm() {
    eventName.clear();
    description.clear();
    eventLocation.clear();
    startDate.value = '';
    endDate.value = '';
    eventTime.value = '';
    bannerImage.value = null;
    _selectedStartDate = null;
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
}
