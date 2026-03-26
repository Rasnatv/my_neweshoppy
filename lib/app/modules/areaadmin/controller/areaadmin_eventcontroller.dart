
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../view/area_adminhome.dart';
// import '../controller/area_adminhome_controller.dart'; // OPTIONAL if you have

class AreaAdminEventAddController extends GetxController {

  // ─── Form Controllers ─────────────────────────────
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();

  // ─── Observable Fields ────────────────────────────
  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxString startTime = ''.obs;
  final RxString endTime = ''.obs;
  final RxString selectedMainLocation = ''.obs;
  final Rx<File?> bannerImage = Rx<File?>(null);

  // ─── State ────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isLocationsLoading = false.obs;
  final RxList<String> mainLocations = <String>[].obs;

  // ─── Storage & Picker ─────────────────────────────
  final _box = GetStorage();
  final _picker = ImagePicker();

  // ─── API Base ─────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin';

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchMainLocations();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Auth Token ───────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_authToken',
    'Accept': 'application/json',
  };

  // ─── Fetch Main Locations ─────────────────────────
  Future<void> fetchMainLocations() async {
    if (_authToken.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isLocationsLoading.value = true;

      final response = await http.get(
        Uri.parse('$_baseUrl/main-locations'),
        headers: _headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        mainLocations.assignAll(data.map((e) => e.toString()).toList());
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError('Error', body['message'] ?? 'Failed to load locations');
      }
    } catch (e) {
      _showError('Network Error', e.toString());
    } finally {
      isLocationsLoading.value = false;
    }
  }

  // ─── Date Pickers ─────────────────────────────────
  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (picked != null) {
      startDate.value = DateFormat('yyyy-MM-dd').format(picked);

      if (endDate.value.isNotEmpty) {
        final end = DateTime.parse(endDate.value);
        if (end.isBefore(picked)) endDate.value = '';
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final initialDate = startDate.value.isNotEmpty
        ? DateTime.parse(startDate.value)
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (picked != null) {
      endDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // ─── Time Pickers ─────────────────────────────────
  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      startTime.value = picked.format(context);
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      endTime.value = picked.format(context);
    }
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6C63FF),
        ),
      ),
      child: child!,
    );
  }

  // ─── Image Picker ─────────────────────────────────
  Future<void> pickBannerImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file != null) {
      bannerImage.value = File(file.path);
    }
  }

  // ─── Validate Form ────────────────────────────────
  bool _validateForm() {
    if (eventName.text.trim().isEmpty) {
      _showError('Error', 'Enter event name');
      return false;
    } else if (startDate.value.isEmpty || endDate.value.isEmpty) {
      _showError('Error', 'Select dates');
      return false;
    } else if (startTime.value.isEmpty || endTime.value.isEmpty) {
      _showError('Error', 'Select time');
      return false;
    } else if (selectedMainLocation.value.isEmpty) {
      _showError('Error', 'Select main location');
      return false;
    } else if (eventLocation.text.trim().isEmpty) {
      _showError('Error', 'Enter event location');
      return false;
    } else if (bannerImage.value == null) {
      _showError('Error', 'Select banner image');
      return false;
    }
    return true;
  }

  // ─── Submit Event ─────────────────────────────────
  Future<void> addEvent() async {

    if (!_validateForm()) return;

    if (_authToken.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isLoading.value = true;

      final bytes = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final body = {
        'event_name': eventName.text.trim(),
        'start_date': startDate.value,
        'end_date': endDate.value,
        'start_time': startTime.value,
        'end_time': endTime.value,
        'main_location': selectedMainLocation.value,
        'event_location': eventLocation.text.trim(),
        'banner_image': base64Image,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/create-event'),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {

        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Event created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        _resetForm();

        // 🔥 Navigate to Home (Clear stack)
        Get.offAll(() => AreaAdminhomepage());

        // OPTIONAL: Refresh home data if controller exists
        // if (Get.isRegistered<AreaAdminHomeController>()) {
        //   Get.find<AreaAdminHomeController>().fetchEvents();
        // }

      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError('Error', responseData['message'] ?? 'Failed to create event');
      }

    } catch (e) {
      _showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset ────────────────────────────────────────
  void _resetForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    selectedMainLocation.value = '';
    bannerImage.value = null;
  }

  // ─── Unauthorized ─────────────────────────────────
  void _handleUnauthorized() {
    Get.snackbar(
      'Session Expired',
      'Please login again',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    _box.erase();
    Get.offAll(() => AreaAdminhomepage());
  }

  // ─── Error Snackbar ───────────────────────────────
  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}