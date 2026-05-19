
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../merchantlogin/widget/successwidget.dart';
import '../views/myevents.dart';
import '../../../data/errors/api_error.dart';

class AddEventController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  var eventDate      = "".obs;
  var eventEndDate   = "".obs;
  var eventStartTime = "".obs;
  var eventEndTime   = "".obs;
  var bannerImage    = Rx<File?>(null);
  var isLoading      = false.obs;

  var errorStartDate = Rx<String?>(null);
  var errorEndDate   = Rx<String?>(null);
  var errorStartTime = Rx<String?>(null);
  var errorEndTime   = Rx<String?>(null);
  var errorBanner    = Rx<String?>(null);
  var errorState     = Rx<String?>(null);
  var errorDistrict  = Rx<String?>(null);
  var errorArea      = Rx<String?>(null);

  var stateList    = <String>[].obs;
  var districtList = <String>[].obs;
  var areaList     = <String>[].obs;

  var selectedState    = Rx<String?>(null);
  var selectedDistrict = Rx<String?>(null);
  var selectedArea     = Rx<String?>(null);

  var isLoadingStates    = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingAreas     = false.obs;

  var showMode = "district".obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  final String apiUrl       = "https://entenaadu.co.in/api/create-event";
  final String statesUrl    = "https://entenaadu.co.in/api/get-states";
  final String districtsUrl = "https://entenaadu.co.in/api/districts";
  final String areasUrl     = "https://entenaadu.co.in/api/areas";

  @override
  void onInit() {
    super.onInit();
    fetchStates();

    // When state changes → fetch districts, reset district & area
    ever(selectedState, (val) {
      selectedDistrict.value = null;
      selectedArea.value     = null;
      districtList.clear();
      areaList.clear();
      errorDistrict.value = null;
      errorArea.value     = null;
      if (val != null) fetchDistricts(val);
    });

    // When district changes → fetch areas (only in area mode), reset area
    ever(selectedDistrict, (val) {
      selectedArea.value = null;
      areaList.clear();
      errorArea.value = null;
      if (val != null && showMode.value == "area") fetchAreas(val);
    });

    // When mode switches to "area" and a district is already selected → load areas
    ever(showMode, (mode) {
      if (mode == "area" &&
          selectedDistrict.value != null &&
          areaList.isEmpty) {
        fetchAreas(selectedDistrict.value!);
      }
    });
  }

  // ── FETCH STATES ──────────────────────────────────────────────────────────
  Future<void> fetchStates() async {
    isLoadingStates.value = true;
    final token = box.read("auth_token");

    try {
      final response = await http.get(
        Uri.parse(statesUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == true || data['status'] == 1) &&
            data['data'] != null) {
          stateList.assignAll(List<String>.from(data['data']));
        }
      } else {
        ApiErrorHandler.handleResponse(response);
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ── FETCH DISTRICTS (requires state) ─────────────────────────────────────
  Future<void> fetchDistricts(String state) async {
    isLoadingDistricts.value = true;
    final token = box.read("auth_token");

    try {
      final response = await http.post(
        Uri.parse(districtsUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"state": state}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == true || data['status'] == 1) &&
            data['data'] != null) {
          districtList.assignAll(List<String>.from(data['data']));
        }
      } else {
        ApiErrorHandler.handleResponse(response);
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ── FETCH AREAS (requires district) ──────────────────────────────────────
  Future<void> fetchAreas(String district) async {
    isLoadingAreas.value = true;
    final token = box.read("auth_token");

    try {
      final response = await http.post(
        Uri.parse(areasUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"district": district}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == true || data['status'] == 1) &&
            data['data'] != null) {
          areaList.assignAll(List<String>.from(data['data']));
        }
      } else {
        ApiErrorHandler.handleResponse(response);
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ── PICK BANNER IMAGE ─────────────────────────────────────────────────────
  Future<void> pickBannerImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;

    File file = File(picked.path);

    final int bytes = await file.length();
    if (bytes > 1024 * 1024) {
      errorBanner.value = "Image must be less than 1 MB";
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Banner',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Banner',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (croppedFile == null) return;

    bannerImage.value = File(croppedFile.path);
    errorBanner.value = null;
  }

  void removeBannerImage() {
    bannerImage.value  = null;
    errorBanner.value  = "Please select a banner image";
  }

  // ── DATE PICKERS ──────────────────────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final now  = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(2035),
      initialDate: now,
    );
    if (date == null) return;

    eventDate.value =
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    errorStartDate.value = null;

    if (eventEndDate.value.isNotEmpty &&
        DateTime.parse(eventEndDate.value).isBefore(date)) {
      eventEndDate.value = "";
      errorEndDate.value = "End date must be after start date";
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final startDate = eventDate.value.isNotEmpty
        ? DateTime.parse(eventDate.value)
        : DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      lastDate: DateTime(2035),
      initialDate: startDate,
    );
    if (date == null) return;

    eventEndDate.value =
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    errorEndDate.value = null;
  }

  // ── TIME PICKERS ──────────────────────────────────────────────────────────
  Future<void> pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    eventStartTime.value = _formatTime(time);
    errorStartTime.value = null;
  }

  Future<void> pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    eventEndTime.value = _formatTime(time);
    errorEndTime.value = null;
  }

  String _formatTime(TimeOfDay time) {
    final hour   = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  // ── BASE64 ────────────────────────────────────────────────────────────────
  Future<String?> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  // ── VALIDATION ────────────────────────────────────────────────────────────
  bool _validatePickerFields() {
    bool valid = true;

    if (eventDate.value.isEmpty) {
      errorStartDate.value = "Start date is required";
      valid = false;
    }
    if (eventEndDate.value.isEmpty) {
      errorEndDate.value = "End date is required";
      valid = false;
    }
    if (eventStartTime.value.isEmpty) {
      errorStartTime.value = "Start time is required";
      valid = false;
    }
    if (eventEndTime.value.isEmpty) {
      errorEndTime.value = "End time is required";
      valid = false;
    }
    if (bannerImage.value == null) {
      errorBanner.value = "Please select a banner image";
      valid = false;
    }
    if (selectedState.value == null) {
      errorState.value = "State is required";
      valid = false;
    }
    if (selectedDistrict.value == null) {
      errorDistrict.value = "District is required";
      valid = false;
    }
    if (showMode.value == "area" && selectedArea.value == null) {
      errorArea.value = "Area is required";
      valid = false;
    }

    return valid;
  }


  Future<void> saveEvent() async {
    final formValid    = formKey.currentState?.validate() ?? false;
    final pickersValid = _validatePickerFields();
    if (!formValid || !pickersValid) return;

    isLoading.value = true;

    final token       = box.read("auth_token");
    final base64Image = await convertImageToBase64(bannerImage.value!);

    final requestData = <String, dynamic>{
      "event_name"    : eventName.text.trim(),
      "start_date"    : eventDate.value,
      "end_date"      : eventEndDate.value,
      "start_time"    : eventStartTime.value,
      "end_time"      : eventEndTime.value,
      "event_location": eventLocation.text.trim(),
      "state"         : selectedState.value,
      "district"      : selectedDistrict.value,
      "banner_image"  : base64Image,
    };

    if (showMode.value == "area" && selectedArea.value != null) {
      requestData["main_location"] = selectedArea.value;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization" : "Bearer $token",
          "Content-Type"  : "application/json",
          "Accept"        : "application/json",
        },
        body: jsonEncode(requestData),
      );

      isLoading.value = false;

      final data = jsonDecode(response.body);

      // ✅ Handle both string and int for status & status_code
      final status     = data['status'].toString();
      final statusCode = data['status_code'].toString();
      final message    = data['message'] ?? "Event created successfully";

      if (status == "1" || status == "true") {
        AppSnackbar.success(message);
        clearForm();
        Get.close(1);
        Get.off(() => MerchantEventsPage());
      } else {
        AppSnackbar.error(message);
      }

    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ── CLEAR ─────────────────────────────────────────────────────────────────
  void clearForm() {
    formKey.currentState?.reset();
    eventName.clear();
    eventLocation.clear();
    eventDate.value      = "";
    eventEndDate.value   = "";
    eventStartTime.value = "";
    eventEndTime.value   = "";
    bannerImage.value    = null;
    selectedState.value    = null;
    selectedDistrict.value = null;
    selectedArea.value     = null;
    districtList.clear();
    areaList.clear();
    showMode.value = "district";
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }
}
