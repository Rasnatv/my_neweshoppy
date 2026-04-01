
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
  final eventLocation = TextEditingController();

  var eventDate      = "".obs;
  var eventEndDate   = "".obs;
  var eventStartTime = "".obs;
  var eventEndTime   = "".obs;
  var bannerImage    = Rx<File?>(null);
  var isLoading      = false.obs;

  var areaList     = <String>[].obs;
  var districtList = <String>[].obs;

  var selectedArea     = Rx<String?>(null);
  var selectedDistrict = Rx<String?>(null);

  var isLoadingAreas     = false.obs;
  var isLoadingDistricts = false.obs;

  var showMode = "area".obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/create-event";
  final String areasUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/areas";
  final String districtsUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/districts";

  @override
  void onInit() {
    super.onInit();
    fetchAreas();
    fetchDistricts();
  }

  // ── FETCH AREAS ──────────────────────────────────────────
  fetchAreas() async {
    isLoadingAreas.value = true;
    try {
      final token = box.read("auth_token") ?? "";
      final response = await http.get(
        Uri.parse(areasUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      print("AREA RESPONSE: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          areaList.assignAll(List<String>.from(data['data']));
        }
      }
    } catch (e) {
      debugPrint("Area error: $e");
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ── FETCH DISTRICTS ──────────────────────────────────────
  fetchDistricts() async {
    isLoadingDistricts.value = true;
    try {
      final token = box.read("auth_token") ?? "";
      final response = await http.get(
        Uri.parse(districtsUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      print("DISTRICT RESPONSE: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          districtList.assignAll(List<String>.from(data['data']));
        }
      }
    } catch (e) {
      debugPrint("District error: $e");
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ── IMAGE PICKER ─────────────────────────────────────────
  pickBannerImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) bannerImage.value = File(img.path);
  }

  removeBannerImage() => bannerImage.value = null;

  // ── DATE PICKERS ─────────────────────────────────────────
  pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,              // ✅ Fixed: no past dates
      lastDate: DateTime(2035),
      initialDate: now,
    );
    if (date != null) {
      eventDate.value =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      // ✅ Reset end date if it's now before the new start date
      if (eventEndDate.value.isNotEmpty &&
          DateTime.parse(eventEndDate.value).isBefore(date)) {
        eventEndDate.value = "";
      }
    }
  }

  pickEndDate(BuildContext context) async {
    final startDate = eventDate.value.isNotEmpty
        ? DateTime.parse(eventDate.value)
        : DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: startDate,        // ✅ Fixed: end date can't be before start date
      lastDate: DateTime(2035),
      initialDate: startDate,
    );
    if (date != null) {
      eventEndDate.value =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  // ── TIME PICKERS ─────────────────────────────────────────
  pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) eventStartTime.value = _formatTime(time);
  }

  pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) eventEndTime.value = _formatTime(time);
  }

  String _formatTime(TimeOfDay time) {
    final hour   = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  // ── IMAGE → BASE64 ───────────────────────────────────────
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    } catch (e) {
      debugPrint("Image error: $e");
      return null;
    }
  }

  // ── SAVE EVENT ───────────────────────────────────────────
  saveEvent() async {
    if (eventName.text.isEmpty)       return _error("Enter event name");
    if (eventDate.value.isEmpty)      return _error("Select start date");
    if (eventEndDate.value.isEmpty)   return _error("Select end date");
    if (eventStartTime.value.isEmpty) return _error("Select start time");
    if (eventEndTime.value.isEmpty)   return _error("Select end time");
    if (eventLocation.text.isEmpty)   return _error("Enter location");
    if (bannerImage.value == null)    return _error("Select banner");

    if (showMode.value == "area" && selectedArea.value == null) {
      return _error("Select area");
    }
    if (showMode.value == "district" && selectedDistrict.value == null) {
      return _error("Select district");
    }

    isLoading.value = true;

    final base64Image = await convertImageToBase64(bannerImage.value!);
    final token       = box.read("auth_token") ?? "";

    // ✅ Fixed: extract raw String values BEFORE building the map
    //    to avoid passing Rx wrapper objects into JSON
    final String  mode           = showMode.value;
    final String? areaValue      = selectedArea.value;
    final String? districtValue  = selectedDistrict.value;
    final String  eventNameVal   = eventName.text.trim();
    final String  locationVal    = eventLocation.text.trim();

    // ✅ Build clean map with plain dart types only
    final Map<String, dynamic> requestData = {
      "event_name"     : eventNameVal,
      "start_date"     : eventDate.value,
      "end_date"       : eventEndDate.value,
      "start_time"     : eventStartTime.value,
      "end_time"       : eventEndTime.value,
      "event_location" : locationVal,
      "banner_image"   : base64Image,
    };


    if (mode == "area" && areaValue != null) {
      requestData["main_location"] = areaValue;
    } else if (mode == "district" && districtValue != null) {
      requestData["district"] = districtValue;
    }


    print("REQUEST PAYLOAD: ${jsonEncode(requestData)}"); // debug log

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type" : "application/json",
          "Accept"       : "application/json",
        },
        body: jsonEncode(requestData),
      );

      isLoading.value = false;

      print("SAVE RESPONSE: ${response.body}"); // debug log

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Event Created Successfully");
        clearForm();
        Get.offAll(() => MerchantEventsPage());
      } else {
        _error(data['message'] ?? data.toString());
      }
    } catch (e) {
      isLoading.value = false;
      _error("Error: $e");
    }
  }

  // ── HELPERS ──────────────────────────────────────────────
  void _error(String msg) => Get.snackbar(
    "Error", msg,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );

  void clearForm() {
    eventName.clear();
    eventLocation.clear();
    eventDate.value        = "";
    eventEndDate.value     = "";
    eventStartTime.value   = "";
    eventEndTime.value     = "";
    bannerImage.value      = null;
    selectedArea.value     = null;
    selectedDistrict.value = null;
    showMode.value         = "area";
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }
}