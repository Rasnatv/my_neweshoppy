
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../views/myevents.dart';

class AddEventController extends GetxController {
  final eventName = TextEditingController();
  final description = TextEditingController();
  final eventLocation = TextEditingController();

  var eventDate = "".obs;
  var eventEndDate = "".obs;
  var eventTime = "".obs;
  var bannerImage = Rx<File?>(null);
  var isLoading = false.obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  final String apiUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/create-event";

  // ---------------- IMAGE PICKER ----------------
  pickBannerImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) bannerImage.value = File(img.path);
  }

  removeBannerImage() {
    bannerImage.value = null;
  }

  // ---------------- DATE / TIME PICKER ----------------
  pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      eventDate.value = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    }
  }

  pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      eventEndDate.value = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    }
  }

  pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final hour = time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      eventTime.value = "${hour == 0 ? 12 : hour}:$minute $period";
    }
  }

  // ---------------- CONVERT IMAGE ----------------
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      String extension = imageFile.path.split('.').last.toLowerCase();
      String mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
      return "data:$mimeType;base64,${base64Encode(bytes)}";
    } catch (e) {
      print("Image conversion error: $e");
      return null;
    }
  }

  // ---------------- SAVE EVENT ----------------
  saveEvent() async {
    // Validation
    if (eventName.text.isEmpty) return _error("Enter event name");
    if (eventDate.value.isEmpty) return _error("Select Start Date");
    if (eventEndDate.value.isEmpty) return _error("Select End Date");
    if (eventTime.value.isEmpty) return _error("Select Time");
    if (eventLocation.text.isEmpty) return _error("Enter event location");
    if (bannerImage.value == null) return _error("Select a banner image");

    try {
      DateTime start = DateTime.parse(eventDate.value);
      DateTime end = DateTime.parse(eventEndDate.value);
      if (end.isBefore(start)) return _error("End Date cannot be before Start Date");
    } catch (e) {
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

    final requestData = {
      "event_name": eventName.text,
      "start_date": eventDate.value,
      "end_date": eventEndDate.value,
      "time": eventTime.value,
      "event_location": eventLocation.text,
      "banner_image": base64Image,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
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
            // colorText: Colors.white,
          );

          clearForm();

          // Navigate directly to MyEventsPage
          Get.offAll(() => MerchantEventsPage());
        }

        else {
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

  void _error(String msg) {
    Get.snackbar("Error", msg, backgroundColor: Colors.red, colorText: Colors.white);
  }

  void clearForm() {
    eventName.clear();
    description.clear();
    eventLocation.clear();
    eventDate.value = "";
    eventEndDate.value = "";
    eventTime.value = "";
    bannerImage.value = null;
  }

  @override
  void onClose() {
    eventName.dispose();
    description.dispose();
    eventLocation.dispose();
    super.onClose();
  }
}


