//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
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
//   // ---------------- IMAGE PICK ----------------
//   Future<void> pickBannerImage() async {
//     final img = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );
//     if (img != null) bannerImage.value = File(img.path);
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
//     if (date != null) {
//       _selectedStartDate = date;
//       startDate.value = _formatDate(date);
//       endDate.value = ''; // reset end date
//     }
//   }
//
//   // ---------------- END DATE ----------------
//   Future<void> pickEndDate(BuildContext context) async {
//     if (_selectedStartDate == null) {
//       Get.snackbar("Error", "Select start date first");
//       return;
//     }
//     final date = await showDatePicker(
//       context: context,
//       firstDate: _selectedStartDate!,
//       lastDate: DateTime(2035),
//       initialDate: _selectedStartDate!,
//     );
//     if (date != null) endDate.value = _formatDate(date);
//   }
//
//   // ---------------- TIME ----------------
//   Future<void> pickTime(BuildContext context) async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time != null) {
//       final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//       final minute = time.minute.toString().padLeft(2, '0');
//       final period = time.period == DayPeriod.am ? 'AM' : 'PM';
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
//       final token = box.read('auth_token');
//       if (token == null) {
//         Get.snackbar("Session Expired", "Please login again");
//         return;
//       }
//
//       final imgBytes = await bannerImage.value!.readAsBytes();
//
//       final body = {
//         "event_name": eventName.text.trim(),
//         "start_date": startDate.value,
//         "end_date": endDate.value,
//         "time": eventTime.value,
//         "event_location": eventLocation.text.trim(),
//         "banner_image": "data:image/jpeg;base64,${base64Encode(imgBytes)}",
//         if (description.text.isNotEmpty) "description": description.text.trim(),
//       };
//
//       final response = await http.post(
//         Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/create-event"),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${token.trim()}",
//         },
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         clearForm();
//         await fetchEvents(); // refresh events automatically
//         Get.back(result: true);
//         Get.snackbar("Success", "Event added successfully");
//       } else {
//         final res = jsonDecode(response.body);
//         Get.snackbar("Error", res['message'] ?? "Failed to add event");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ---------------- DELETE EVENT ----------------
//   Future<void> deleteEvent(String id) async {
//     final token = box.read('auth_token');
//     if (token == null) {
//       Get.snackbar("Session Expired", "Please login again");
//       return;
//     }
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
//       final response = await http.delete(
//         Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event/$id"),
//         headers: {"Authorization": "Bearer ${token.trim()}"},
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         events.removeWhere((e) => e['id'].toString() == id);
//         Get.snackbar("Deleted", "Event removed");
//       } else {
//         final res = jsonDecode(response.body);
//         Get.snackbar("Error", res['message'] ?? "Failed to delete event");
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ---------------- FETCH EVENTS ----------------
//   Future<void> fetchEvents() async {
//     final token = box.read('auth_token');
//     if (token == null) {
//       Get.snackbar("Session Expired", "Please login again");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       final response = await http.get(
//         Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
//         headers: {"Authorization": "Bearer ${token.trim()}"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         events.value = List<Map<String, dynamic>>.from(data['events'] ?? []);
//       } else {
//         final res = jsonDecode(response.body);
//         Get.snackbar("Error", res['message'] ?? "Failed to fetch events");
//       }
//     } catch (_) {
//       Get.snackbar("Error", "Failed to fetch events");
//     } finally {
//       isLoading.value = false;
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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/models/admin_addeventmodel.dart';


class AdminEventAddController extends GetxController {
  // ─── State ───────────────────────────────────────────────
  var events    = <AdminaddEventModel>[].obs;
  var isLoading = false.obs;

  // ─── Form Controllers ────────────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  // ─── Date / Time Observables ─────────────────────────────
  final startDate = ''.obs;
  final endDate   = ''.obs;
  final startTime = ''.obs; // ✅ was single 'eventTime', now split
  final endTime   = ''.obs; // ✅ new field matching API

  // ─── Banner Image ────────────────────────────────────────
  final bannerImage = Rx<File?>(null);

  // ─── Storage & Picker ───────────────────────────────────
  final box    = GetStorage();
  final picker = ImagePicker();

  DateTime? _selectedStartDate;

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Image Pick / Remove ─────────────────────────────────
  Future<void> pickBannerImage() async {
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) bannerImage.value = File(img.path);
  }

  void removeBannerImage() => bannerImage.value = null;

  // ─── Date Pickers ────────────────────────────────────────
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      _selectedStartDate = date;
      startDate.value   = _formatDate(date);
      endDate.value     = ''; // reset end date when start changes
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (_selectedStartDate == null) {
      Get.snackbar("Error", "Select start date first",
          backgroundColor: Colors.red, colorText: Colors.white);
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

  // ─── Time Pickers ────────────────────────────────────────
  Future<void> pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) startTime.value = _formatTime(time);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) endTime.value = _formatTime(time);
  }

  // ─── Add Event ───────────────────────────────────────────
  Future<void> addEvent() async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token');
      if (token == null || token.toString().isEmpty) {
        Get.snackbar("Session Expired", "Please login again",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // ✅ Convert image to base64
      final imgBytes  = await bannerImage.value!.readAsBytes();
      final imgBase64 = "data:image/jpeg;base64,${base64Encode(imgBytes)}";

      // ✅ Request body matching API exactly
      final body = {
        "event_name":     eventName.text.trim(),
        "start_date":     startDate.value,
        "end_date":       endDate.value,
        "start_time":     startTime.value,   // ✅ was "time"
        "end_time":       endTime.value,     // ✅ new field
        "event_location": eventLocation.text.trim(),
        "banner_image":   imgBase64,
      };

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/create-event"),
        headers: {
          "Accept":        "application/json",
          "Content-Type":  "application/json",
          "Authorization": "Bearer ${token.toString().trim()}",
        },
        body: jsonEncode(body),
      );

      final res = jsonDecode(response.body);

      // ✅ API returns status as String "1" not bool true
      if (res['status'].toString() == '1' ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        // ✅ Parse created event from response
        final newEvent = AdminaddEventModel.fromJson(res['data']);
        events.insert(0, newEvent); // add to top of list

        clearForm();
        Get.back(result: true);
        Get.snackbar(
          "Success",
          res['message'] ?? "Event created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          res['message'] ?? "Failed to create event",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Fetch Events ────────────────────────────────────────
  Future<void> fetchEvents() async {
    final token = box.read('auth_token');
    if (token == null || token.toString().isEmpty) {
      Get.snackbar("Session Expired", "Please login again",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
        headers: {
          "Accept":        "application/json",
          "Authorization": "Bearer ${token.toString().trim()}",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'] ?? data['events'] ?? [];
        events.value = list.map((e) => AdminaddEventModel.fromJson(e)).toList();

        // Sort latest first
        events.sort((a, b) => b.id.compareTo(a.id));
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch events",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Delete Event ────────────────────────────────────────
  Future<void> deleteEvent(String id) async {
    final token = box.read('auth_token');
    if (token == null) return;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Event",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
        const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event/$id"),
        headers: {"Authorization": "Bearer ${token.toString().trim()}"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        events.removeWhere((e) => e.id == id);
        Get.snackbar("Deleted", "Event removed successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar(
            "Error", res['message'] ?? "Failed to delete event",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Clear Form ──────────────────────────────────────────
  void clearForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value       = '';
    endDate.value         = '';
    startTime.value       = '';
    endTime.value         = '';
    bannerImage.value     = null;
    _selectedStartDate    = null;
  }

  // ─── Helpers ─────────────────────────────────────────────
  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _formatTime(TimeOfDay t) {
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }
}