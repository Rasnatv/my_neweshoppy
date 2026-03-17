
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../views/myevents.dart';

class AddEventController extends GetxController {
  final eventName     = TextEditingController();
  final description   = TextEditingController();
  final eventLocation = TextEditingController();

  // ── Observables ───────────────────────────────────────────
  var eventDate      = "".obs;
  var eventEndDate   = "".obs;
  var eventStartTime = "".obs; // ← was eventTime
  var eventEndTime   = "".obs; // ← NEW
  var bannerImage    = Rx<File?>(null);
  var isLoading      = false.obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/create-event";

  // ── IMAGE PICKER ──────────────────────────────────────────
  pickBannerImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) bannerImage.value = File(img.path);
  }

  removeBannerImage() {
    bannerImage.value = null;
  }

  // ── DATE PICKERS ──────────────────────────────────────────
  pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      eventDate.value =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      // reset end date if now before start
      if (eventEndDate.value.isNotEmpty) {
        final end = DateTime.tryParse(eventEndDate.value);
        if (end != null && end.isBefore(date)) eventEndDate.value = "";
      }
    }
  }

  pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: eventDate.value.isNotEmpty
          ? DateTime.parse(eventDate.value)
          : DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: eventDate.value.isNotEmpty
          ? DateTime.parse(eventDate.value)
          : DateTime.now(),
    );
    if (date != null) {
      eventEndDate.value =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  // ── TIME PICKERS ──────────────────────────────────────────
  pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select Start Time",
    );
    if (time != null) {
      eventStartTime.value = _formatTime(time);
    }
  }

  pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select End Time",
    );
    if (time != null) {
      eventEndTime.value = _formatTime(time);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour   = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  // ── IMAGE → BASE64 ────────────────────────────────────────
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final ext      = imageFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      return "data:$mimeType;base64,${base64Encode(bytes)}";
    } catch (e) {
      debugPrint("Image conversion error: $e");
      return null;
    }
  }

  // ── SAVE EVENT ────────────────────────────────────────────
  saveEvent() async {
    // Validation
    if (eventName.text.isEmpty)       return _error("Enter event name");
    if (eventDate.value.isEmpty)      return _error("Select Start Date");
    if (eventEndDate.value.isEmpty)   return _error("Select End Date");
    if (eventStartTime.value.isEmpty) return _error("Select Start Time");
    if (eventEndTime.value.isEmpty)   return _error("Select End Time");
    if (eventLocation.text.isEmpty)   return _error("Enter event location");
    if (bannerImage.value == null)    return _error("Select a banner image");

    try {
      final start = DateTime.parse(eventDate.value);
      final end   = DateTime.parse(eventEndDate.value);
      if (end.isBefore(start)) {
        return _error("End Date cannot be before Start Date");
      }
    } catch (_) {
      return _error("Invalid date format");
    }

    isLoading.value = true;

    final base64Image = await convertImageToBase64(bannerImage.value!);
    if (base64Image == null) {
      isLoading.value = false;
      return _error("Failed to process image");
    }

    final token = box.read("auth_token") ?? "";
    if (token.isEmpty) {
      isLoading.value = false;
      return _error("Invalid token, please login again");
    }

    // ── Payload uses start_time + end_time ─────────────────
    final requestData = {
      "event_name"    : eventName.text.trim(),
      "start_date"    : eventDate.value,
      "end_date"      : eventEndDate.value,
      "start_time"    : eventStartTime.value,   // ← updated
      "end_time"      : eventEndTime.value,     // ← new
      "event_location": eventLocation.text.trim(),
      "banner_image"  : base64Image,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type" : "application/json",
          "Accept"       : "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestData),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == "1" || data['status'] == 1) {
          Get.snackbar(
            "Success",
            data['message'] ?? "Event created successfully",
            backgroundColor: const Color(0xFF00897B),
            colorText: Colors.white,
          );
          clearForm();
          Get.offAll(() => MerchantEventsPage());
        } else {
          _error(data['message'] ?? "Failed to create event");
        }
      } else {
        _error("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      _error("Unexpected error: $e");
    }
  }

  // ── HELPERS ───────────────────────────────────────────────
  void _error(String msg) {
    Get.snackbar("Error", msg,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void clearForm() {
    eventName.clear();
    description.clear();
    eventLocation.clear();
    eventDate.value      = "";
    eventEndDate.value   = "";
    eventStartTime.value = "";
    eventEndTime.value   = "";
    bannerImage.value    = null;
  }

  @override
  void onClose() {
    eventName.dispose();
    description.dispose();
    eventLocation.dispose();
    super.onClose();
  }
}